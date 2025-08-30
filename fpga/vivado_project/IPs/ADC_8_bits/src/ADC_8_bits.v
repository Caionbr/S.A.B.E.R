//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
//Date        : Wed Aug 20 18:59:26 2025
//Host        : LAPTOP-TDIUQR79 running 64-bit major release  (build 9200)
//Command     : generate_target ADC_8_bits.bd
//Design      : ADC_8_bits
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "ADC_8_bits,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=ADC_8_bits,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=6,numReposBlks=6,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "ADC_8_bits.hwdef" *) 
module ADC_8_bits
   (V_N_i,
    V_P_i,
    clock_i,
    data_o,
    reset_i);
  input V_N_i;
  input V_P_i;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLOCK_I CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLOCK_I, CLK_DOMAIN ADC_8_bits_clk_in1_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input clock_i;
  output [7:0]data_o;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_I RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_I, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input reset_i;

  wire V_N_i;
  wire V_P_i;
  wire clk_wiz_0_clk_out1;
  wire clock_i;
  wire [7:0]data_o;
  wire reset_i;
  wire [15:0]xadc_wiz_0_do_out;
  wire xadc_wiz_0_eoc_out;
  wire [0:0]xlconstant_0_dout;
  wire [15:0]xlconstant_1_dout;
  wire [6:0]xlconstant_2_dout;

  ADC_8_bits_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(clock_i),
        .clk_out1(clk_wiz_0_clk_out1),
        .reset(reset_i));
  ADC_8_bits_xadc_wiz_0_0 xadc_wiz_0
       (.daddr_in(xlconstant_2_dout),
        .dclk_in(clk_wiz_0_clk_out1),
        .den_in(xadc_wiz_0_eoc_out),
        .di_in(xlconstant_1_dout),
        .do_out(xadc_wiz_0_do_out),
        .dwe_in(xlconstant_0_dout),
        .eoc_out(xadc_wiz_0_eoc_out),
        .reset_in(reset_i),
        .vauxn1(V_N_i),
        .vauxp1(V_P_i),
        .vn_in(xlconstant_0_dout),
        .vp_in(xlconstant_0_dout));
  ADC_8_bits_xlconstant_0_0 xlconstant_0
       (.dout(xlconstant_0_dout));
  ADC_8_bits_xlconstant_1_0 xlconstant_1
       (.dout(xlconstant_1_dout));
  ADC_8_bits_xlconstant_2_0 xlconstant_2
       (.dout(xlconstant_2_dout));
  ADC_8_bits_xlslice_0_0 xlslice_0
       (.Din(xadc_wiz_0_do_out),
        .Dout(data_o));
endmodule
