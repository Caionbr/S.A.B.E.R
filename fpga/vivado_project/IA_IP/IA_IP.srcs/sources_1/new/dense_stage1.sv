`timescale 1ns/1ps
`default_nettype none

module dense_stage1 #(
  parameter string W_MEM = "W1.mem",
  parameter string B_MEM = "b1_fixed_hex.mem",
  parameter int SHIFT = 7,
  parameter bit ROUND = 1
)(
  input  logic clk_i,
  input  logic rst_i,
  input  logic start_i,
  output logic busy_o,
  output logic done_o,

  // entrada: 181 amostras s8 em [7:0]
  input  logic       in_valid_i,
  output logic       in_ready_o,
  input  logic [7:0] in_data_s8_i,

  // saída: 64 neurônios s8 (sign-extended em 16b na porta)
  output logic       out_valid_o,
  output logic [15:0] out_data_s16_o
);
  dense_mac1_generic #(
    .IN_DIM        (181),
    .OUT_DIM       (64),
    .W_MEM         (W_MEM),
    .B_MEM         (B_MEM),
    .REQUANT_SHIFT (SHIFT),
    .REQUANT_ROUND (ROUND),
    .OUT_BITS      (8),
    .USE_RELU      (1)
  ) u_core (
    .clk_i(clk_i), .rst_i(rst_i),
    .start_i(start_i), .busy_o(busy_o), .done_o(done_o),
    .in_valid_i(in_valid_i), .in_ready_o(in_ready_o), .in_data_s8_i(in_data_s8_i),
    .out_valid_o(out_valid_o), .out_data_s16_o(out_data_s16_o)
  );
endmodule

`default_nettype wire
