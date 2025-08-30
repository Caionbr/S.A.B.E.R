// ============================================================
// dense2_64x32_relu.sv  -  2ª camada (64 -> 32) + ReLU em Q2.14
//
// Entradas:
//   - data_i : 64 valores Q2.14 (flatten em [N_IN*16-1:0])
//   - data_valid_i = 1 por 1 ciclo para amostrar
//
// ROMs:
//   - W2.mem : INT8  [N_OUT*N_IN]  (ordem: neurônio-major)
//              w[0][0..63], w[1][0..63], ..., w[31][0..63]
//   - b2.mem : INT32 [N_OUT]
//   * Estes vêm do export do treino (quantização INT8/INT32).
//
// Dequant:
//   - y_q14 = ((acc_wide * W2_DEQ_Q14) >>> 14), depois ReLU e saturação 16b
//   - W2_DEQ_Q14 = round(W2_deq * 2^14). Padrão abaixo (239) pode ser
//     alterado se você quiser ajustar ganho.
//
// Latência: 1 ciclo (registrador de entrada)
// Saída: y_o: 32 valores Q2.14 (flatten)
//
// ============================================================
module dense2_64x32_relu #(
  parameter int N_IN  = 64,
  parameter int N_OUT = 32,

  // Ajuste conforme seu scales.json (W2_deq). Padrão ≈ 239.
  parameter int unsigned W2_DEQ_Q14 = 16'd239
)(
  input  logic                     clock_i,
  input  logic                     reset_i,

  input  logic                     data_valid_i,
  input  logic [N_IN*16-1:0]       data_i,     // Q2.14 flatten

  output logic                     out_valid_o,
  output logic [N_OUT*16-1:0]      y_o         // Q2.14 flatten
);

  // ---------------- ROMs ----------------
  (* rom_style="block" *) logic signed [7:0]   W2 [0:N_OUT*N_IN-1];
  (* rom_style="block" *) logic signed [31:0]  B2 [0:N_OUT-1];

  initial begin
    $readmemh("W2.mem", W2);
    $readmemh("b2.mem", B2);
  end

  // -------- unpack da entrada --------
  logic signed [15:0] x_q14 [0:N_IN-1];
  always_comb begin
    for (int i = 0; i < N_IN; i++) begin
      x_q14[i] = data_i[i*16 +: 16];
    end
  end

  // -------- registrador de entrada --------
  logic                     s0_valid;
  logic signed [15:0]       x_q14_r [0:N_IN-1];

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

  // -------- MAC por neurônio (bias alinhado a Q2.14) --------
  // acc_wide = sum(INT8 * Q2.14) + (bias << 14), guardado em 48 bits
  logic signed [47:0] acc_wide [0:N_OUT-1];

  genvar o;
  generate
    for (o = 0; o < N_OUT; o++) begin : GEN_MAC
      always_comb begin
        // bias INT32 -> Q2.14 (shift <<14) e estende p/ 48b
        logic signed [31:0] b_q14 = B2[o] <<< 14;
        logic signed [47:0] s     = {{16{b_q14[31]}}, b_q14};

        // soma w_i8 * x_q14_r[i]
        for (int i = 0; i < N_IN; i++) begin
          int idx = o*N_IN + i; // índice flatten (neurônio-major)
          logic signed [31:0] prod = $signed(W2[idx]) * $signed(x_q14_r[i]); // 8b*16b -> 24..32b
          s += {{16{prod[31]}}, prod}; // 32->48 com sinal
        end

        acc_wide[o] = s;
      end
    end
  endgenerate

  // -------- saturação 32->16 (Q2.14) --------
  function automatic logic signed [15:0] sat16(input logic signed [31:0] v);
    if (v > 32'sh0000_7FFF)       return 16'sh7FFF;
    else if (v < 32'shFFFF_8000)  return 16'sh8000;
    else                          return v[15:0];
  endfunction

  // -------- dequant + ReLU + pack --------
  logic signed [15:0] y_arr [0:N_OUT-1];

  always_ff @(posedge clock_i or posedge reset_i) begin
    if (reset_i) begin
      out_valid_o <= 1'b0;
      for (int j = 0; j < N_OUT; j++) y_arr[j] <= '0;
    end else begin
      out_valid_o <= s0_valid;  // 1 ciclo de latência

      if (s0_valid) begin
        for (int j = 0; j < N_OUT; j++) begin
          // q14 = (acc_wide * W2_DEQ_Q14) >>> 14
          logic signed [63:0] mul = $signed(acc_wide[j]) * $signed(W2_DEQ_Q14);
          logic signed [63:0] shr = mul >>> 14;
          logic signed [31:0] q14 = shr[31:0];

          // ReLU
          if (q14[31]) q14 = 32'sd0;

          // saturação p/ 16b e registra
          y_arr[j] <= sat16(q14);
        end
      end
    end
  end

  always_comb begin
    for (int j = 0; j < N_OUT; j++) begin
      y_o[j*16 +: 16] = y_arr[j];
    end
  end

endmodule
