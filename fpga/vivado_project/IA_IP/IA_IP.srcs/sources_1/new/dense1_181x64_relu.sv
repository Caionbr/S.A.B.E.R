// ============================================================
// dense1_181x64_relu.sv  - Camada 1 MLP (181 -> 64) + ReLU
//   - Entrada : 181 valores Q2.14 (flatten em 16b signed)
//   - Pesos   : W1.mem (int8)  [64*181]  ordem: n0[0..180], n1[0..180], ...
//   - Bias    : b1.mem (int32) [64]
//   - Saída   : 64 valores Q2.14 (16b signed), ReLU + saturação
// Precisão interna:
//   - prod   = int8 * Q2.14           -> 32b
//   - soma   = ∑prod + (bias<<14)     -> 48b
//   - dequant: (48b * W1_DEQ_Q14)>>14 -> 32b (com headroom), depois sat16
// Latência: 1 ciclo (reg de entrada + computa e registra a saída)
// ============================================================

`ifndef DENSE1_181x64_RELU_SV
`define DENSE1_181x64_RELU_SV

module dense1_181x64_relu #(
  parameter int N_IN  = 181,
  parameter int N_OUT = 64,

  // ganho de dequantização do tensor W1 em Q2.14 (ajuste se houver saturação)
  parameter int unsigned W1_DEQ_Q14 = 16'd194
)(
  input  logic                       clock_i,
  input  logic                       reset_i,

  input  logic                       data_valid_i,
  input  logic [N_IN*16-1:0]         data_i,      // Q2.14 (flatten)

  output logic                       out_valid_o,
  output logic [N_OUT*16-1:0]        y_o          // Q2.14 (flatten)
);

  // ---------------- ROMs ----------------
  (* rom_style="block" *) logic signed [7:0]   W1 [0:N_OUT*N_IN-1];
  (* rom_style="block" *) logic signed [31:0]  B1 [0:N_OUT-1];

  initial begin
    $readmemh("W1.mem", W1);
    $readmemh("b1.mem", B1);
  end

  // ------------- unpack da entrada -------------
  logic signed [15:0] x_q14 [0:N_IN-1];
  always_comb begin
    for (int i = 0; i < N_IN; i++) begin
      x_q14[i] = data_i[i*16 +: 16];
    end
  end

  // ------------- estágio 0: registra entrada + valid -------------
  logic                       s0_valid;
  logic signed [15:0] x_q14_r [0:N_IN-1];

  always_ff @(posedge clock_i or posedge reset_i) begin
    if (reset_i) begin
      s0_valid <= 1'b0;
      for (int i = 0; i < N_IN; i++) x_q14_r[i] <= '0;
    end else begin
      s0_valid <= data_valid_i;
      if (data_valid_i) begin
        for (int i = 0; i < N_IN; i++) x_q14_r[i] <= x_q14[i];
      end
    end
  end

  // ------------- MAC por neurônio (48b de acumulação) -------------
  logic signed [47:0] acc_wide [0:N_OUT-1];

  genvar o;
  generate
    for (o = 0; o < N_OUT; o++) begin : GEN_MAC
      always_comb begin : MAC_O
        automatic logic signed [31:0] b_q14 = B1[o] <<< 14;     // alinha bias p/ Q2.14
        automatic logic signed [47:0] s     = {{16{b_q14[31]}}, b_q14}; // 32->48 com sign-extend
        for (int i = 0; i < N_IN; i++) begin
          automatic int idx = o*N_IN + i;
          automatic logic signed [31:0] prod = $signed(W1[idx]) * $signed(x_q14_r[i]); // int8 * q2.14 -> 32b
          s += {{16{prod[31]}}, prod};  // 32->48 com sign-extend e soma
        end
        acc_wide[o] = s;
      end
    end
  endgenerate

  // ------------- função de saturação p/ 16b (Q2.14) -------------
  function automatic logic signed [15:0] sat16_q214(input logic signed [31:0] v);
    if (v > 32'sh0000_7FFF)       return 16'sh7FFF;
    else if (v < 32'shFFFF_8000)  return 16'sh8000;
    else                          return v[15:0];
  endfunction

  // ------------- estágio 1: dequant + ReLU + sat -------------
  logic signed [15:0] y_arr [0:N_OUT-1];

  always_ff @(posedge clock_i or posedge reset_i) begin
    if (reset_i) begin
      out_valid_o <= 1'b0;
      for (int j = 0; j < N_OUT; j++) y_arr[j] <= '0;
    end else begin
      out_valid_o <= s0_valid;

      if (s0_valid) begin
        for (int j = 0; j < N_OUT; j++) begin : POST_O
          // dequant: (acc_wide * W1_DEQ_Q14) >>> 14  -> mantém Q2.14
          automatic logic signed [63:0] mul = $signed(acc_wide[j]) * $signed(W1_DEQ_Q14);
          automatic logic signed [63:0] shr = mul >>> 14;
          automatic logic signed [31:0] q14 = shr[31:0];

          // ReLU
          if (q14[31]) q14 = 32'sd0;

          // saturação para Q2.14 em 16b
          y_arr[j] <= sat16_q214(q14);
        end
      end
    end
  end

  // ------------- pack da saída -------------
  always_comb begin
    for (int j = 0; j < N_OUT; j++) begin
      y_o[j*16 +: 16] = y_arr[j];
    end
  end

endmodule

`endif
