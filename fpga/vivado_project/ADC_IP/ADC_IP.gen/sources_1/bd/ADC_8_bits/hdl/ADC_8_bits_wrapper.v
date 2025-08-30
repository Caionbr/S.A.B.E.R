//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
//Date        : Thu Aug 21 17:26:46 2025
//Host        : LAPTOP-TDIUQR79 running 64-bit major release  (build 9200)
//Command     : generate_target ADC_8_bits_wrapper.bd
//Design      : ADC_8_bits_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module ADC_8_bits_wrapper
   (VN_i,
    VP_i,
    clock_i,
    data_o,
    reset_i);
  input VN_i;
  input VP_i;
  input clock_i;
  output [7:0]data_o;
  input reset_i;

  wire VN_i;
  wire VP_i;
  wire clock_i;
  wire [7:0]data_o;
  wire reset_i;

  ADC_8_bits ADC_8_bits_i
       (.VN_i(VN_i),
        .VP_i(VP_i),
        .clock_i(clock_i),
        .data_o(data_o),
        .reset_i(reset_i));
endmodule
