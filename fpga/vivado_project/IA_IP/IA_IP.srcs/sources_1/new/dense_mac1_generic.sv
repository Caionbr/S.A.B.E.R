`timescale 1ns/1ps
`default_nettype none

module dense_mac1_generic #(
  parameter int IN_DIM    = 181,
  parameter int OUT_DIM   = 64,
  parameter string W_MEM  = "W1.mem",
  parameter string B_MEM  = "b1_fixed_hex.mem",
  parameter int REQUANT_SHIFT = 7,
  parameter logic REQUANT_ROUND = 1'b1,
  parameter int OUT_BITS      = 8,   // 8 ou 16
  parameter logic USE_RELU    = 1'b1
)(
  input  logic clk_i,
  input  logic rst_i,

  // controle
  input  logic start_i,
  output logic busy_o,
  output logic done_o,

  // stream de entrada: IN_DIM amostras s8 em [7:0] (two's comp)
  input  logic       in_valid_i,
  output logic       in_ready_o,
  input  logic [7:0] in_data_s8_i,

  // stream de saída: OUT_DIM neurônios (cada 1 ciclo) - 16 bits (sign-extended)
  output logic       out_valid_o,
  output logic [15:0] out_data_s16_o
);
  // --- ROMs ---
  logic [7:0]  W [0:OUT_DIM*IN_DIM-1];   // s8 armazenado como byte
  logic [31:0] B [0:OUT_DIM-1];          // s32 two's complement

  initial begin
    $readmemh(W_MEM, W);
    $readmemh(B_MEM, B);
  end

  // --- FSM ---
  typedef enum logic [1:0] {S_IDLE, S_COLLECT, S_DOT, S_OUT} state_t;
  state_t state;

  logic [15:0] in_idx;
  logic [15:0] out_idx;
  logic signed [31:0] acc;          // acumulador s32

  // buffer de entrada
  logic [7:0] x_buf [0:IN_DIM-1];

  assign in_ready_o = (state == S_COLLECT);

  // helpers
  function automatic [31:0] add_round(input signed [31:0] v);
    if (REQUANT_ROUND && (REQUANT_SHIFT > 0))
      add_round = v + (32'sd1 <<< (REQUANT_SHIFT-1));
    else
      add_round = v;
  endfunction

  function automatic [7:0] sat_s8(input signed [31:0] v);
    if (v >  32'sd127)     sat_s8 = 8'h7F;
    else if (v < -32'sd128) sat_s8 = 8'h80;
    else                    sat_s8 = v[7:0];
  endfunction

  function automatic [15:0] sat_s16(input signed [31:0] v);
    if (v >  32'sd32767)      sat_s16 = 16'h7FFF;
    else if (v < -32'sd32768) sat_s16 = 16'h8000;
    else                      sat_s16 = v[15:0];
  endfunction

  function automatic [15:0] postproc(input signed [31:0] mac);
    // DECLs no topo
    logic signed [31:0] q_s32;
    logic signed [15:0] y_sat_s16;
    logic signed [7:0]  y8_s8;
    logic [15:0]        ret;

    if (REQUANT_SHIFT > 0)
      q_s32 = $signed(add_round(mac)) >>> REQUANT_SHIFT;
    else
      q_s32 = mac;

    if (OUT_BITS == 8) begin
      y8_s8      = $signed(sat_s8(q_s32));
      y_sat_s16  = {{8{y8_s8[7]}}, y8_s8};
    end else begin
      y_sat_s16  = $signed(sat_s16(q_s32));
    end

    if (USE_RELU && (y_sat_s16 < 0))
      ret = 16'd0;
    else
      ret = y_sat_s16;

    return ret;
  endfunction

  // produto combinacional do ciclo
  logic signed [7:0]  xs8_c;
  logic signed [7:0]  ws8_c;
  logic signed [31:0] mac_sum;   // acc + xs8*ws8 deste ciclo

  always_comb begin
    xs8_c   = $signed(x_buf[in_idx]);
    ws8_c   = $signed(W[out_idx*IN_DIM + in_idx]);
    mac_sum = $signed(acc) + (xs8_c * ws8_c);
  end

  // Sequencial
  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      state         <= S_IDLE;
      busy_o        <= 1'b0;
      done_o        <= 1'b0;
      out_valid_o   <= 1'b0;
      in_idx        <= '0;
      out_idx       <= '0;
      acc           <= '0;
      out_data_s16_o<= 16'd0;
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

        // coleta IN_DIM amostras
        S_COLLECT: begin
          if (in_valid_i && in_ready_o) begin
            x_buf[in_idx] <= in_data_s8_i;
            in_idx <= in_idx + 16'd1;
            if (in_idx == IN_DIM-1) begin
              out_idx <= '0;
              acc     <= $signed(B[0]);
              in_idx  <= '0;
              state   <= S_DOT;
            end
          end
        end

        // faz 1 MAC por ciclo; usa mac_sum (acc + produto atual)
        S_DOT: begin
          if (in_idx == IN_DIM-1) begin
            // última MAC do neurônio: usar mac_sum para gerar saída
            out_data_s16_o <= postproc(mac_sum);
            out_valid_o    <= 1'b1;

            in_idx <= '0;
            if (out_idx + 16'd1 == OUT_DIM) begin
              // fim de todos neurônios
              state  <= S_OUT;
            end else begin
              // próximo neurônio: zera acumulador para bias do próximo
              out_idx <= out_idx + 16'd1;
              acc     <= $signed(B[out_idx + 16'd1]);
            end
          end else begin
            // meio do dot: acumula e segue
            acc    <= mac_sum;
            in_idx <= in_idx + 16'd1;
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

`default_nettype wire
