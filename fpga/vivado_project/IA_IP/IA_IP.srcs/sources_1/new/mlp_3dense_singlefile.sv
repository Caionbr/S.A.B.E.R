// ================================================================
// MLP 1D (181 -> 64 -> 32 -> 1) with simple pre-block and 3 DENSE layers
// Single-file SystemVerilog: pre-processing + Dense1 + Dense2 + Dense3
// Murilo's setup: W*.mem (hex bytes), b*_fixed_hex.mem (hex int32)
// ================================================================

`timescale 1ns/1ps

// ---------------------------
// Helpers (common functions)
// ---------------------------
function automatic logic signed [31:0] add_round_before_shift(
  input logic signed [31:0] v,
  input int unsigned shift,
  input bit use_round
);
  if (use_round && shift > 0)
    return v + (32'sd1 <<< (shift-1));
  else
    return v;
endfunction

function automatic logic signed [7:0] sat_s8(input logic signed [31:0] v);
  if      (v >  32'sd127)  return 8'sd127;
  else if (v < -32'sd128)  return -8'sd128;
  else                      return v[7:0];
endfunction

function automatic logic signed [15:0] sat_s16(input logic signed [31:0] v);
  if      (v >  32'sd32767)  return 16'sd32767;
  else if (v < -32'sd32768)  return -16'sd32768;
  else                       return v[15:0];
endfunction

// ================================================================
// Preprocess block: center and scale 8-bit unsigned to 8-bit signed
// y = clamp_s8( (x - ZERO_POINT) << SHIFT_UP )
// Handshake: simple valid/ready
// ================================================================
module pre_block_u8_to_s8 #(
  parameter int ZERO_POINT = 128,
  parameter int SHIFT_UP   = 1      // 0..3 typical
)(
  input  logic        clk_i,
  input  logic        rst_i,

  input  logic        valid_i,
  output logic        ready_o,
  input  logic [7:0]  x_u8_i,

  output logic        y_valid_o,
  input  logic        y_ready_i,
  output logic signed [7:0] x_s8_o
);
  assign ready_o = y_ready_i;

  function automatic logic signed [7:0] clamp_s8(input logic signed [15:0] v);
    if      (v >  16'sd127)   return 8'sd127;
    else if (v < -16'sd128)   return -8'sd128;
    else                      return v[7:0];
  endfunction

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      y_valid_o <= 1'b0;
      x_s8_o    <= '0;
    end else begin
      y_valid_o <= 1'b0;
      if (valid_i && ready_o) begin
        logic signed [15:0] tmp;
        tmp = $signed({1'b0, x_u8_i}) - $signed(ZERO_POINT);
        tmp = tmp <<< SHIFT_UP;
        x_s8_o    <= clamp_s8(tmp);
        y_valid_o <= 1'b1;
      end
    end
  end
endmodule

// ================================================================
// Dense generic (area-minimal): accumulates 1 MAC per cycle
// - Buffers full input vector internally (IN_DIM samples) before MAC
// - Weights: OUT_DIM x IN_DIM, signed int8
// - Bias:    OUT_DIM, signed int32
// - Accum:   int32; requantize by right-shift; clamp to OUT_BITS
// - Optional ReLU
// - Emits 1 neuron per cycle at the end of accumulation
// ================================================================
module dense_generic #(
  parameter int IN_DIM    = 181,
  parameter int OUT_DIM   = 64,
  parameter string W_MEM  = "W1.mem",
  parameter string B_MEM  = "b1_fixed_hex.mem",

  parameter int REQUANT_SHIFT = 7,
  parameter bit REQUANT_ROUND = 1'b1,
  parameter int OUT_BITS      = 8,   // 8 or 16
  parameter bit USE_RELU      = 1'b1
)(
  input  logic clk_i,
  input  logic rst_i,

  // Control for a new inference (must be pulsed when idle)
  input  logic start_i,
  output logic busy_o,
  output logic done_o,

  // Streaming input vector (collect IN_DIM samples)
  input  logic               in_valid_i,
  output logic               in_ready_o,
  input  logic signed  [7:0] in_data_i,   // signed 8-bit features

  // Output neurons (one per cycle after MAC loop)
  output logic               out_valid_o,
  output logic signed [15:0] out_data_o   // saturated to OUT_BITS
);
  // Memories
  logic signed [7:0]  W   [0:OUT_DIM*IN_DIM-1];
  logic signed [31:0] B   [0:OUT_DIM-1];

  initial begin
    $readmemh(W_MEM, W);
    $readmemh(B_MEM, B);
  end

  typedef enum logic [1:0] {S_IDLE, S_COLLECT, S_DOT, S_OUT} state_t;
  state_t state;

  logic [15:0] in_idx;
  logic [15:0] out_idx;
  logic signed [31:0] acc;

  // Input buffer
  logic signed [7:0] x_buf [0:IN_DIM-1];

  assign in_ready_o = (state == S_COLLECT);

  // Convert acc -> requantize -> saturate -> activation -> 16b
  function automatic logic signed [15:0] postproc(input logic signed [31:0] mac);
    logic signed [31:0] q;
    if (REQUANT_SHIFT > 0)
      q = add_round_before_shift(mac, REQUANT_SHIFT, REQUANT_ROUND) >>> REQUANT_SHIFT;
    else
      q = mac;
    logic signed [15:0] y_sat;
    if (OUT_BITS == 8)
      y_sat = {{8{sat_s8(q)[7]}}, sat_s8(q)}; // sign-extend to 16
    else
      y_sat = sat_s16(q);

    if (USE_RELU) begin
      if (y_sat < 0) return 16'sd0;
      else           return y_sat;
    end else begin
      return y_sat;
    end
  endfunction

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      state       <= S_IDLE;
      busy_o      <= 1'b0;
      done_o      <= 1'b0;
      out_valid_o <= 1'b0;
      in_idx      <= '0;
      out_idx     <= '0;
      acc         <= '0;
    end else begin
      done_o      <= 1'b0;
      out_valid_o <= 1'b0;

      unique case (state)
        S_IDLE: begin
          if (start_i) begin
            busy_o  <= 1'b1;
            in_idx  <= '0;
            state   <= S_COLLECT;
          end
        end

        // Collect IN_DIM samples into x_buf
        S_COLLECT: begin
          if (in_valid_i && in_ready_o) begin
            x_buf[in_idx] <= in_data_i;
            in_idx <= in_idx + 16'd1;
            if (in_idx == IN_DIM-1) begin
              out_idx <= '0;
              acc     <= B[0];
              in_idx  <= '0;
              state   <= S_DOT;
            end
          end
        end

        // Do one MAC per cycle for current out neuron
        S_DOT: begin
          acc    <= acc + x_buf[in_idx] * W[out_idx*IN_DIM + in_idx];
          in_idx <= in_idx + 16'd1;

          if (in_idx == IN_DIM-1) begin
            // Finish this neuron
            out_data_o  <= postproc(acc);
            out_valid_o <= 1'b1;

            // Next neuron
            in_idx  <= '0;
            out_idx <= out_idx + 16'd1;

            if (out_idx + 16'd1 == OUT_DIM) begin
              state <= S_OUT;
            end else begin
              acc   <= B[out_idx + 16'd1];
            end
          end
        end

        S_OUT: begin
          busy_o <= 1'b0;
          done_o <= 1'b1;
          state  <= S_IDLE;
        end
      endcase
    end
  end
endmodule

// ================================================================
// TOP: pre + dense1 + dense2 + dense3 (sequencial por camada)
// Interface de entrada: 181 bytes (0..255) via valid/ready após start_i.
// Saída: 1 valor final (16 bits com sinal), com out_valid_o pulso 1 ciclo.
// ================================================================
module mlp_3dense_top #(
  // Dimensões fixadas pelo seu NPZ
  parameter int IN_LEN   = 181,
  parameter int L1_OUT   = 64,
  parameter int L2_OUT   = 32,
  parameter int L3_OUT   = 1,

  // Arquivos de memória (ajuste se necessário)
  parameter string W1_MEM = "W1.mem",
  parameter string B1_MEM = "b1_fixed_hex.mem",
  parameter string W2_MEM = "W2.mem",
  parameter string B2_MEM = "b2_fixed_hex.mem",
  parameter string W3_MEM = "W3.mem",
  parameter string B3_MEM = "b3_fixed_hex.mem",

  // Pré-processamento
  parameter int PRE_ZERO_POINT = 128,
  parameter int PRE_SHIFT_UP   = 1,     // 0..3

  // Quantização/Requant por camada
  parameter int SHIFT1 = 7,  // densa1
  parameter int SHIFT2 = 7,  // densa2
  parameter int SHIFT3 = 7,  // densa3 (saída final)
  parameter bit ROUND1 = 1,
  parameter bit ROUND2 = 1,
  parameter bit ROUND3 = 1
)(
  input  logic        clk_i,
  input  logic        rst_i,

  // Controle
  input  logic        start_i,      // pulso para iniciar nova inferência
  output logic        busy_o,       // alto durante processamento
  output logic        done_o,       // pulso 1x ao término

  // Stream de entrada (181 bytes)
  input  logic        in_valid_i,
  output logic        in_ready_o,
  input  logic [7:0]  in_data_u8_i,

  // Resultado final
  output logic        out_valid_o,
  output logic signed [15:0] out_value_o
);

  // -------------------------
  // Pre-block (U8 -> S8)
  // -------------------------
  logic        pre_valid;
  logic        pre_ready;
  logic signed [7:0] pre_data_s8;

  pre_block_u8_to_s8 #(
    .ZERO_POINT (PRE_ZERO_POINT),
    .SHIFT_UP   (PRE_SHIFT_UP)
  ) u_pre (
    .clk_i     (clk_i),
    .rst_i     (rst_i),
    .valid_i   (in_valid_i),
    .ready_o   (in_ready_o),
    .x_u8_i    (in_data_u8_i),
    .y_valid_o (pre_valid),
    .y_ready_i (/* driven below */),
    .x_s8_o    (pre_data_s8)
  );

  // ---------------
  // Control splitter
  // ---------------
  // A pipeline é sequencial por camada: coletamos 181 amostras na Dense1,
  // depois Dense1 produz 64 saídas; estas são "coletadas" pela Dense2, etc.
  // Assim, o 'ready' do PRE aponta para Dense1.in_ready_o apenas enquanto
  // estamos na coleta da Dense1.
  typedef enum logic [2:0] {T_IDLE, T_COLLECT1, T_RUN1, T_COLLECT2, T_RUN2, T_COLLECT3, T_RUN3, T_DONE} tstate_t;
  tstate_t tstate;

  // Dense1 IO
  logic d1_busy, d1_done, d1_in_ready, d1_out_valid;
  logic signed [15:0] d1_out_data;

  // Dense2 IO
  logic d2_busy, d2_done, d2_in_ready, d2_out_valid;
  logic signed [15:0] d2_out_data;

  // Dense3 IO
  logic d3_busy, d3_done, d3_in_ready, d3_out_valid;
  logic signed [15:0] d3_out_data;

  // Fanout do start para cada densa apenas no momento certo
  logic d1_start, d2_start, d3_start;

  // REDIRECIONA ready do PRE para a Dense1 quando em coleta da D1
  assign u_pre.y_ready_i = (tstate == T_COLLECT1) ? d1_in_ready : 1'b0;

  // busy/done/out_valid (top-level)
  assign busy_o      = (tstate != T_IDLE) && (tstate != T_DONE);
  assign done_o      = (tstate == T_DONE);
  assign out_valid_o = (tstate == T_RUN3) && d3_out_valid;
  assign out_value_o = d3_out_data;

  // Top FSM
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      tstate   <= T_IDLE;
      d1_start <= 1'b0;
      d2_start <= 1'b0;
      d3_start <= 1'b0;
    end else begin
      d1_start <= 1'b0;
      d2_start <= 1'b0;
      d3_start <= 1'b0;

      unique case (tstate)
        T_IDLE: begin
          if (start_i) begin
            d1_start <= 1'b1;
            tstate   <= T_COLLECT1;
          end
        end

        T_COLLECT1: begin
          // Apenas encaminhamos pre_valid->Dense1.in_valid_i
          if (d1_done) begin
            // (não deve ocorrer aqui; d1_done vem após RUN1)
            tstate <= T_RUN1;
          end else if (/* transition to RUN1? */ 1'b0) begin
            tstate <= T_RUN1;
          end else begin
            // Continuamos coletando até Dense1 avançar internamente
            if (d1_busy && !d1_in_ready) begin
              // Dense1 passou para fase de MAC
              tstate <= T_RUN1;
            end
          end
        end

        T_RUN1: begin
          if (d1_done) begin
            d2_start <= 1'b1;
            tstate   <= T_COLLECT2;
          end
        end

        T_COLLECT2: begin
          // Dense2 espera 64 amostras vindas de Dense1 (uma por ciclo com out_valid)
          if (d2_busy && !d2_in_ready) begin
            tstate <= T_RUN2;
          end
        end

        T_RUN2: begin
          if (d2_done) begin
            d3_start <= 1'b1;
            tstate   <= T_COLLECT3;
          end
        end

        T_COLLECT3: begin
          if (d3_busy && !d3_in_ready) begin
            tstate <= T_RUN3;
          end
        end

        T_RUN3: begin
          if (d3_done) begin
            tstate <= T_DONE;
          end
        end

        T_DONE: begin
          // 1 ciclo em DONE para gerar done_o
          tstate <= T_IDLE;
        end
      endcase
    end
  end

  // -------------------------
  // Dense1: IN=181 -> OUT=64 (ReLU, out int8)
  // -------------------------
  dense_generic #(
    .IN_DIM        (IN_LEN),
    .OUT_DIM       (L1_OUT),
    .W_MEM         (W1_MEM),
    .B_MEM         (B1_MEM),
    .REQUANT_SHIFT (SHIFT1),
    .REQUANT_ROUND (ROUND1),
    .OUT_BITS      (8),
    .USE_RELU      (1)
  ) u_d1 (
    .clk_i       (clk_i),
    .rst_i       (rst_i),
    .start_i     (d1_start),
    .busy_o      (d1_busy),
    .done_o      (d1_done),
    // feed pre-block stream during T_COLLECT1
    .in_valid_i  ((tstate == T_COLLECT1) ? pre_valid : 1'b0),
    .in_ready_o  (d1_in_ready),
    .in_data_i   (pre_data_s8),
    .out_valid_o (d1_out_valid),
    .out_data_o  (d1_out_data)
  );

  // -------------------------
  // Dense2: IN=64 -> OUT=32 (ReLU, out int8)
  // Consome a saída da Dense1 durante a fase COLLECT2
  // -------------------------
  dense_generic #(
    .IN_DIM        (L1_OUT),
    .OUT_DIM       (L2_OUT),
    .W_MEM         (W2_MEM),
    .B_MEM         (B2_MEM),
    .REQUANT_SHIFT (SHIFT2),
    .REQUANT_ROUND (ROUND2),
    .OUT_BITS      (8),
    .USE_RELU      (1)
  ) u_d2 (
    .clk_i       (clk_i),
    .rst_i       (rst_i),
    .start_i     (d2_start),
    .busy_o      (d2_busy),
    .done_o      (d2_done),
    .in_valid_i  ((tstate == T_COLLECT2) ? d1_out_valid : 1'b0),
    .in_ready_o  (d2_in_ready),
    .in_data_i   (d1_out_data[7:0]),  // baixa 8 bits (signed) da saída da D1
    .out_valid_o (d2_out_valid),
    .out_data_o  (d2_out_data)
  );

  // -------------------------
  // Dense3: IN=32 -> OUT=1 (linear, out int16)
  // Consome a saída da Dense2 durante a fase COLLECT3
  // -------------------------
  dense_generic #(
    .IN_DIM        (L2_OUT),
    .OUT_DIM       (L3_OUT),
    .W_MEM         (W3_MEM),
    .B_MEM         (B3_MEM),
    .REQUANT_SHIFT (SHIFT3),
    .REQUANT_ROUND (ROUND3),
    .OUT_BITS      (16),
    .USE_RELU      (0)
  ) u_d3 (
    .clk_i       (clk_i),
    .rst_i       (rst_i),
    .start_i     (d3_start),
    .busy_o      (d3_busy),
    .done_o      (d3_done),
    .in_valid_i  ((tstate == T_COLLECT3) ? d2_out_valid : 1'b0),
    .in_ready_o  (d3_in_ready),
    .in_data_i   (d2_out_data[7:0]),  // baixa 8 bits (signed) da saída da D2
    .out_valid_o (d3_out_valid),
    .out_data_o  (d3_out_data)
  );

endmodule
