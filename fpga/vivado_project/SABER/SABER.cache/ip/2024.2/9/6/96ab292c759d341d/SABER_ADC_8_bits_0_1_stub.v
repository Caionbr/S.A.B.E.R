// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Aug 21 19:15:44 2025
// Host        : LAPTOP-TDIUQR79 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ SABER_ADC_8_bits_0_1_stub.v
// Design      : SABER_ADC_8_bits_0_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "SABER_ADC_8_bits_0_1,ADC_8_bits,{}" *) (* CORE_GENERATION_INFO = "SABER_ADC_8_bits_0_1,ADC_8_bits,{x_ipProduct=Vivado 2024.2,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=ADC_8_bits,x_ipVersion=2.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* IP_DEFINITION_SOURCE = "IPI" *) (* X_CORE_INFO = "ADC_8_bits,Vivado 2024.2" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(V_N_i, V_P_i, clock_i, data_o, reset_i)
/* synthesis syn_black_box black_box_pad_pin="V_N_i,V_P_i,clock_i,data_o[7:0],reset_i" */;
  input V_N_i;
  input V_P_i;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLOCK_I CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLOCK_I, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN SABER_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input clock_i;
  output [7:0]data_o;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_I RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_I, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *) input reset_i;
endmodule
