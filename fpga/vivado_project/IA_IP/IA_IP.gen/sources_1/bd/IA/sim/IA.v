//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
//Date        : Wed Aug 27 10:37:41 2025
//Host        : LAPTOP-TDIUQR79 running 64-bit major release  (build 9200)
//Command     : generate_target IA.bd
//Design      : IA
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "IA,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=IA,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=2,numReposBlks=2,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_clkrst_cnt=2,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "IA.hwdef" *) 
module IA
   (clock_i_0,
    data_i_0,
    data_valid_i_0,
    out_valid_o_0,
    reset_i_0,
    y_o_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLOCK_I_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLOCK_I_0, ASSOCIATED_RESET reset_i_0, CLK_DOMAIN IA_clock_i_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clock_i_0;
  input [1447:0]data_i_0;
  input data_valid_i_0;
  output out_valid_o_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_I_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_I_0, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input reset_i_0;
  output [1023:0]y_o_0;

  wire clock_i_0;
  wire [1447:0]data_i_0;
  wire data_valid_i_0;
  wire out_valid_o_0;
  wire reset_i_0;
  wire [2895:0]stdz_181_0_data_o;
  wire stdz_181_0_data_valid_o;
  wire [1023:0]y_o_0;

  IA_dense1_181x64_relu_0_2 dense1_181x64_relu_0
       (.clock_i(clock_i_0),
        .data_i(stdz_181_0_data_o),
        .data_valid_i(stdz_181_0_data_valid_o),
        .out_valid_o(out_valid_o_0),
        .reset_i(reset_i_0),
        .y_o(y_o_0));
  IA_stdz_181_0_0 stdz_181_0
       (.clock_i(clock_i_0),
        .data_i(data_i_0),
        .data_o(stdz_181_0_data_o),
        .data_valid_i(data_valid_i_0),
        .data_valid_o(stdz_181_0_data_valid_o),
        .reset_i(reset_i_0));
endmodule
