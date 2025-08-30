// ============================================================
// stdz_181.sv  -  Padronização (z-score) em Q2.14
// Saída só atualiza quando out_valid=1 (alinhada ao dado).
// ============================================================
module stdz_181 #(
  parameter int N = 181
)(
  input  logic                      clock_i,
  input  logic                      reset_i,

  input  logic                      data_valid_i,                 // pulso de 1 ciclo
  input  logic        [N-1:0][7:0]  data_i,                    // 181 amostras (0..255)

  output logic                      data_valid_o,                // 1 quando z_out novo
  output logic signed [N-1:0][15:0] data_o                   // Q2.14
);

  // ---------------- ROMs (Q2.14) ----------------
  (* rom_style = "block" *) logic signed [15:0] A [0:N-1];
  (* rom_style = "block" *) logic signed [15:0] B [0:N-1];
  initial begin
    $readmemh("ai_q14.mem", A);
    $readmemh("bi_q14.mem", B);
  end

  // ------------- função saturação ---------------
  function automatic logic signed [15:0] sat16_q214(input logic signed [25:0] v);
    if (v > 26'sh07FFF)       return 16'sh7FFF;
    else if (v < -26'sh08000) return 16'sh8000;
    else                      return v[15:0];
  endfunction

  // ======= Estágio 0: amostrar a entrada =======
  // Isso evita a "primeira mudança" antes do valid.
  logic        [N-1:0][7:0] x_samp;     // amostra de x_in
  logic                     s0_valid;   // pulso alinhado à amostra

  always_ff @(posedge clock_i or posedge reset_i) begin
    if (reset_i) begin
      x_samp   <= '0;
      s0_valid <= 1'b0;
    end else begin
      s0_valid <= data_valid_i;
      if (data_valid_i) begin
        x_samp <= data_i;     // captura todo o vetor num ciclo
      end
    end
  end

  // ======= Caminho combinacional (A*x + B) sobre x_samp =======
  logic signed [23:0] prod [0:N-1];
  logic signed [25:0] acc  [0:N-1];

  genvar g;
  generate
    for (g = 0; g < N; g++) begin : GEN_STDZ
      always_comb begin
        // A (Q2.14) * x_samp (0..255) -> Q2.14 (24b)
        prod[g] = $signed(A[g]) * $signed({1'b0, x_samp[g]});
        // + B (Q2.14), com extensão de sinal compatível
        acc[g]  = $signed({{2{prod[g][23]}}, prod[g]})
                + $signed({{10{B[g][15]}},    B[g]});
      end
    end
  endgenerate

  // ======= Estágio 1: registra saída apenas quando válido =======
  always_ff @(posedge clock_i or posedge reset_i) begin
    if (reset_i) begin
      data_valid_o <= 1'b0;
      data_o     <= '0;
    end else begin
      data_valid_o <= s0_valid;          // 1 ciclo após a captura
      if (s0_valid) begin
        for (int i = 0; i < N; i++) begin
          data_o[i] <= sat16_q214(acc[i]);
        end
      end
      // quando s0_valid=0, z_out mantém o valor anterior (não muda)
    end
  end

endmodule
