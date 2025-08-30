`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project:     S.A.B.E.R. - Secure AI-Based Encrypted ECG Rhythm-Monitoring
// Engineer:    Murilo MULLER
// File:        nonce_gen.sv
// Module:      nonce_gen
// Version:     v1.0
//
// Description:
//   128-bit nonce generator. A 128-bit counter (counter_128) increments when
//   enabled, and its value is scrambled by a combinational LFSR (lfsr_128) to
//   produce the output nonce.
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

module nonce_gen (
    input  logic         clock_i,
    input  logic         reset_i,
    input  logic         clear_i,
    input  logic         enable_i,       // generate new nonce when high
    output logic [127:0] nonce_o         // scrambled nonce output
);

    logic [127:0] counter_s;
    logic [127:0] lfsr_s;

    // 128-bit counter
    counter_128 counter_128_0 (
        .clk_i    (clock_i),
        .rst_i    (reset_i),
        .clr_i    (clear_i),
        .enable_i (enable_i),
        .count_o  (counter_s)
    );

    // Combinational LFSR "whitening"
    lfsr_128 lfsr_128_0 (
        .data_i (counter_s),
        .data_o (lfsr_s)
    );

    assign nonce_o = lfsr_s;

endmodule
