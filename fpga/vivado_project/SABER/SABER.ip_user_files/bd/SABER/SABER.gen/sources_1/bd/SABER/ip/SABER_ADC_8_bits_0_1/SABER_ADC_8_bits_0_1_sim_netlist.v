// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
// Date        : Thu Aug 21 19:15:46 2025
// Host        : LAPTOP-TDIUQR79 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/cncai/Desktop/EMSE/AMD/Final_Files/SABER/SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/SABER_ADC_8_bits_0_1_sim_netlist.v
// Design      : SABER_ADC_8_bits_0_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "SABER_ADC_8_bits_0_1,ADC_8_bits,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "IPI" *) 
(* X_CORE_INFO = "ADC_8_bits,Vivado 2024.2" *) 
(* NotValidForBitStream *)
module SABER_ADC_8_bits_0_1
   (V_N_i,
    V_P_i,
    clock_i,
    data_o,
    reset_i);
  input V_N_i;
  input V_P_i;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLOCK_I CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLOCK_I, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN SABER_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input clock_i;
  output [7:0]data_o;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_I RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_I, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *) input reset_i;

  wire V_N_i;
  wire V_P_i;
  (* IBUF_LOW_PWR *) wire clock_i;
  wire [7:0]data_o;
  wire reset_i;

  (* HW_HANDOFF = "ADC_8_bits.hwdef" *) 
  SABER_ADC_8_bits_0_1_ADC_8_bits inst
       (.V_N_i(V_N_i),
        .V_P_i(V_P_i),
        .clock_i(clock_i),
        .data_o(data_o),
        .reset_i(reset_i));
endmodule

