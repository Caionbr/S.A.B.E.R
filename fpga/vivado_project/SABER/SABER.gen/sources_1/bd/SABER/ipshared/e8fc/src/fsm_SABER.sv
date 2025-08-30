`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project:     S.A.B.E.R. - Secure AI-Based Encrypted ECG Rhythm-Monitoring
// Engineer:    Murilo MULLER
// File:        fsm_SABER.sv
// Module:      fsm_SABER
// Version:     v1.0
//
// Description:
//   Top-level orchestration FSM for the S.A.B.E.R. pipeline. It sequences:
//     - register/packer initialization,
//     - nonce generation,
//     - loading of input registers,
//     - kick-off of the ASCON driver (start),
//     - and Wi-Fi send phase.
//   A cycle counter generates a one-cycle pulse (add_o) every CLK_COUNTER_MAX
//   clock cycles (default 100e6/360 ≈ 277,778), used as a sampling/add-tick.
//
// Competition Context:
//   Developed as part of the AMD Open Hardware University Design Competition 2025.
//
// License: MIT License (see LICENSE file in the repository root for full text)
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

module fsm_SABER (
    // Clocks & reset
    input  logic         clock_i,
    input  logic         reset_i,

    // Control / handshakes
    input  logic         go_i,                  // external GO trigger
    input  logic         data_valid_i,          // ASCON packaging completed

    // Controls to sub-blocks
    output logic         add_o,                 // 1-cycle pulse each sample period
    output logic         init_registers_o,      // clears data/key/tag regs
    output logic         init_nonce_counter_o,  // resets nonce counter
    output logic         en_nonce_counter_o,    // enables nonce counter
    output logic         load_registers_o,      // loads input registers
    output logic         clear_cipher_reg_o,    // clears/flushes packer
    output logic         start_o,               // starts ASCON driver
    output logic         send_data_o            // triggers Wi-Fi send
   
);

  // ---------------------------------------------------------------------------
  // Parameters
  // ---------------------------------------------------------------------------
  // Default: 100e6 / 360 Hz ≈ 277,778
  parameter int CLK_COUNTER_MAX = 277_778;

  // Counter width derived from the period (avoids over-dimensioning).
  localparam int CNT_W = (CLK_COUNTER_MAX <= 1) ? 1 : $clog2(CLK_COUNTER_MAX);

  // ---------------------------------------------------------------------------
  // State type
  // ---------------------------------------------------------------------------
  typedef enum logic [3:0] {
    S_RESET,
    S_WAIT_GO,
    S_NONCE_GEN,
    S_LOAD_REGISTERS,
    S_START_DRIVE_ASCON,
    S_WAIT_ASCON_DONE,
    S_WIFI,
    S_WAIT_WIFI_DONE
  } state_t;

  // ---------------------------------------------------------------------------
  // Registers
  // ---------------------------------------------------------------------------
  state_t           state, next;
  logic [CNT_W-1:0] counter;

  // ---------------------------------------------------------------------------
  // FSM state register (asynchronous reset)
  // ---------------------------------------------------------------------------
  always_ff @(posedge clock_i or posedge reset_i) begin
    if (reset_i)
      state <= S_RESET;
    else
      state <= next;
  end

  // ---------------------------------------------------------------------------
  // Periodic counter
  // - Generates a 1-cycle pulse on add_o every CLK_COUNTER_MAX cycles.
  // - Resets in RESET/WAIT_GO.
  // ---------------------------------------------------------------------------
  always_ff @(posedge clock_i or posedge reset_i) begin
    if (reset_i) begin
      counter <= '0;
      add_o   <= 1'b0;
    end
    else if (state == S_RESET || state == S_WAIT_GO) begin
      counter <= '0;
      add_o   <= 1'b0;
    end
    else if (counter == CLK_COUNTER_MAX - 1) begin
      counter <= '0;
      add_o   <= 1'b1;   // one-cycle tick
    end
    else begin
      counter <= counter + 1'b1;
      add_o   <= 1'b0;
    end
  end

  // ---------------------------------------------------------------------------
  // Output logic (Moore-style: default-low, then per-state)
  // ---------------------------------------------------------------------------
  always_comb begin
    // defaults
    init_registers_o     = 1'b0;
    clear_cipher_reg_o   = 1'b0;
    init_nonce_counter_o = 1'b0;
    en_nonce_counter_o   = 1'b0;
    load_registers_o     = 1'b0;
    start_o              = 1'b0;
    send_data_o          = 1'b0;

    unique case (state)
      S_RESET: begin
        // Reset data path and nonce counter so that the next GO starts clean.
        init_registers_o     = 1'b1;
        init_nonce_counter_o = 1'b1;
      end

      S_NONCE_GEN: begin
        // Enable nonce counter to produce a fresh nonce for this session/frame.
        en_nonce_counter_o   = 1'b1;
      end

      S_LOAD_REGISTERS: begin
        // Load input registers (AD/PT/nonces as needed) and clear packer buffers.
        load_registers_o     = 1'b1;
        clear_cipher_reg_o   = 1'b1;
      end

      S_START_DRIVE_ASCON: begin
        // Fire the ASCON driver (separate FSM) to run the encryption sequence.
        start_o              = 1'b1;
      end

      S_WIFI: begin
        // Transmit the produced ciphertext/tag/metadata via Wi-Fi.
        send_data_o          = 1'b1;
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
      S_RESET:               next = S_WAIT_GO;

      S_WAIT_GO:             next = go_i                  ? S_NONCE_GEN          : S_WAIT_GO;
      S_NONCE_GEN:           next =                         S_LOAD_REGISTERS;
      S_LOAD_REGISTERS:      next =                         S_START_DRIVE_ASCON;
      S_START_DRIVE_ASCON:   next =                         S_WAIT_ASCON_DONE;

      S_WAIT_ASCON_DONE:     next = data_valid_i          ? S_WIFI               : S_WAIT_ASCON_DONE;
      S_WIFI:                next =                         S_WAIT_WIFI_DONE;
      S_WAIT_WIFI_DONE:      next =                         S_NONCE_GEN;

      default:               next =                         S_RESET;
    endcase
  end

endmodule : fsm_SABER
