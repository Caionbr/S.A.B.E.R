// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------

`timescale 1 ps / 1 ps

(* BLOCK_STUB = "true" *)
module IA (
  clock_i_0,
  reset_i_0,
  data_valid_i_0,
  data_i_0,
  out_valid_o_0,
  y_o_0
);

  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLOCK_I_0 CLK" *)
  (* X_INTERFACE_MODE = "slave CLK.CLOCK_I_0" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLOCK_I_0, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN IA_clock_i_0, ASSOCIATED_RESET reset_i_0, INSERT_VIP 0" *)
  input clock_i_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_I_0 RST" *)
  (* X_INTERFACE_MODE = "slave RST.RESET_I_0" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_I_0, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
  input reset_i_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input data_valid_i_0;
  (* X_INTERFACE_IGNORE = "true" *)
  input [1447:0]data_i_0;
  (* X_INTERFACE_IGNORE = "true" *)
  output out_valid_o_0;
  (* X_INTERFACE_IGNORE = "true" *)
  output [1023:0]y_o_0;

  // stub module has no contents

endmodule
