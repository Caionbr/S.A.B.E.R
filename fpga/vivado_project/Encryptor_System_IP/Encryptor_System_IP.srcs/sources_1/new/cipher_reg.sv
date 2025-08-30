`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project:     S.A.B.E.R. - Secure AI-Based Encrypted ECG Rhythm-Monitoring
// Engineer:    Murilo MULLER
// File:        reg1792_packer.sv
// Module:      reg1792_packer
// Version:     v1.0
//
// Description:
//   Packs 23 ciphertext blocks (23 × 64b), then TAG (128b), AD (64b), and NONCE
//   (128b) into 56 words of 32 bits (total 1792 bits) for an AXI-mapped register.
//   Emits a 1-cycle pulse (data_valid_o) when the full 1792-bit frame is ready,
//   then latches (ignores further writes) until cleared.
//
// Layout (words[0] is least significant 32 bits of data_o):
//   - CIPHER[0..22]  -> words[0..45]   (2 words per 64b block, LSW first)
//   - TAG            -> words[46..49]
//   - AD             -> words[50..51]
//   - NONCE          -> words[52..55]
//
// Competition Context:
//   Developed as part of the AMD Open Hardware University Design Competition 2025.
//
// License: MIT License
// -----------------------------------------------------------------------------
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// - The above copyright notice and this permission notice shall be included
//   in all copies or substantial portions of the Software.
// - This work was originally produced for the AMD Open Hardware Competition 2025.
// - THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
//   Authors are not liable for any claim, damages or other liability.
// -----------------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////

module cipher_reg (
  input  logic          clock_i,
  input  logic          reset_i,         // asynchronous, active-high
  input  logic          clear_i,         // asynchronous clear (pulse/level)

  // Input data enables & buses
  input  logic          en_cipher_i,
  input  logic [63:0]   cipher_i,

  input  logic          en_tag_i,
  input  logic [127:0]  tag_i,

  input  logic          en_ad_i,
  input  logic [63:0]   ad_i,

  input  logic          en_nonce_i,
  input  logic [127:0]  nonce_i,

  // Handshake with AXI / external control
  output logic          data_valid_o,    // 1-cycle pulse when full frame ready
  output logic [1791:0] data_o           // 56 × 32b flattened
);

  // 56 × 32-bit bank
  logic [31:0] words [0:55];

  // Fill-state
  logic [4:0]  cipher_cnt;               // 0..23 (23 blocks)
  logic        tag_done, ad_done, nonce_done;

  // Full latch and its delayed version (for pulse generation)
  logic full_r, full_r_d;

  // Completion condition
  wire all_cipher = (cipher_cnt == 5'd23);
  wire done_all   = all_cipher & tag_done & ad_done & nonce_done;

  // Control logic: fill → latch when full_r=1 → only unlock with clear
  integer k;
  always_ff @(posedge clock_i or posedge reset_i or posedge clear_i) begin
    if (reset_i || clear_i) begin
      // reset/clear: wipe bank and state
      for (k = 0; k < 56; k++) words[k] <= '0;
      cipher_cnt <= '0;
      tag_done   <= 1'b0;
      ad_done    <= 1'b0;
      nonce_done <= 1'b0;
      full_r     <= 1'b0;
      full_r_d   <= 1'b0;
    end else begin
      // remember previous full_r (to create a 0->1 edge pulse)
      full_r_d <= full_r;

      // If not latched as full, accept writes
      if (!full_r) begin
        // 23 × CIPHER 64b -> words[0..45] (2 words per block, LSW first)
        if (en_cipher_i && (cipher_cnt < 5'd23)) begin
          words[2*cipher_cnt]     <= cipher_i[31:0];
          words[2*cipher_cnt + 1] <= cipher_i[63:32];
          cipher_cnt <= cipher_cnt + 5'd1;
        end

        // TAG 128b -> words[46..49]
        if (en_tag_i && !tag_done) begin
          words[46] <= tag_i[31:0];
          words[47] <= tag_i[63:32];
          words[48] <= tag_i[95:64];
          words[49] <= tag_i[127:96];
          tag_done  <= 1'b1;
        end

        // AD 64b -> words[50..51]
        if (en_ad_i && !ad_done) begin
          words[50] <= ad_i[31:0];
          words[51] <= ad_i[63:32];
          ad_done   <= 1'b1;
        end

        // NONCE 128b -> words[52..55]
        if (en_nonce_i && !nonce_done) begin
          words[52] <= nonce_i[31:0];
          words[53] <= nonce_i[63:32];
          words[54] <= nonce_i[95:64];
          words[55] <= nonce_i[127:96];
          nonce_done<= 1'b1;
        end

        // When everything is complete, latch as full
        if (done_all) begin
          full_r <= 1'b1;
        end
      end
      // else: latched - ignore en_* until clear_i
    end
  end

  // 1-cycle pulse when full_r rises (0->1)
  assign data_valid_o = full_r & ~full_r_d;

  // Flatten the 56 words into the 1792-bit bus (words[0] -> bits [31:0])
  always_comb begin
    data_o = '0;
    for (int i = 0; i < 56; i++) begin
      data_o[i*32 +: 32] = words[i];
    end
  end

endmodule
