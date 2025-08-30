-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
-- Date        : Thu Aug 21 19:15:46 2025
-- Host        : LAPTOP-TDIUQR79 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/Users/cncai/Desktop/EMSE/AMD/Final_Files/SABER/SABER.gen/sources_1/bd/SABER/ip/SABER_ADC_8_bits_0_1/SABER_ADC_8_bits_0_1_sim_netlist.vhdl
-- Design      : SABER_ADC_8_bits_0_1
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity SABER_ADC_8_bits_0_1_ADC_8_bits_clk_wiz_0_0_clk_wiz is
  port (
    clk_out1 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of SABER_ADC_8_bits_0_1_ADC_8_bits_clk_wiz_0_0_clk_wiz : entity is "ADC_8_bits_clk_wiz_0_0_clk_wiz";
end SABER_ADC_8_bits_0_1_ADC_8_bits_clk_wiz_0_0_clk_wiz;

architecture STRUCTURE of SABER_ADC_8_bits_0_1_ADC_8_bits_clk_wiz_0_0_clk_wiz is
  signal \<const0>\ : STD_LOGIC;
  signal clk_in1_ADC_8_bits_clk_wiz_0_0 : STD_LOGIC;
  signal clk_out1_ADC_8_bits_clk_wiz_0_0 : STD_LOGIC;
  signal clkfbout_ADC_8_bits_clk_wiz_0_0 : STD_LOGIC;
  signal clkfbout_buf_ADC_8_bits_clk_wiz_0_0 : STD_LOGIC;
  signal mmcm_adv_inst_n_16 : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT1_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT2_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT3_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT4_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_DRDY_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_PSDONE_UNCONNECTED : STD_LOGIC;
  signal NLW_mmcm_adv_inst_DO_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of clkf_buf : label is "PRIMITIVE";
  attribute BOX_TYPE of clkin1_ibufg : label is "PRIMITIVE";
  attribute CAPACITANCE : string;
  attribute CAPACITANCE of clkin1_ibufg : label is "DONT_CARE";
  attribute IBUF_DELAY_VALUE : string;
  attribute IBUF_DELAY_VALUE of clkin1_ibufg : label is "0";
  attribute IFD_DELAY_VALUE : string;
  attribute IFD_DELAY_VALUE of clkin1_ibufg : label is "AUTO";
  attribute BOX_TYPE of clkout1_buf : label is "PRIMITIVE";
  attribute BOX_TYPE of mmcm_adv_inst : label is "PRIMITIVE";
begin
  locked <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
clkf_buf: unisim.vcomponents.BUFG
     port map (
      I => clkfbout_ADC_8_bits_clk_wiz_0_0,
      O => clkfbout_buf_ADC_8_bits_clk_wiz_0_0
    );
clkin1_ibufg: unisim.vcomponents.IBUF
    generic map(
      IOSTANDARD => "DEFAULT"
    )
        port map (
      I => clk_in1,
      O => clk_in1_ADC_8_bits_clk_wiz_0_0
    );
clkout1_buf: unisim.vcomponents.BUFG
     port map (
      I => clk_out1_ADC_8_bits_clk_wiz_0_0,
      O => clk_out1
    );
mmcm_adv_inst: unisim.vcomponents.MMCME2_ADV
    generic map(
      BANDWIDTH => "OPTIMIZED",
      CLKFBOUT_MULT_F => 15.625000,
      CLKFBOUT_PHASE => 0.000000,
      CLKFBOUT_USE_FINE_PS => false,
      CLKIN1_PERIOD => 10.000000,
      CLKIN2_PERIOD => 0.000000,
      CLKOUT0_DIVIDE_F => 78.125000,
      CLKOUT0_DUTY_CYCLE => 0.500000,
      CLKOUT0_PHASE => 0.000000,
      CLKOUT0_USE_FINE_PS => false,
      CLKOUT1_DIVIDE => 1,
      CLKOUT1_DUTY_CYCLE => 0.500000,
      CLKOUT1_PHASE => 0.000000,
      CLKOUT1_USE_FINE_PS => false,
      CLKOUT2_DIVIDE => 1,
      CLKOUT2_DUTY_CYCLE => 0.500000,
      CLKOUT2_PHASE => 0.000000,
      CLKOUT2_USE_FINE_PS => false,
      CLKOUT3_DIVIDE => 1,
      CLKOUT3_DUTY_CYCLE => 0.500000,
      CLKOUT3_PHASE => 0.000000,
      CLKOUT3_USE_FINE_PS => false,
      CLKOUT4_CASCADE => false,
      CLKOUT4_DIVIDE => 1,
      CLKOUT4_DUTY_CYCLE => 0.500000,
      CLKOUT4_PHASE => 0.000000,
      CLKOUT4_USE_FINE_PS => false,
      CLKOUT5_DIVIDE => 1,
      CLKOUT5_DUTY_CYCLE => 0.500000,
      CLKOUT5_PHASE => 0.000000,
      CLKOUT5_USE_FINE_PS => false,
      CLKOUT6_DIVIDE => 1,
      CLKOUT6_DUTY_CYCLE => 0.500000,
      CLKOUT6_PHASE => 0.000000,
      CLKOUT6_USE_FINE_PS => false,
      COMPENSATION => "ZHOLD",
      DIVCLK_DIVIDE => 2,
      IS_CLKINSEL_INVERTED => '0',
      IS_PSEN_INVERTED => '0',
      IS_PSINCDEC_INVERTED => '0',
      IS_PWRDWN_INVERTED => '0',
      IS_RST_INVERTED => '0',
      REF_JITTER1 => 0.010000,
      REF_JITTER2 => 0.010000,
      SS_EN => "FALSE",
      SS_MODE => "CENTER_HIGH",
      SS_MOD_PERIOD => 10000,
      STARTUP_WAIT => false
    )
        port map (
      CLKFBIN => clkfbout_buf_ADC_8_bits_clk_wiz_0_0,
      CLKFBOUT => clkfbout_ADC_8_bits_clk_wiz_0_0,
      CLKFBOUTB => NLW_mmcm_adv_inst_CLKFBOUTB_UNCONNECTED,
      CLKFBSTOPPED => NLW_mmcm_adv_inst_CLKFBSTOPPED_UNCONNECTED,
      CLKIN1 => clk_in1_ADC_8_bits_clk_wiz_0_0,
      CLKIN2 => '0',
      CLKINSEL => '1',
      CLKINSTOPPED => NLW_mmcm_adv_inst_CLKINSTOPPED_UNCONNECTED,
      CLKOUT0 => clk_out1_ADC_8_bits_clk_wiz_0_0,
      CLKOUT0B => NLW_mmcm_adv_inst_CLKOUT0B_UNCONNECTED,
      CLKOUT1 => NLW_mmcm_adv_inst_CLKOUT1_UNCONNECTED,
      CLKOUT1B => NLW_mmcm_adv_inst_CLKOUT1B_UNCONNECTED,
      CLKOUT2 => NLW_mmcm_adv_inst_CLKOUT2_UNCONNECTED,
      CLKOUT2B => NLW_mmcm_adv_inst_CLKOUT2B_UNCONNECTED,
      CLKOUT3 => NLW_mmcm_adv_inst_CLKOUT3_UNCONNECTED,
      CLKOUT3B => NLW_mmcm_adv_inst_CLKOUT3B_UNCONNECTED,
      CLKOUT4 => NLW_mmcm_adv_inst_CLKOUT4_UNCONNECTED,
      CLKOUT5 => NLW_mmcm_adv_inst_CLKOUT5_UNCONNECTED,
      CLKOUT6 => NLW_mmcm_adv_inst_CLKOUT6_UNCONNECTED,
      DADDR(6 downto 0) => B"0000000",
      DCLK => '0',
      DEN => '0',
      DI(15 downto 0) => B"0000000000000000",
      DO(15 downto 0) => NLW_mmcm_adv_inst_DO_UNCONNECTED(15 downto 0),
      DRDY => NLW_mmcm_adv_inst_DRDY_UNCONNECTED,
      DWE => '0',
      LOCKED => mmcm_adv_inst_n_16,
      PSCLK => '0',
      PSDONE => NLW_mmcm_adv_inst_PSDONE_UNCONNECTED,
      PSEN => '0',
      PSINCDEC => '0',
      PWRDWN => '0',
      RST => reset
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity SABER_ADC_8_bits_0_1_ADC_8_bits_xadc_wiz_0_0 is
  port (
    daddr_in : in STD_LOGIC_VECTOR ( 6 downto 0 );
    dclk_in : in STD_LOGIC;
    den_in : in STD_LOGIC;
    di_in : in STD_LOGIC_VECTOR ( 15 downto 0 );
    dwe_in : in STD_LOGIC;
    reset_in : in STD_LOGIC;
    vauxp1 : in STD_LOGIC;
    vauxn1 : in STD_LOGIC;
    busy_out : out STD_LOGIC;
    channel_out : out STD_LOGIC_VECTOR ( 4 downto 0 );
    do_out : out STD_LOGIC_VECTOR ( 15 downto 0 );
    drdy_out : out STD_LOGIC;
    eoc_out : out STD_LOGIC;
    eos_out : out STD_LOGIC;
    vccaux_alarm_out : out STD_LOGIC;
    alarm_out : out STD_LOGIC;
    vp_in : in STD_LOGIC;
    vn_in : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of SABER_ADC_8_bits_0_1_ADC_8_bits_xadc_wiz_0_0 : entity is "ADC_8_bits_xadc_wiz_0_0";
end SABER_ADC_8_bits_0_1_ADC_8_bits_xadc_wiz_0_0;

architecture STRUCTURE of SABER_ADC_8_bits_0_1_ADC_8_bits_xadc_wiz_0_0 is
  signal \<const0>\ : STD_LOGIC;
  signal \^do_out\ : STD_LOGIC_VECTOR ( 15 downto 8 );
  signal inst_n_0 : STD_LOGIC;
  signal inst_n_1 : STD_LOGIC;
  signal inst_n_16 : STD_LOGIC;
  signal inst_n_17 : STD_LOGIC;
  signal inst_n_18 : STD_LOGIC;
  signal inst_n_19 : STD_LOGIC;
  signal inst_n_2 : STD_LOGIC;
  signal inst_n_20 : STD_LOGIC;
  signal inst_n_21 : STD_LOGIC;
  signal inst_n_22 : STD_LOGIC;
  signal inst_n_23 : STD_LOGIC;
  signal inst_n_24 : STD_LOGIC;
  signal inst_n_25 : STD_LOGIC;
  signal inst_n_26 : STD_LOGIC;
  signal inst_n_27 : STD_LOGIC;
  signal inst_n_28 : STD_LOGIC;
  signal inst_n_3 : STD_LOGIC;
  signal inst_n_34 : STD_LOGIC;
  signal inst_n_39 : STD_LOGIC;
  signal NLW_inst_JTAGBUSY_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_JTAGLOCKED_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_JTAGMODIFIED_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_OT_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_ALM_UNCONNECTED : STD_LOGIC_VECTOR ( 6 downto 0 );
  signal NLW_inst_MUXADDR_UNCONNECTED : STD_LOGIC_VECTOR ( 4 downto 0 );
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of inst : label is "PRIMITIVE";
begin
  alarm_out <= \<const0>\;
  busy_out <= \<const0>\;
  channel_out(4) <= \<const0>\;
  channel_out(3) <= \<const0>\;
  channel_out(2) <= \<const0>\;
  channel_out(1) <= \<const0>\;
  channel_out(0) <= \<const0>\;
  do_out(15 downto 8) <= \^do_out\(15 downto 8);
  do_out(7) <= \<const0>\;
  do_out(6) <= \<const0>\;
  do_out(5) <= \<const0>\;
  do_out(4) <= \<const0>\;
  do_out(3) <= \<const0>\;
  do_out(2) <= \<const0>\;
  do_out(1) <= \<const0>\;
  do_out(0) <= \<const0>\;
  drdy_out <= \<const0>\;
  eoc_out <= \<const0>\;
  eos_out <= \<const0>\;
  vccaux_alarm_out <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
inst: unisim.vcomponents.XADC
    generic map(
      INIT_40 => X"0011",
      INIT_41 => X"31A7",
      INIT_42 => X"0400",
      INIT_43 => X"0000",
      INIT_44 => X"0000",
      INIT_45 => X"0000",
      INIT_46 => X"0000",
      INIT_47 => X"0000",
      INIT_48 => X"0100",
      INIT_49 => X"0000",
      INIT_4A => X"0000",
      INIT_4B => X"0000",
      INIT_4C => X"0000",
      INIT_4D => X"0000",
      INIT_4E => X"0000",
      INIT_4F => X"0000",
      INIT_50 => X"B5ED",
      INIT_51 => X"57E4",
      INIT_52 => X"A147",
      INIT_53 => X"CA33",
      INIT_54 => X"A93A",
      INIT_55 => X"52C6",
      INIT_56 => X"9555",
      INIT_57 => X"AE4E",
      INIT_58 => X"5999",
      INIT_59 => X"5555",
      INIT_5A => X"9999",
      INIT_5B => X"6AAA",
      INIT_5C => X"5111",
      INIT_5D => X"5111",
      INIT_5E => X"91EB",
      INIT_5F => X"6666",
      IS_CONVSTCLK_INVERTED => '0',
      IS_DCLK_INVERTED => '0',
      SIM_DEVICE => "ZYNQ",
      SIM_MONITOR_FILE => "design.txt"
    )
        port map (
      ALM(7) => inst_n_34,
      ALM(6 downto 3) => NLW_inst_ALM_UNCONNECTED(6 downto 3),
      ALM(2) => inst_n_39,
      ALM(1 downto 0) => NLW_inst_ALM_UNCONNECTED(1 downto 0),
      BUSY => inst_n_0,
      CHANNEL(4) => inst_n_24,
      CHANNEL(3) => inst_n_25,
      CHANNEL(2) => inst_n_26,
      CHANNEL(1) => inst_n_27,
      CHANNEL(0) => inst_n_28,
      CONVST => '0',
      CONVSTCLK => '0',
      DADDR(6 downto 0) => B"0010001",
      DCLK => dclk_in,
      DEN => inst_n_2,
      DI(15 downto 0) => B"0000000000000000",
      DO(15 downto 8) => \^do_out\(15 downto 8),
      DO(7) => inst_n_16,
      DO(6) => inst_n_17,
      DO(5) => inst_n_18,
      DO(4) => inst_n_19,
      DO(3) => inst_n_20,
      DO(2) => inst_n_21,
      DO(1) => inst_n_22,
      DO(0) => inst_n_23,
      DRDY => inst_n_1,
      DWE => '0',
      EOC => inst_n_2,
      EOS => inst_n_3,
      JTAGBUSY => NLW_inst_JTAGBUSY_UNCONNECTED,
      JTAGLOCKED => NLW_inst_JTAGLOCKED_UNCONNECTED,
      JTAGMODIFIED => NLW_inst_JTAGMODIFIED_UNCONNECTED,
      MUXADDR(4 downto 0) => NLW_inst_MUXADDR_UNCONNECTED(4 downto 0),
      OT => NLW_inst_OT_UNCONNECTED,
      RESET => reset_in,
      VAUXN(15 downto 2) => B"00000000000000",
      VAUXN(1) => vauxn1,
      VAUXN(0) => '0',
      VAUXP(15 downto 2) => B"00000000000000",
      VAUXP(1) => vauxp1,
      VAUXP(0) => '0',
      VN => '0',
      VP => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity SABER_ADC_8_bits_0_1_ADC_8_bits_xlslice_0_0 is
  port (
    Din : in STD_LOGIC_VECTOR ( 15 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of SABER_ADC_8_bits_0_1_ADC_8_bits_xlslice_0_0 : entity is "ADC_8_bits_xlslice_0_0,xlslice_v1_0_4_xlslice,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of SABER_ADC_8_bits_0_1_ADC_8_bits_xlslice_0_0 : entity is "yes";
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of SABER_ADC_8_bits_0_1_ADC_8_bits_xlslice_0_0 : entity is "ADC_8_bits_xlslice_0_0";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of SABER_ADC_8_bits_0_1_ADC_8_bits_xlslice_0_0 : entity is "xlslice_v1_0_4_xlslice,Vivado 2024.2";
end SABER_ADC_8_bits_0_1_ADC_8_bits_xlslice_0_0;

architecture STRUCTURE of SABER_ADC_8_bits_0_1_ADC_8_bits_xlslice_0_0 is
  signal \^din\ : STD_LOGIC_VECTOR ( 15 downto 0 );
begin
  Dout(7 downto 0) <= \^din\(15 downto 8);
  \^din\(15 downto 8) <= Din(15 downto 8);
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity SABER_ADC_8_bits_0_1_ADC_8_bits_clk_wiz_0_0 is
  port (
    clk_out1 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of SABER_ADC_8_bits_0_1_ADC_8_bits_clk_wiz_0_0 : entity is "ADC_8_bits_clk_wiz_0_0";
end SABER_ADC_8_bits_0_1_ADC_8_bits_clk_wiz_0_0;

architecture STRUCTURE of SABER_ADC_8_bits_0_1_ADC_8_bits_clk_wiz_0_0 is
  signal \<const0>\ : STD_LOGIC;
  signal NLW_inst_locked_UNCONNECTED : STD_LOGIC;
begin
  locked <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
inst: entity work.SABER_ADC_8_bits_0_1_ADC_8_bits_clk_wiz_0_0_clk_wiz
     port map (
      clk_in1 => clk_in1,
      clk_out1 => clk_out1,
      locked => NLW_inst_locked_UNCONNECTED,
      reset => reset
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity SABER_ADC_8_bits_0_1_ADC_8_bits is
  port (
    V_N_i : in STD_LOGIC;
    V_P_i : in STD_LOGIC;
    clock_i : in STD_LOGIC;
    data_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
    reset_i : in STD_LOGIC
  );
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of SABER_ADC_8_bits_0_1_ADC_8_bits : entity is "ADC_8_bits.hwdef";
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of SABER_ADC_8_bits_0_1_ADC_8_bits : entity is "ADC_8_bits";
end SABER_ADC_8_bits_0_1_ADC_8_bits;

architecture STRUCTURE of SABER_ADC_8_bits_0_1_ADC_8_bits is
  signal clk_wiz_0_clk_out1 : STD_LOGIC;
  signal xadc_wiz_0_do_out : STD_LOGIC_VECTOR ( 15 downto 8 );
  signal NLW_clk_wiz_0_locked_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_alarm_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_busy_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_drdy_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_eoc_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_eos_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_vccaux_alarm_out_UNCONNECTED : STD_LOGIC;
  signal NLW_xadc_wiz_0_channel_out_UNCONNECTED : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal NLW_xadc_wiz_0_do_out_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of xlslice_0 : label is "ADC_8_bits_xlslice_0_0,xlslice_v1_0_4_xlslice,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of xlslice_0 : label is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of xlslice_0 : label is "xlslice_v1_0_4_xlslice,Vivado 2024.2";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clock_i : signal is "xilinx.com:signal:clock:1.0 CLK.CLOCK_I CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clock_i : signal is "XIL_INTERFACENAME CLK.CLOCK_I, CLK_DOMAIN ADC_8_bits_clk_in1_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0";
  attribute X_INTERFACE_INFO of reset_i : signal is "xilinx.com:signal:reset:1.0 RST.RESET_I RST";
  attribute X_INTERFACE_PARAMETER of reset_i : signal is "XIL_INTERFACENAME RST.RESET_I, INSERT_VIP 0, POLARITY ACTIVE_HIGH";
begin
clk_wiz_0: entity work.SABER_ADC_8_bits_0_1_ADC_8_bits_clk_wiz_0_0
     port map (
      clk_in1 => clock_i,
      clk_out1 => clk_wiz_0_clk_out1,
      locked => NLW_clk_wiz_0_locked_UNCONNECTED,
      reset => reset_i
    );
xadc_wiz_0: entity work.SABER_ADC_8_bits_0_1_ADC_8_bits_xadc_wiz_0_0
     port map (
      alarm_out => NLW_xadc_wiz_0_alarm_out_UNCONNECTED,
      busy_out => NLW_xadc_wiz_0_busy_out_UNCONNECTED,
      channel_out(4 downto 0) => NLW_xadc_wiz_0_channel_out_UNCONNECTED(4 downto 0),
      daddr_in(6 downto 0) => B"0010001",
      dclk_in => clk_wiz_0_clk_out1,
      den_in => '0',
      di_in(15 downto 0) => B"0000000000000000",
      do_out(15 downto 8) => xadc_wiz_0_do_out(15 downto 8),
      do_out(7 downto 0) => NLW_xadc_wiz_0_do_out_UNCONNECTED(7 downto 0),
      drdy_out => NLW_xadc_wiz_0_drdy_out_UNCONNECTED,
      dwe_in => '0',
      eoc_out => NLW_xadc_wiz_0_eoc_out_UNCONNECTED,
      eos_out => NLW_xadc_wiz_0_eos_out_UNCONNECTED,
      reset_in => reset_i,
      vauxn1 => V_N_i,
      vauxp1 => V_P_i,
      vccaux_alarm_out => NLW_xadc_wiz_0_vccaux_alarm_out_UNCONNECTED,
      vn_in => '0',
      vp_in => '0'
    );
xlslice_0: entity work.SABER_ADC_8_bits_0_1_ADC_8_bits_xlslice_0_0
     port map (
      Din(15 downto 8) => xadc_wiz_0_do_out(15 downto 8),
      Din(7 downto 0) => B"00000000",
      Dout(7 downto 0) => data_o(7 downto 0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity SABER_ADC_8_bits_0_1 is
  port (
    V_N_i : in STD_LOGIC;
    V_P_i : in STD_LOGIC;
    clock_i : in STD_LOGIC;
    data_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
    reset_i : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of SABER_ADC_8_bits_0_1 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of SABER_ADC_8_bits_0_1 : entity is "SABER_ADC_8_bits_0_1,ADC_8_bits,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of SABER_ADC_8_bits_0_1 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of SABER_ADC_8_bits_0_1 : entity is "IPI";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of SABER_ADC_8_bits_0_1 : entity is "ADC_8_bits,Vivado 2024.2";
end SABER_ADC_8_bits_0_1;

architecture STRUCTURE of SABER_ADC_8_bits_0_1 is
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of inst : label is "ADC_8_bits.hwdef";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clock_i : signal is "xilinx.com:signal:clock:1.0 CLK.CLOCK_I CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of clock_i : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clock_i : signal is "XIL_INTERFACENAME CLK.CLOCK_I, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN SABER_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of reset_i : signal is "xilinx.com:signal:reset:1.0 RST.RESET_I RST";
  attribute X_INTERFACE_MODE of reset_i : signal is "slave";
  attribute X_INTERFACE_PARAMETER of reset_i : signal is "XIL_INTERFACENAME RST.RESET_I, POLARITY ACTIVE_HIGH, INSERT_VIP 0";
begin
inst: entity work.SABER_ADC_8_bits_0_1_ADC_8_bits
     port map (
      V_N_i => V_N_i,
      V_P_i => V_P_i,
      clock_i => clock_i,
      data_o(7 downto 0) => data_o(7 downto 0),
      reset_i => reset_i
    );
end STRUCTURE;
