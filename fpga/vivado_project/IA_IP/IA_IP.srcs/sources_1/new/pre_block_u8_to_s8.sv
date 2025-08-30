`timescale 1ns/1ps
`default_nettype none

module pre_block_u8_to_s8 #(
  parameter int ZERO_POINT = 128,
  parameter int SHIFT_UP   = 1  // 0..3
)(
  input  logic        clk_i,
  input  logic        rst_i,

  // streaming in
  input  logic        in_valid_i,
  output logic        in_ready_o,
  input  logic [7:0]  in_data_u8_i,

  // streaming out (signed 8b packed em [7:0])
  output logic        out_valid_o,
  input  logic        out_ready_i,
  output logic [7:0]  out_data_s8_o
);
  assign in_ready_o = out_ready_i;

  function automatic [7:0] clamp_s8(input integer v);
    if (v > 127)       clamp_s8 = 8'h7F;
    else if (v < -128) clamp_s8 = 8'h80;
    else               clamp_s8 = v[7:0];
  endfunction

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      out_valid_o    <= 1'b0;
      out_data_s8_o  <= 8'd0;
    end else begin
      out_valid_o <= 1'b0;
      if (in_valid_i && in_ready_o) begin
        integer tmp;
        tmp = integer'(in_data_u8_i) - integer'(ZERO_POINT);
        tmp = tmp <<< SHIFT_UP;
        out_data_s8_o <= clamp_s8(tmp);
        out_valid_o   <= 1'b1;
      end
    end
  end
endmodule

`default_nettype wire
