`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project:     S.A.B.E.R. - Secure AI-Based Encrypted ECG Rhythm-Monitoring
// Engineer:    Murilo MULLER
// File:        ad_reg.sv
// Module:      ad_reg
// Version:     v1.0
//
// Description:
//   64-bit register for Associated Data (AD).
//   - Asynchronous reset/clear to zero.
//   - Synchronous load when load_i is asserted.
//   - Output reflects the stored 64-bit AD word.
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

module ad_reg (
    input  logic        clock_i,
    input  logic        reset_i,    // asynchronous reset
    input  logic        clear_i,    // asynchronous clear
    input  logic        load_i,     // sync load enable
    input  logic [63:0] data_i,     // AD data in
    output logic [63:0] data_o      // AD data out
);

    // Asynchronous reset/clear, synchronous load
    always_ff @(posedge clock_i or posedge reset_i or posedge clear_i) begin
        if (reset_i || clear_i) begin
            data_o <= 64'd0;
        end else if (load_i) begin
            data_o <= data_i;
        end
    end

endmodule
