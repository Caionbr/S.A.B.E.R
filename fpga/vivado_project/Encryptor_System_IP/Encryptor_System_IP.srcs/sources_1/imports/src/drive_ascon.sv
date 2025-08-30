`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project:     S.A.B.E.R. - Secure AI-Based Encrypted ECG Rhythm-Monitoring
// Engineer:    Murilo MULLER
// File:        drive_ascon.sv
// Module:      drive_ascon
// Version:     v2
//
// Description: Finite State Machine (FSM) controlling the ASCON encryption flow
//              for multiple 64-bit plaintext blocks. Developed as part of the
//              AMD Open Hardware University Design Competition 2025.
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


module drive_ascon #(
  parameter int TOTAL_BLOCKS = 23   // number of 8-byte plaintext blocks
)(
  // External signals
  input  logic         clock_i,
  input  logic         reset_i,
  input  logic         start_i,

  // Handshakes coming from the "ascon" core
  input  logic         end_initialisation_i,
  input  logic         end_associate_i,
  input  logic         data_reg_valid_i,   // data register (AD/PT) is ready for the core
  input  logic         cipher_valid_i,     // a ciphertext block is ready
  input  logic         end_cipher_i,
  input  logic         end_tag_i,

  // Control signals to the "ascon" core
  output logic         init_ascon_o,
  output logic         associate_data_o,
  output logic         data_valid_o,
  output logic         sel_data_reg_o,     // 0 = AD, 1 = plaintext
  output logic         finalisation_o,
  
  // Enables to the "cipher_reg" (external register bank)
  output logic         en_cipher_reg_o,
  output logic         en_tag_cipher_reg_o,
  output logic         en_ad_cipher_reg_o,
  output logic         en_nonce_cipher_reg_o
);

  // ---------------------------------------------------------------------------
  // Types & internal signals
  // ---------------------------------------------------------------------------

  typedef enum logic [4:0] {
    S_RESET,
    S_WAIT_START,
    S_START,
    S_WAIT_INIT_DONE,
    S_AD,
    S_WAIT_AD_DONE,
    S_WAIT_DATA_READY,
    S_ENCRYPT,
    S_WAIT_CIPHER_DONE,
    S_STORE_CIPHER,
    S_ANALISE,                // decision point after storing a block
    S_WAIT_LAST_DATA_READY,
    S_FINALISE,               // signal finalisation for last block
    S_WAIT_TAG,
    S_STORE_TAG,
    S_STORE_AD,
    S_STORE_NONCE,
    S_DONE
  } state_t;

  state_t state, next;

  // Derive counter width from TOTAL_BLOCKS (avoids over/under-dimensioning).
  localparam int CNT_W = (TOTAL_BLOCKS < 2) ? 1 : $clog2(TOTAL_BLOCKS + 1);
  logic [CNT_W-1:0] counter;  // counts stored ciphertext blocks

  // ---------------------------------------------------------------------------
  // State register (asynchronous reset)
  // ---------------------------------------------------------------------------
  always_ff @(posedge clock_i or posedge reset_i) begin
    if (reset_i)
      state <= S_RESET;  // asynchronous reset
    else
      state <= next;
  end

  // ---------------------------------------------------------------------------
  // Block counter
  // - Counts how many ciphertext blocks have been stored into the output reg
  // - Resets when returning to idle/wait-for-start
  // ---------------------------------------------------------------------------
  always_ff @(posedge clock_i or posedge reset_i) begin
    if (reset_i) begin
      counter <= '0;
    end
    else if (state == S_WAIT_START || state == S_RESET) begin
      counter <= '0;
    end
    else if (state == S_STORE_CIPHER) begin
      counter <= counter + 1'b1;
    end
  end

  // ---------------------------------------------------------------------------
  // Output combinational logic (Moore-style: default-low, then per-state)
  // ---------------------------------------------------------------------------
  always_comb begin
    // Defaults (deassert everything every cycle)
    init_ascon_o          = 1'b0;
    associate_data_o      = 1'b0;
    data_valid_o          = 1'b0;
    sel_data_reg_o        = 1'b0; // default to AD unless explicitly selecting plaintext
    en_cipher_reg_o       = 1'b0;
    finalisation_o        = 1'b0;
    en_tag_cipher_reg_o   = 1'b0;
    en_ad_cipher_reg_o    = 1'b0;
    en_nonce_cipher_reg_o = 1'b0;

    unique case (state)
      S_START: begin
        // Kick off ASCON initialization (key, nonce, IV, etc.)
        init_ascon_o = 1'b1;
      end

      S_AD: begin
        // Provide associated data (AD) to the core
        associate_data_o = 1'b1;
        data_valid_o     = 1'b1;
      end

      S_WAIT_DATA_READY: begin
        // Prepare to feed plaintext (select PT path while waiting for data_reg_valid_i)
        sel_data_reg_o = 1'b1;
      end

      S_ENCRYPT: begin
        // Assert data_valid with plaintext selected; ASCON consumes a block
        data_valid_o   = 1'b1;
        sel_data_reg_o = 1'b1;
      end

      S_WAIT_CIPHER_DONE: begin
        // Keep plaintext selected while waiting for cipher_valid_i
        sel_data_reg_o = 1'b1;
      end

      S_STORE_CIPHER: begin
        // Latch produced ciphertext block
        en_cipher_reg_o = 1'b1;
        sel_data_reg_o  = 1'b1;
      end

      S_ANALISE: begin
        // Decision state (next-state logic decides whether to continue or finalize)
        sel_data_reg_o = 1'b1;
      end

      S_WAIT_LAST_DATA_READY: begin
        // Wait for data_reg_valid before issuing finalisation on the last block
        sel_data_reg_o = 1'b1;
      end

      S_FINALISE: begin
        // Final block: assert finalisation together with data_valid (plaintext selected)
        finalisation_o  = 1'b1;
        data_valid_o    = 1'b1;
        sel_data_reg_o  = 1'b1;
      end

      S_WAIT_TAG: begin
        // Wait for authentication tag to be ready
        sel_data_reg_o = 1'b1;
      end

      S_STORE_TAG: begin
        // Latch tag
        en_tag_cipher_reg_o = 1'b1;
        sel_data_reg_o      = 1'b1;
      end

      S_STORE_AD: begin
        // Store AD (
        en_ad_cipher_reg_o = 1'b1;
        sel_data_reg_o     = 1'b1;
      end

      S_STORE_NONCE: begin
        // Store nonce 
        en_nonce_cipher_reg_o = 1'b1;
        sel_data_reg_o        = 1'b1;
      end

      default: /* keep defaults */;
    endcase
  end

  // ---------------------------------------------------------------------------
  // Next-state logic
  // ---------------------------------------------------------------------------
  always_comb begin
    next = state;

    unique case (state)
      S_RESET:             next = S_WAIT_START;

      S_WAIT_START:        next = start_i               ? S_START            : S_WAIT_START;
      S_START:             next =                        S_WAIT_INIT_DONE;
      S_WAIT_INIT_DONE:    next = end_initialisation_i  ? S_AD               : S_WAIT_INIT_DONE;

      S_AD:                next =                        S_WAIT_AD_DONE;
      S_WAIT_AD_DONE:      next = end_associate_i       ? S_WAIT_DATA_READY  : S_WAIT_AD_DONE;

      S_WAIT_DATA_READY:   next = data_reg_valid_i      ? S_ENCRYPT          : S_WAIT_DATA_READY;
      S_ENCRYPT:           next =                        S_WAIT_CIPHER_DONE;
      S_WAIT_CIPHER_DONE:  next = cipher_valid_i        ? S_STORE_CIPHER     : S_WAIT_CIPHER_DONE;

      S_STORE_CIPHER:      next =                        S_ANALISE;

      S_ANALISE: begin
        // After storing a block:
        //  - If more blocks remain and the core signaled end_cipher_i, get next data.
        //  - If this was the last block and end_cipher_i, prep finalisation path.
        //  - If we've already passed the expected count, proceed to tag.
        if (counter < (TOTAL_BLOCKS - 1) && end_cipher_i)       next = S_WAIT_DATA_READY;
        else if (counter == (TOTAL_BLOCKS - 1) && end_cipher_i) next = S_WAIT_LAST_DATA_READY;
        else if (counter >= TOTAL_BLOCKS)                       next = S_WAIT_TAG;
        else                                                    next = S_ANALISE;
      end

      S_WAIT_LAST_DATA_READY: next = data_reg_valid_i   ? S_FINALISE         : S_WAIT_LAST_DATA_READY;
      S_FINALISE:             next =                      S_WAIT_CIPHER_DONE;

      S_WAIT_TAG:             next = end_tag_i          ? S_STORE_TAG        : S_WAIT_TAG;
      S_STORE_TAG:            next =                      S_STORE_AD;
      S_STORE_AD:             next =                      S_STORE_NONCE;
      S_STORE_NONCE:          next =                      S_DONE;
      S_DONE:                 next =                      S_WAIT_START;

      default:                next =                      S_RESET;
    endcase
  end

endmodule : drive_ascon
