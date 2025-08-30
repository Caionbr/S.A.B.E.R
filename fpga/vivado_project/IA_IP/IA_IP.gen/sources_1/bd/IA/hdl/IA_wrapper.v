//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
//Date        : Wed Aug 27 10:37:41 2025
//Host        : LAPTOP-TDIUQR79 running 64-bit major release  (build 9200)
//Command     : generate_target IA_wrapper.bd
//Design      : IA_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module IA_wrapper
   (clock_i_0,
    data_i_0,
    data_valid_i_0,
    out_valid_o_0,
    reset_i_0,
    y_o_0);
  input clock_i_0;
  input [1447:0]data_i_0;
  input data_valid_i_0;
  output out_valid_o_0;
  input reset_i_0;
  output [1023:0]y_o_0;

  wire clock_i_0;
  wire [1447:0]data_i_0;
  wire data_valid_i_0;
  wire out_valid_o_0;
  wire reset_i_0;
  wire [1023:0]y_o_0;

  IA IA_i
       (.clock_i_0(clock_i_0),
        .data_i_0(data_i_0),
        .data_valid_i_0(data_valid_i_0),
        .out_valid_o_0(out_valid_o_0),
        .reset_i_0(reset_i_0),
        .y_o_0(y_o_0));
endmodule
