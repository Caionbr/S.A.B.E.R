`timescale 1ns/1ps

module mlp_top #(
  parameter int N_IN = 181   // nº de amostras do frame
)(
  input  logic                 clock_i,
  input  logic                 reset_i,
  input  logic                 data_valid_i,
  input  logic [N_IN-1:0][7:0] data_i,      // 181 bytes (0..255)

  output logic                 out_valid_o,
  output logic [15:0]          y_o          // saída final Q1.15 (sigmoid)
);

  // ---------------- Pré (z-score Q2.14) ----------------
  logic                        stdz_valid;
  logic signed [N_IN-1:0][15:0] stdz_o;     // Q2.14 por amostra

  stdz_181 #(
    .N(N_IN)
    // se o teu stdz tem PRE_SHIFT, deixa default (2) ou ajuste aqui:
    // .PRE_SHIFT(2)
  ) u_stdz (
    .clock_i      (clock_i),
    .reset_i      (reset_i),
    .data_valid_i (data_valid_i),
    .data_i       (data_i),
    .data_valid_o (stdz_valid),
    .data_o       (stdz_o)
  );

  // --------- Flatten Q2.14 (181 x 16) -> vetor 16*181 ----------
  logic [N_IN*16-1:0] stdz_flat;
  always_comb begin
    for (int i = 0; i < N_IN; i++) begin
      stdz_flat[i*16 +: 16] = stdz_o[i];
    end
  end

  // ---------------- Dense1: 181 -> 64 (ReLU, Q2.14) -------------
  logic                    d1_valid;
  logic [64*16-1:0]        d1_o;            // 64 saídas Q2.14

  dense1_181x64_relu #(
    .N_IN (N_IN),
    .N_OUT(64)
    // usa os defaults internos de dequant (W1_DEQ_Q14),
    // ou sobreescreva aqui se quiser:
    // .W1_DEQ_Q14(16'dXXX)
  ) u_d1 (
    .clock_i      (clock_i),
    .reset_i      (reset_i),
    .data_valid_i (stdz_valid),
    .data_i       (stdz_flat),
    .out_valid_o  (d1_valid),
    .y_o          (d1_o)
  );

  // ---------------- Dense2: 64 -> 32 (ReLU, Q2.14) --------------
  logic                    d2_valid;
  logic [32*16-1:0]        d2_o;            // 32 saídas Q2.14

  dense2_64x32_relu u_d2 (
    .clock_i      (clock_i),
    .reset_i      (reset_i),
    .data_valid_i (d1_valid),
    .data_i       (d1_o),
    .out_valid_o  (d2_valid),
    .y_o          (d2_o)
  );

  // ---------------- Dense3: 32 -> 1 + Sigmoid (Q1.15) -----------
  dense3_32x1_sigmoid u_d3 (
    .clock_i      (clock_i),
    .reset_i      (reset_i),
    .data_valid_i (d2_valid),
    .data_i       (d2_o),
    .out_valid_o  (out_valid_o),
    .y_o          (y_o)
  );

endmodule
