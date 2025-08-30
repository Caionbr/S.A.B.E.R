`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project:     S.A.B.E.R. - Secure AI-Based Encrypted ECG Rhythm-Monitoring
// File:        ascon.sv
// Module:      ascon
// Version:     v1.0
//
// Authors:     Jean-Baptiste Rigaud, Olivier Potin
// Review:      Murilo MULLER
//
// Description:
//   Top-level ASCON-128 module. It wires the control FSM, the dual-phase round
//   counter, and the permutation/state datapath. Orchestrates initialization,
//   associated-data absorption, plaintext encryption, finalisation, and tag output.
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

// ASCON128 Module
import ascon_pack::*;  // type_state and related ASCON package definitions

module ascon (
    // Clock & reset
    input  logic         clock_i,
    input  logic         reset_i,

    // High-level controls
    input  logic         init_i,             // start initialization (IV, key, nonce)
    input  logic         associate_data_i,   // absorb associated data (AD)
    input  logic         finalisation_i,     // signal last-block/finalisation

    // Data & keys
    input  logic [ 63:0] data_i,             // AD or plaintext (per select inside Permutation)
    input  logic         data_valid_i,       // data_i is valid for absorption/encryption
    input  logic [127:0] key_i,              // 128-bit key
    input  logic [127:0] nonce_i,            // 128-bit nonce

    // Status & outputs
    output logic         end_associate_o,    // AD absorption completed
    output logic [ 63:0] cipher_o,           // 64-bit ciphertext block
    output logic         cipher_valid_o,     // ciphertext block valid
    output logic [127:0] tag_o,              // 128-bit authentication tag
    output logic         end_tag_o,          // tag generation completed
    output logic         end_initialisation_o, // initialization completed
    output logic         end_cipher_o        // one encryption block round completed
);

  // Internal signals declaration
  logic enable_round_s;             // enables round counter stepping
  logic init_round_p12_s;           // initialize counter for p^12 sequence
  logic init_round_p6_s;            // initialize counter for p^6 sequence
  logic [3:0] round_s;              // current round index
  logic selectData_s;               // selects AD/PT path inside permutation
  logic enable_state_register_s;    // enables state register update
  logic enable_tag_s;               // enables tag output register
  logic enable_cipher_s;            // enables ciphertext output register
  logic enable_xor_data_begin_s;    // XOR in AD/PT at begin of a phase
  logic enable_xor_key_begin_s;     // XOR in key at begin of finalisation
  logic enable_xor_key_end_s;       // XOR in key at end of initialization
  logic enable_xor_lsb_begin_s;     // XOR with LSB (domain separation) at AD end
  logic resetb_s;                   // active-low reset for internal IPs

  type_state permutation_input_s;   // initial state words X0..X4 for permutation

  assign resetb_s = ~reset_i;

  // ASCON FSM instance declaration
  fsm_moore U0 (
      .clock_i(clock_i),
      .resetb_i(resetb_s),
      .init_i(init_i),
      .data_valid_i(data_valid_i),
      .round_i(round_s),
      .associate_data_i(associate_data_i),
      .finalisation_i(finalisation_i),
      // round counter 
      .init_a_o(init_round_p12_s),
      .init_b_o(init_round_p6_s),
      .enable_round_o(enable_round_s),
      // enable input data
      .enable_data_o(selectData_s),
      // enable xor signals 
      .en_xor_lsb_begin_o(enable_xor_lsb_begin_s),
      .en_xor_data_begin_o(enable_xor_data_begin_s),
      .en_xor_key_begin_o(enable_xor_key_begin_s),
      .en_xor_key_end_o(enable_xor_key_end_s),
      // enable register signals
      .en_reg_state_o(enable_state_register_s),
      .en_cipher_o(enable_cipher_s),
      .en_tag_o(enable_tag_s),
      // outputs
      .cipher_valid_o(cipher_valid_o),
      .end_associate_o(end_associate_o),
      .end_tag_o(end_tag_o),
      .end_init_o(end_initialisation_o),
      .end_cipher_o(end_cipher_o)
  );

  // Round counter instanciation
  compteur_double_init U2 (
      .clock_i(clock_i),
      .resetb_i(resetb_s),
      .en_i(enable_round_s),
      .init_a_i(init_round_p12_s),
      .init_b_i(init_round_p6_s),
      .data_o(round_s)
  );

  // Initial state words (X0..X4) according to ASCON-128 spec:
  // X0 <- IV, X1..X2 <- key, X3..X4 <- nonce
  assign permutation_input_s[0] = 64'h80400c0600000000;  // X0 <- IV (ASCON-128)
  assign permutation_input_s[1] = key_i[127:64];         // X1 <- MSB Key
  assign permutation_input_s[2] = key_i[63:0];           // X2 <- LSB Key
  assign permutation_input_s[3] = nonce_i[127:64];       // X3 <- MSB Nonce
  assign permutation_input_s[4] = nonce_i[63:0];         // X4 <- LSB Nonce

  // Permutation instance
  Permutation U3 (
      .clock_i(clock_i),
      .resetb_i(resetb_s),
      .enable_i(enable_state_register_s),
      .select_i(selectData_s),
      .round_i(round_s),
      .state_i(permutation_input_s),
      .enable_begin_lsb_i(enable_xor_lsb_begin_s),   // XOR with LSB at end of AD (domain sep)
      .enable_begin_data_i(enable_xor_data_begin_s), // XOR AD or plaintext at phase begin
      .enable_begin_key_i(enable_xor_key_begin_s),   // XOR key at finalisation begin
      .data_i(data_i),
      .enable_end_key_i(enable_xor_key_end_s),       // XOR key at end of initialization
      .key_i(key_i),
      .enable_tag_i(enable_tag_s),
      .tag_o(tag_o),
      .enable_cipher_i(enable_cipher_s),
      .cipher_o(cipher_o)
  );

endmodule
