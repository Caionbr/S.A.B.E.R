-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
-- Date        : Thu Aug 21 20:50:32 2025
-- Host        : LAPTOP-TDIUQR79 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ SABER_encryptor_system_0_1_stub.vhdl
-- Design      : SABER_encryptor_system_0_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    go_i : in STD_LOGIC;
    data_i : in STD_LOGIC_VECTOR ( 7 downto 0 );
    reset_i : in STD_LOGIC;
    clock_i : in STD_LOGIC;
    add_o : out STD_LOGIC;
    data_o : out STD_LOGIC_VECTOR ( 1791 downto 0 );
    data_valid_o : out STD_LOGIC;
    send_data_o : out STD_LOGIC
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "SABER_encryptor_system_0_1,encryptor_system,{}";
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "SABER_encryptor_system_0_1,encryptor_system,{x_ipProduct=Vivado 2024.2,x_ipVendor=xilinx.com,x_ipLibrary=user,x_ipName=encryptor_system,x_ipVersion=2.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "package_project";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "go_i,data_i[7:0],reset_i,clock_i,add_o,data_o[1791:0],data_valid_o,send_data_o";
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of reset_i : signal is "xilinx.com:signal:reset:1.0 reset_i RST";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of reset_i : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of reset_i : signal is "XIL_INTERFACENAME reset_i, POLARITY ACTIVE_HIGH, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of clock_i : signal is "xilinx.com:signal:clock:1.0 clock_i CLK";
  attribute X_INTERFACE_MODE of clock_i : signal is "slave";
  attribute X_INTERFACE_PARAMETER of clock_i : signal is "XIL_INTERFACENAME clock_i, ASSOCIATED_RESET reset_i, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0, ASSOCIATED_BUSIF frame_if, FREQ_TOLERANCE_HZ 0, CLK_DOMAIN SABER_processing_system7_0_0_FCLK_CLK0";
  attribute X_INTERFACE_INFO of data_o : signal is "xilinx.com:signal:data:1.0 frame_if DATA";
  attribute X_INTERFACE_MODE of data_o : signal is "master";
  attribute X_INTERFACE_PARAMETER of data_o : signal is "XIL_INTERFACENAME frame_if, LAYERED_METADATA undef";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of stub : architecture is "encryptor_system,Vivado 2024.2";
begin
end;
