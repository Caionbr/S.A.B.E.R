// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------

`timescale 1 ps / 1 ps

(* BLOCK_STUB = "true" *)
module ADC_8_bits (
  data_o,
  reset_i,
  clock_i,
  VN_i,
  VP_i
);

  (* X_INTERFACE_IGNORE = "true" *)
  output [7:0]data_o;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_I RST" *)
  (* X_INTERFACE_MODE = "slave RST.RESET_I" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_I, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *)
  input reset_i;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLOCK_I CLK" *)
  (* X_INTERFACE_MODE = "slave CLK.CLOCK_I" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLOCK_I, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN ADC_8_bits_clk_in1_0, INSERT_VIP 0" *)
  input clock_i;
  (* X_INTERFACE_IGNORE = "true" *)
  input VN_i;
  (* X_INTERFACE_IGNORE = "true" *)
  input VP_i;

  // stub module has no contents

endmodule
