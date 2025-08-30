// ============================================================
// mlp_top_stdzdense1.sv
// Topo: STDZ (Q2.14) -> DENSE1 (181->64, ReLU, Q2.14)
// ============================================================
module mlp_top_stdzdense1 #(
  parameter int N_IN   = 181,
  parameter int N_OUT1 = 64
)(
  input  logic                   clock_i,
  input  logic                   reset_i,

  input  logic                   data_valid_i,            // 1 ciclo por frame de 181 amostras
  input  logic [N_IN-1:0][7:0]   data_i,                  // vetor 181×8b

  output logic                   dense_valid_o,           // válido da saída do DENSE1
  output logic [N_OUT1*16-1:0]   dense_y_o                // 64×Q2.14 flatten
);

  // ---------- STDZ ----------
  logic                          stdz_valid_s;
  logic signed [N_IN-1:0][15:0]  stdz_q14_s;

  stdz_181 #(.N(N_IN)) u_stdz (
    .clock_i      (clock_i),
    .reset_i      (reset_i),
    .data_valid_i (data_valid_i),
    .data_i       (data_i),
    .data_valid_o (stdz_valid_s),
    .data_o       (stdz_q14_s)
  );

  // ---------- pack STDZ -> flatten 16*N ----------
  logic [N_IN*16-1:0] stdz_flatten_s;
  always_comb begin
    for (int i = 0; i < N_IN; i++) begin
      stdz_flatten_s[i*16 +: 16] = stdz_q14_s[i];
    end
  end

  // ---------- DENSE1 ----------
  dense1_181x64_relu #(
    .N_IN(N_IN),
    .N_OUT(N_OUT1),
    .W1_DEQ_Q14(16'd194) // de scales.json
  ) u_dense1 (
    .clock_i      (clock_i),
    .reset_i      (reset_i),
    .data_valid_i (stdz_valid_s),
    .data_i       (stdz_flatten_s),
    .out_valid_o  (dense_valid_o),
    .y_o          (dense_y_o)
  );

endmodule
