`timescale 1ns/1ps
`default_nettype none

module dense_stage3 #(
  parameter string W_MEM = "W3.mem",
  parameter string B_MEM = "b3_fixed_hex.mem",
  parameter int SHIFT = 7,
  parameter bit ROUND = 1
)(
  input  logic clk_i,
  input  logic rst_i,
  input  logic start_i,
  output logic busy_o,
  output logic done_o,

  // entrada: 32 amostras s8 (aqui em 16b sign-extended; baixamos p/ 8)
  input  logic       in_valid_i,
  output logic       in_ready_o,
  input  logic [15:0] in_data_s16_i,

  // saída: 1 neurônio s16 (linear)
  output logic       out_valid_o,
  output logic [15:0] out_data_s16_o
);
  dense_mac1_generic #(
    .IN_DIM        (32),
    .OUT_DIM       (1),
    .W_MEM         (W_MEM),
    .B_MEM         (B_MEM),
    .REQUANT_SHIFT (SHIFT),
    .REQUANT_ROUND (ROUND),
    .OUT_BITS      (16),
    .USE_RELU      (0)
  ) u_core (
    .clk_i(clk_i), .rst_i(rst_i),
    .start_i(start_i), .busy_o(busy_o), .done_o(done_o),
    .in_valid_i(in_valid_i), .in_ready_o(in_ready_o), .in_data_s8_i(in_data_s16_i[7:0]),
    .out_valid_o(out_valid_o), .out_data_s16_o(out_data_s16_o)
  );
endmodule

`default_nettype wire
