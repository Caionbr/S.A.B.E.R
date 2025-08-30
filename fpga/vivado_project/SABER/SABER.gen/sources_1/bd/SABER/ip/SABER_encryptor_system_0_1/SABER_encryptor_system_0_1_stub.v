// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Aug 21 20:50:34 2025
// Host        : LAPTOP-TDIUQR79 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/cncai/Desktop/EMSE/AMD/Final_Files/SABER/SABER.gen/sources_1/bd/SABER/ip/SABER_encryptor_system_0_1/SABER_encryptor_system_0_1_stub.v
// Design      : SABER_encryptor_system_0_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "SABER_encryptor_system_0_1,encryptor_system,{}" *) (* CORE_GENERATION_INFO = "SABER_encryptor_system_0_1,encryptor_system,{x_ipProduct=Vivado 2024.2,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=encryptor_system,x_ipVersion=2.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* IP_DEFINITION_SOURCE = "package_project" *) (* X_CORE_INFO = "encryptor_system,Vivado 2024.2" *) 
module SABER_encryptor_system_0_1(go_i, data_i, reset_i, clock_i, add_o, data_o, 
  data_valid_o, send_data_o)
/* synthesis syn_black_box black_box_pad_pin="go_i,data_i[7:0],reset_i,add_o,data_o[1791:0],data_valid_o,send_data_o" */
/* synthesis syn_force_seq_prim="clock_i" */;
  input go_i;
  input [7:0]data_i;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset_i RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME reset_i, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *) input reset_i;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clock_i CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clock_i, ASSOCIATED_RESET reset_i, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0, ASSOCIATED_BUSIF frame_if, FREQ_TOLERANCE_HZ 0, CLK_DOMAIN SABER_processing_system7_0_0_FCLK_CLK0" *) input clock_i /* synthesis syn_isclock = 1 */;
  output add_o;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 frame_if DATA" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME frame_if, LAYERED_METADATA undef" *) output [1791:0]data_o;
  output data_valid_o;
  output send_data_o;
endmodule
