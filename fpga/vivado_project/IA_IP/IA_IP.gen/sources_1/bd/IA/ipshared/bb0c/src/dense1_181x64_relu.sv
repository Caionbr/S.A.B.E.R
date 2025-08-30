// ============================================================
// dense1_181x64_relu.sv  -  1ª camada da MLP (181 -> 64) + ReLU
//
// Entradas:
//   - clock_i, reset_i
//   - data_valid_i: 1 ciclo para amostrar a entrada
//   - data_i  : 181 amostras Q2.14, empacotadas em [N_IN*16-1:0]
//
// Pesos (ROMs):
//   - W1.mem : INT8  (two's complement)  [64*181 entradas], flatten por neurônio
//              ordem: w[0][0..180], w[1][0..180], ..., w[63][0..180]
//   - b1.mem : INT32 (two's complement)  [64 entradas]
//
// Dequant:
//   - usamos fator em Q2.14: W1_DEQ_Q14 = round(W1_deq * 2^14)
//     (com W1_deq = 0.01186086144 -> 0.01186086144 * 16384 ≈ 194)
//
// Saída:
//   - y_o: 64 valores Q2.14 (flatten) com ReLU e saturação
//   - out_valid_o = data_valid_i atrasado 1 ciclo
//
// Latência: 1 ciclo (amostra -> processa -> entrega)
// ============================================================

module dense1_181x64_relu #(
  parameter int N_IN  = 181,
  parameter int N_OUT = 64,

  // Dequantização do W1 em Q2.14 (default = 194, vindo do scales.json)
  parameter int unsigned W1_DEQ_Q14 = 16'd194
)(
  input  logic                       clock_i,
  input  logic                       reset_i,

  input  logic                       data_valid_i,
  input  logic [N_IN*16-1:0]         data_i,      // Q2.14 (flatten)

  output logic                       out_valid_o,
  output logic [N_OUT*16-1:0]        y_o          // Q2.14 (flatten)
);

  // ------------------- ROMs de pesos e bias -------------------
  (* rom_style = "block" *) logic signed [7:0]   W1  [0:N_OUT*N_IN-1];
  (* rom_style = "block" *) logic signed [31:0]  B1  [0:N_OUT-1];

  initial begin
    $readmemh("W1.mem", W1);
    $readmemh("b1.mem", B1);
  end

  // ------------------ despack da entrada (Q2.14) --------------
  logic signed [15:0] x_q14   [0:N_IN-1];
  always_comb begin
    for (int i = 0; i < N_IN; i++) begin
      x_q14[i] = data_i[i*16 +: 16];
    end
  end

  // --------- estágio 0: registrador de entrada + valid --------
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

  // ----------------- MAC por neurônio (com bias) --------------
  // acumula em 48 bits: sum( INT8 * Q2.14 ) + (bias << 14)
  logic signed [47:0] acc_wide [0:N_OUT-1];

  genvar o;
  generate
    for (o = 0; o < N_OUT; o++) begin : GEN_MAC
      always_comb begin
        // alinha o bias (INT32) para Q2.14 e estende para 48b
        logic signed [31:0] b_q14 = B1[o] <<< 14;
        logic signed [47:0] s     = {{16{b_q14[31]}}, b_q14};

        // soma w_i8 * x_q14_r[i]
        for (int i = 0; i < N_IN; i++) begin
          int idx = o*N_IN + i; // índice flatten
          logic signed [31:0] prod = $signed(W1[idx]) * $signed(x_q14_r[i]);
          s += {{16{prod[31]}}, prod}; // sign-extend 32->48 e soma
        end
        acc_wide[o] = s;
      end
    end
  endgenerate

  // ------------- estágio 1: dequant, ReLU e saturação ----------
  function automatic logic signed [15:0] sat16(input logic signed [31:0] v);
    if (v > 32'sh00007FFF)       return 16'sh7FFF;
    else if (v < 32'shFFFF8000)  return 16'sh8000;
    else                         return v[15:0];
  endfunction

  logic signed [15:0] y_q14_arr [0:N_OUT-1];

  always_ff @(posedge clock_i or posedge reset_i) begin
    if (reset_i) begin
      out_valid_o <= 1'b0;
      for (int j = 0; j < N_OUT; j++) y_q14_arr[j] <= '0;
    end else begin
      out_valid_o <= s0_valid; // latência de 1 ciclo

      if (s0_valid) begin
        for (int j = 0; j < N_OUT; j++) begin
          // DEQUANT CORRETO:
          // y = (acc_wide * W1_DEQ_Q14) >>> 14   (shift em 64b, depois corta)
          logic signed [63:0] mul = $signed(acc_wide[j]) * $signed(W1_DEQ_Q14);
          logic signed [63:0] shr = mul >>> 14;            // shift aritmético
          logic signed [31:0] q14 = shr[31:0];             // agora pega os 32b baixos

          // ReLU
          if (q14[31]) q14 = 32'sd0;

          // Saturação para 16 bits (Q2.14)
          y_q14_arr[j] <= sat16(q14);
        end
      end
    end
  end

  // ------------------- pack da saída flatten -------------------
  always_comb begin
    for (int j = 0; j < N_OUT; j++) begin
      y_o[j*16 +: 16] = y_q14_arr[j];
    end
  end

endmodule