(* HW_HANDOFF = "ADC_8_bits.hwdef" *) (* ORIG_REF_NAME = "ADC_8_bits" *) 
module SABER_ADC_8_bits_0_1_ADC_8_bits
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
  wire [15:8]xadc_wiz_0_do_out;
  wire NLW_clk_wiz_0_locked_UNCONNECTED;
  wire NLW_xadc_wiz_0_alarm_out_UNCONNECTED;
  wire NLW_xadc_wiz_0_busy_out_UNCONNECTED;
  wire NLW_xadc_wiz_0_drdy_out_UNCONNECTED;
  wire NLW_xadc_wiz_0_eoc_out_UNCONNECTED;
  wire NLW_xadc_wiz_0_eos_out_UNCONNECTED;
  wire NLW_xadc_wiz_0_vccaux_alarm_out_UNCONNECTED;
  wire [4:0]NLW_xadc_wiz_0_channel_out_UNCONNECTED;
  wire [7:0]NLW_xadc_wiz_0_do_out_UNCONNECTED;

  SABER_ADC_8_bits_0_1_ADC_8_bits_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(clock_i),
        .clk_out1(clk_wiz_0_clk_out1),
        .locked(NLW_clk_wiz_0_locked_UNCONNECTED),
        .reset(reset_i));
  SABER_ADC_8_bits_0_1_ADC_8_bits_xadc_wiz_0_0 xadc_wiz_0
       (.alarm_out(NLW_xadc_wiz_0_alarm_out_UNCONNECTED),
        .busy_out(NLW_xadc_wiz_0_busy_out_UNCONNECTED),
        .channel_out(NLW_xadc_wiz_0_channel_out_UNCONNECTED[4:0]),
        .daddr_in({1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1}),
        .dclk_in(clk_wiz_0_clk_out1),
        .den_in(1'b0),
        .di_in({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .do_out({xadc_wiz_0_do_out,NLW_xadc_wiz_0_do_out_UNCONNECTED[7:0]}),
        .drdy_out(NLW_xadc_wiz_0_drdy_out_UNCONNECTED),
        .dwe_in(1'b0),
        .eoc_out(NLW_xadc_wiz_0_eoc_out_UNCONNECTED),
        .eos_out(NLW_xadc_wiz_0_eos_out_UNCONNECTED),
        .reset_in(reset_i),
        .vauxn1(V_N_i),
        .vauxp1(V_P_i),
        .vccaux_alarm_out(NLW_xadc_wiz_0_vccaux_alarm_out_UNCONNECTED),
        .vn_in(1'b0),
        .vp_in(1'b0));
  (* CHECK_LICENSE_TYPE = "ADC_8_bits_xlslice_0_0,xlslice_v1_0_4_xlslice,{}" *) 
  (* DowngradeIPIdentifiedWarnings = "yes" *) 
  (* X_CORE_INFO = "xlslice_v1_0_4_xlslice,Vivado 2024.2" *) 
  SABER_ADC_8_bits_0_1_ADC_8_bits_xlslice_0_0 xlslice_0
       (.Din({xadc_wiz_0_do_out,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .Dout(data_o));
endmodule

(* ORIG_REF_NAME = "ADC_8_bits_clk_wiz_0_0" *) 
module SABER_ADC_8_bits_0_1_ADC_8_bits_clk_wiz_0_0
   (clk_out1,
    reset,
    locked,
    clk_in1);
  output clk_out1;
  input reset;
  output locked;
  input clk_in1;

  wire \<const0> ;
  wire clk_in1;
  wire clk_out1;
  wire reset;
  wire NLW_inst_locked_UNCONNECTED;

  assign locked = \<const0> ;
  GND GND
       (.G(\<const0> ));
  SABER_ADC_8_bits_0_1_ADC_8_bits_clk_wiz_0_0_clk_wiz inst
       (.clk_in1(clk_in1),
        .clk_out1(clk_out1),
        .locked(NLW_inst_locked_UNCONNECTED),
        .reset(reset));
endmodule

(* ORIG_REF_NAME = "ADC_8_bits_clk_wiz_0_0_clk_wiz" *) 
module SABER_ADC_8_bits_0_1_ADC_8_bits_clk_wiz_0_0_clk_wiz
   (clk_out1,
    reset,
    locked,
    clk_in1);
  output clk_out1;
  input reset;
  output locked;
  input clk_in1;

  wire \<const0> ;
  wire clk_in1;
  wire clk_in1_ADC_8_bits_clk_wiz_0_0;
  wire clk_out1;
  wire clk_out1_ADC_8_bits_clk_wiz_0_0;
  wire clkfbout_ADC_8_bits_clk_wiz_0_0;
  wire clkfbout_buf_ADC_8_bits_clk_wiz_0_0;
  wire mmcm_adv_inst_n_16;
  wire reset;
  wire NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT1_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT2_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT3_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT4_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED;
  wire NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED;
  wire NLW_mmcm_adv_inst_DRDY_UNCONNECTED;
  wire NLW_mmcm_adv_inst_PSDONE_UNCONNECTED;
  wire [15:0]NLW_mmcm_adv_inst_DO_UNCONNECTED;

  assign locked = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkf_buf
       (.I(clkfbout_ADC_8_bits_clk_wiz_0_0),
        .O(clkfbout_buf_ADC_8_bits_clk_wiz_0_0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* CAPACITANCE = "DONT_CARE" *) 
  (* IBUF_DELAY_VALUE = "0" *) 
  (* IFD_DELAY_VALUE = "AUTO" *) 
  IBUF #(
    .IOSTANDARD("DEFAULT")) 
    clkin1_ibufg
       (.I(clk_in1),
        .O(clk_in1_ADC_8_bits_clk_wiz_0_0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  BUFG clkout1_buf
       (.I(clk_out1_ADC_8_bits_clk_wiz_0_0),
        .O(clk_out1));
  (* BOX_TYPE = "PRIMITIVE" *) 
  MMCME2_ADV #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKFBOUT_MULT_F(15.625000),
    .CLKFBOUT_PHASE(0.000000),
    .CLKFBOUT_USE_FINE_PS("FALSE"),
    .CLKIN1_PERIOD(10.000000),
    .CLKIN2_PERIOD(0.000000),
    .CLKOUT0_DIVIDE_F(78.125000),
    .CLKOUT0_DUTY_CYCLE(0.500000),
    .CLKOUT0_PHASE(0.000000),
    .CLKOUT0_USE_FINE_PS("FALSE"),
    .CLKOUT1_DIVIDE(1),
    .CLKOUT1_DUTY_CYCLE(0.500000),
    .CLKOUT1_PHASE(0.000000),
    .CLKOUT1_USE_FINE_PS("FALSE"),
    .CLKOUT2_DIVIDE(1),
    .CLKOUT2_DUTY_CYCLE(0.500000),
    .CLKOUT2_PHASE(0.000000),
    .CLKOUT2_USE_FINE_PS("FALSE"),
    .CLKOUT3_DIVIDE(1),
    .CLKOUT3_DUTY_CYCLE(0.500000),
    .CLKOUT3_PHASE(0.000000),
    .CLKOUT3_USE_FINE_PS("FALSE"),
    .CLKOUT4_CASCADE("FALSE"),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT4_DUTY_CYCLE(0.500000),
    .CLKOUT4_PHASE(0.000000),
    .CLKOUT4_USE_FINE_PS("FALSE"),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT5_DUTY_CYCLE(0.500000),
    .CLKOUT5_PHASE(0.000000),
    .CLKOUT5_USE_FINE_PS("FALSE"),
    .CLKOUT6_DIVIDE(1),
    .CLKOUT6_DUTY_CYCLE(0.500000),
    .CLKOUT6_PHASE(0.000000),
    .CLKOUT6_USE_FINE_PS("FALSE"),
    .COMPENSATION("ZHOLD"),
    .DIVCLK_DIVIDE(2),
    .IS_CLKINSEL_INVERTED(1'b0),
    .IS_PSEN_INVERTED(1'b0),
    .IS_PSINCDEC_INVERTED(1'b0),
    .IS_PWRDWN_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .REF_JITTER1(0.010000),
    .REF_JITTER2(0.010000),
    .SS_EN("FALSE"),
    .SS_MODE("CENTER_HIGH"),
    .SS_MOD_PERIOD(10000),
    .STARTUP_WAIT("FALSE")) 
    mmcm_adv_inst
       (.CLKFBIN(clkfbout_buf_ADC_8_bits_clk_wiz_0_0),
        .CLKFBOUT(clkfbout_ADC_8_bits_clk_wiz_0_0),
        .CLKFBOUTB(NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED),
        .CLKFBSTOPPED(NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED),
        .CLKIN1(clk_in1_ADC_8_bits_clk_wiz_0_0),
        .CLKIN2(1'b0),
        .CLKINSEL(1'b1),
        .CLKINSTOPPED(NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED),
        .CLKOUT0(clk_out1_ADC_8_bits_clk_wiz_0_0),
        .CLKOUT0B(NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED),
        .CLKOUT1(NLW_mmcm_adv_inst_CLKOUT1_UNCONNECTED),
        .CLKOUT1B(NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED),
        .CLKOUT2(NLW_mmcm_adv_inst_CLKOUT2_UNCONNECTED),
        .CLKOUT2B(NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED),
        .CLKOUT3(NLW_mmcm_adv_inst_CLKOUT3_UNCONNECTED),
        .CLKOUT3B(NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED),
        .CLKOUT4(NLW_mmcm_adv_inst_CLKOUT4_UNCONNECTED),
        .CLKOUT5(NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED),
        .CLKOUT6(NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED),
        .DADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DCLK(1'b0),
        .DEN(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DO(NLW_mmcm_adv_inst_DO_UNCONNECTED[15:0]),
        .DRDY(NLW_mmcm_adv_inst_DRDY_UNCONNECTED),
        .DWE(1'b0),
        .LOCKED(mmcm_adv_inst_n_16),
        .PSCLK(1'b0),
        .PSDONE(NLW_mmcm_adv_inst_PSDONE_UNCONNECTED),
        .PSEN(1'b0),
        .PSINCDEC(1'b0),
        .PWRDWN(1'b0),
        .RST(reset));
endmodule

(* ORIG_REF_NAME = "ADC_8_bits_xadc_wiz_0_0" *) 
module SABER_ADC_8_bits_0_1_ADC_8_bits_xadc_wiz_0_0
   (daddr_in,
    dclk_in,
    den_in,
    di_in,
    dwe_in,
    reset_in,
    vauxp1,
    vauxn1,
    busy_out,
    channel_out,
    do_out,
    drdy_out,
    eoc_out,
    eos_out,
    vccaux_alarm_out,
    alarm_out,
    vp_in,
    vn_in);
  input [6:0]daddr_in;
  input dclk_in;
  input den_in;
  input [15:0]di_in;
  input dwe_in;
  input reset_in;
  input vauxp1;
  input vauxn1;
  output busy_out;
  output [4:0]channel_out;
  output [15:0]do_out;
  output drdy_out;
  output eoc_out;
  output eos_out;
  output vccaux_alarm_out;
  output alarm_out;
  input vp_in;
  input vn_in;

  wire \<const0> ;
  wire dclk_in;
  wire [15:8]\^do_out ;
  wire inst_n_0;
  wire inst_n_1;
  wire inst_n_16;
  wire inst_n_17;
  wire inst_n_18;
  wire inst_n_19;
  wire inst_n_2;
  wire inst_n_20;
  wire inst_n_21;
  wire inst_n_22;
  wire inst_n_23;
  wire inst_n_24;
  wire inst_n_25;
  wire inst_n_26;
  wire inst_n_27;
  wire inst_n_28;
  wire inst_n_3;
  wire inst_n_34;
  wire inst_n_39;
  wire reset_in;
  wire vauxn1;
  wire vauxp1;
  wire NLW_inst_JTAGBUSY_UNCONNECTED;
  wire NLW_inst_JTAGLOCKED_UNCONNECTED;
  wire NLW_inst_JTAGMODIFIED_UNCONNECTED;
  wire NLW_inst_OT_UNCONNECTED;
  wire [6:0]NLW_inst_ALM_UNCONNECTED;
  wire [4:0]NLW_inst_MUXADDR_UNCONNECTED;

  assign alarm_out = \<const0> ;
  assign busy_out = \<const0> ;
  assign channel_out[4] = \<const0> ;
  assign channel_out[3] = \<const0> ;
  assign channel_out[2] = \<const0> ;
  assign channel_out[1] = \<const0> ;
  assign channel_out[0] = \<const0> ;
  assign do_out[15:8] = \^do_out [15:8];
  assign do_out[7] = \<const0> ;
  assign do_out[6] = \<const0> ;
  assign do_out[5] = \<const0> ;
  assign do_out[4] = \<const0> ;
  assign do_out[3] = \<const0> ;
  assign do_out[2] = \<const0> ;
  assign do_out[1] = \<const0> ;
  assign do_out[0] = \<const0> ;
  assign drdy_out = \<const0> ;
  assign eoc_out = \<const0> ;
  assign eos_out = \<const0> ;
  assign vccaux_alarm_out = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* BOX_TYPE = "PRIMITIVE" *) 
  XADC #(
    .INIT_40(16'h0011),
    .INIT_41(16'h31A7),
    .INIT_42(16'h0400),
    .INIT_43(16'h0000),
    .INIT_44(16'h0000),
    .INIT_45(16'h0000),
    .INIT_46(16'h0000),
    .INIT_47(16'h0000),
    .INIT_48(16'h0100),
    .INIT_49(16'h0000),
    .INIT_4A(16'h0000),
    .INIT_4B(16'h0000),
    .INIT_4C(16'h0000),
    .INIT_4D(16'h0000),
    .INIT_4E(16'h0000),
    .INIT_4F(16'h0000),
    .INIT_50(16'hB5ED),
    .INIT_51(16'h57E4),
    .INIT_52(16'hA147),
    .INIT_53(16'hCA33),
    .INIT_54(16'hA93A),
    .INIT_55(16'h52C6),
    .INIT_56(16'h9555),
    .INIT_57(16'hAE4E),
    .INIT_58(16'h5999),
    .INIT_59(16'h5555),
    .INIT_5A(16'h9999),
    .INIT_5B(16'h6AAA),
    .INIT_5C(16'h5111),
    .INIT_5D(16'h5111),
    .INIT_5E(16'h91EB),
    .INIT_5F(16'h6666),
    .IS_CONVSTCLK_INVERTED(1'b0),
    .IS_DCLK_INVERTED(1'b0),
    .SIM_DEVICE("ZYNQ"),
    .SIM_MONITOR_FILE("design.txt")) 
    inst
       (.ALM({inst_n_34,NLW_inst_ALM_UNCONNECTED[6:3],inst_n_39,NLW_inst_ALM_UNCONNECTED[1:0]}),
        .BUSY(inst_n_0),
        .CHANNEL({inst_n_24,inst_n_25,inst_n_26,inst_n_27,inst_n_28}),
        .CONVST(1'b0),
        .CONVSTCLK(1'b0),
        .DADDR({1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1}),
        .DCLK(dclk_in),
        .DEN(inst_n_2),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DO({\^do_out ,inst_n_16,inst_n_17,inst_n_18,inst_n_19,inst_n_20,inst_n_21,inst_n_22,inst_n_23}),
        .DRDY(inst_n_1),
        .DWE(1'b0),
        .EOC(inst_n_2),
        .EOS(inst_n_3),
        .JTAGBUSY(NLW_inst_JTAGBUSY_UNCONNECTED),
        .JTAGLOCKED(NLW_inst_JTAGLOCKED_UNCONNECTED),
        .JTAGMODIFIED(NLW_inst_JTAGMODIFIED_UNCONNECTED),
        .MUXADDR(NLW_inst_MUXADDR_UNCONNECTED[4:0]),
        .OT(NLW_inst_OT_UNCONNECTED),
        .RESET(reset_in),
        .VAUXN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,vauxn1,1'b0}),
        .VAUXP({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,vauxp1,1'b0}),
        .VN(1'b0),
        .VP(1'b0));
endmodule

(* CHECK_LICENSE_TYPE = "ADC_8_bits_xlslice_0_0,xlslice_v1_0_4_xlslice,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* ORIG_REF_NAME = "ADC_8_bits_xlslice_0_0" *) 
(* X_CORE_INFO = "xlslice_v1_0_4_xlslice,Vivado 2024.2" *) 
module SABER_ADC_8_bits_0_1_ADC_8_bits_xlslice_0_0
   (Din,
    Dout);
  input [15:0]Din;
  output [7:0]Dout;

  wire [15:0]Din;

  assign Dout[7:0] = Din[15:8];
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
