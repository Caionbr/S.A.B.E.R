// ============================================================
// stdz_181.sv  -  Padronização (z-score) em Q2.14
//  - Lê A[i] e B[i] em Q2.14 de ROMs (.mem)
//  - Entrada: 181 amostras uint8 (0..255)
//  - Saída:   181 amostras Q2.14 (16b signed)
//  - Latência: 1 ciclo (amostra -> calcula -> registra)
//  - Intermediários: 32b para evitar saturação interna
// ============================================================
`timescale 1ns/1ps
`default_nettype none

module stdz_181 #(
  parameter int N = 181
)(
  input  logic                      clock_i,
  input  logic                      reset_i,

  input  logic                      data_valid_i,                 // pulso 1 ciclo
  input  logic        [N-1:0][7:0]  data_i,                       // uint8

  output logic                      data_valid_o,                 // 1 qdo data_o novo
  output logic signed [N-1:0][15:0] data_o                        // Q2.14
);

  // ---------------- ROMs (Q2.14, 16b signed) ----------------
  // y[i] = A[i]*x[i] + B[i], tudo em Q2.14
  (* rom_style = "block" *) logic signed [15:0] A [0:N-1];
  (* rom_style = "block" *) logic signed [15:0] B [0:N-1];
  initial begin
    $readmemh("ai_q14.mem", A);
    $readmemh("bi_q14.mem", B);
  end

  // ------------- saturação 32b -> 16b (Q2.14) ---------------
  function automatic logic signed [15:0] sat16_q214(input logic signed [31:0] v);
    if (v > 32'sh0000_7FFF)       return 16'sh7FFF;
    else if (v < 32'shFFFF_8000)  return 16'sh8000;
    else                          return v[15:0];
  endfunction

  // ======= Estágio 0: amostrar a entrada =======
  logic        [N-1:0][7:0] x_samp;   // amostra da entrada (uint8)
  logic                     s0_valid; // pulso alinhado à amostra

  always_ff @(posedge clock_i or posedge reset_i) begin
    if (reset_i) begin
      x_samp   <= '0;
      s0_valid <= 1'b0;
    end else begin
      s0_valid <= data_valid_i;
      if (data_valid_i) x_samp <= data_i; // captura o vetor todo em 1 ciclo
    end
  end

  // ======= Caminho combinacional (A*x + B) em 32b =======
  // A: Q2.14 (16b signed), x: 8b unsigned (0..255)
  // Produto: (16b * 9b) -> usamos 32b para folga total.
  logic signed [31:0] acc_q14 [0:N-1];

  genvar g;
  generate
    for (g = 0; g < N; g++) begin : GEN_STDZ
      always_comb begin : COMB_ELEM
        // promove x para signed antes do * (mantendo valor positivo)
        logic signed [8:0]  x9  = {1'b0, x_samp[g]};   // 0..255
        logic signed [31:0] a32 = $signed(A[g]);       // 16b -> 32b
        logic signed [31:0] b32 = $signed(B[g]);       // 16b -> 32b

        // A_q14 * x  (já fica em Q2.14, sem shift)
        logic signed [31:0] prod = a32 * x9;           // 32b

        // soma com B_q14 (também Q2.14)
        acc_q14[g] = prod + b32;                       // 32b, Q2.14
      end
    end
  endgenerate

  // ======= Estágio 1: registra saída quando válido =======
  always_ff @(posedge clock_i or posedge reset_i) begin
    if (reset_i) begin
      data_valid_o <= 1'b0;
      data_o       <= '0;
    end else begin
      data_valid_o <= s0_valid;               // 1 ciclo após captura
      if (s0_valid) begin
        for (int i = 0; i < N; i++) begin
          data_o[i] <= sat16_q214(acc_q14[i]);  // clamp p/ Q2.14 (16b)
        end
      end
      // quando s0_valid=0, mantém o último valor (hold)
    end
  end

endmodule

`default_nettype wire
