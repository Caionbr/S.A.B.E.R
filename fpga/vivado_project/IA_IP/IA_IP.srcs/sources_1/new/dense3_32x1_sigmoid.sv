// ============================================================
// dense3_32x1_sigmoid.sv  (corrigido p/ LUT 2048 em [-8,+8])
//  - Entrada : 32 x Q2.14 (flatten)
//  - W3: INT8, B3: INT32, dequant W3_DEQ_Q14 (Q2.14)
//  - Saída  : Q1.15 (0..1)
// ============================================================
module dense3_32x1_sigmoid #(
  parameter int N_IN = 32,
  // dequant em Q2.14: W3_DEQ_Q14 = round(W3_deq * 2^14)
  parameter int unsigned W3_DEQ_Q14 = 16'd137
)(
  input  logic                   clock_i,
  input  logic                   reset_i,
  input  logic                   data_valid_i,
  input  logic [N_IN*16-1:0]     data_i,    // Q2.14 flatten

  output logic                   out_valid_o,
  output logic [15:0]            y_o        // Q1.15 (sigmoid output)
);

  // -------- ROMs de pesos --------
  (* rom_style="block" *) logic signed [7:0]   W3 [0:N_IN-1];
  (* rom_style="block" *) logic signed [31:0]  B3 [0:0];

  initial begin
    $readmemh("W3.mem", W3);
    $readmemh("b3.mem", B3);
  end

  // -------- Unpack entrada Q2.14 --------
  logic signed [15:0] x_q14 [0:N_IN-1];
  always_comb for (int i=0;i<N_IN;i++) x_q14[i] = data_i[i*16 +: 16];

  // -------- S0: registra entrada/valid --------
  logic s0_valid;
  logic signed [15:0] x_q14_r [0:N_IN-1];
  always_ff @(posedge clock_i or posedge reset_i) begin
    if (reset_i) begin
      s0_valid <= 1'b0;
      for (int i=0;i<N_IN;i++) x_q14_r[i] <= '0;
    end else begin
      s0_valid <= data_valid_i;
      if (data_valid_i) for (int i=0;i<N_IN;i++) x_q14_r[i] <= x_q14[i];
    end
  end

  // -------- MAC + bias alinhado a Q2.14 --------
  logic signed [47:0] acc_wide;
  always_comb begin
    logic signed [31:0] b_q14 = B3[0] <<< 14;
    logic signed [47:0] s = {{16{b_q14[31]}}, b_q14};
    for (int i=0;i<N_IN;i++) begin
      logic signed [31:0] prod = $signed(W3[i]) * $signed(x_q14_r[i]); // 8b * Q2.14 -> 32b
      s += {{16{prod[31]}}, prod};                                     // 32->48 sign-extend
    end
    acc_wide = s;
  end

  // -------- Dequant -> volta para Q2.14 --------
  logic signed [31:0] acc_q14;
  always_comb begin
    logic signed [63:0] mul = $signed(acc_wide) * $signed(W3_DEQ_Q14);
    logic signed [63:0] shr = mul >>> 14;
    acc_q14 = shr[31:0];
  end

  // -------- Sigmoid LUT (2048 pontos em [-8,+8], Q1.15) --------
  localparam int LUT_BITS = 11;               // 2048 entradas
  localparam int LUT_SIZE = (1<<LUT_BITS);
  localparam int SHIFT_1_128 = 7;             // Q2.14 -> passo de 1/128
  localparam int OFFS_8Q14  = (8 << 14);      // +8.0 em Q2.14

  (* rom_style="block" *) logic [15:0] SIGMOID_LUT [0:LUT_SIZE-1];
  initial $readmemh("sigmoid_q15.mem", SIGMOID_LUT);

  function automatic [15:0] sigmoid_q15(input logic signed [31:0] v_q14);
    // mapeia v in Q2.14 de [-8,+8] para [0..2047]
    int signed shifted = v_q14 + OFFS_8Q14;              // desloca -8..+8 -> 0..16
    int idx = shifted >>> SHIFT_1_128;                   // / (1/128) => 0..2048
    if (idx < 0) idx = 0;
    else if (idx > (LUT_SIZE-1)) idx = (LUT_SIZE-1);
    return SIGMOID_LUT[idx];
  endfunction

  // -------- Saída registrada --------
  always_ff @(posedge clock_i or posedge reset_i) begin
    if (reset_i) begin
      out_valid_o <= 1'b0;
      y_o         <= 16'd0;
    end else begin
      out_valid_o <= s0_valid;
      if (s0_valid) y_o <= sigmoid_q15(acc_q14);
    end
  end

endmodule
