`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project:     S.A.B.E.R. - Secure AI-Based Encrypted ECG Rhythm-Monitoring
// Engineer:    Murilo MULLER
// File:        counter_128.sv
// Module:      counter_128
// Version:     v1.1
//
// Description:
//   128-bit up-counter with asynchronous reset/clear and synchronous enable.
//   Resets to zero on rst_i/ clr_i; increments by 1 when enable_i is high.
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

module counter_128 (
    input  logic         clk_i,
    input  logic         rst_i,     // asynchronous reset
    input  logic         clr_i,     // asynchronous clear
    input  logic         enable_i,  // sync enable
    output logic [127:0] count_o
);

    logic [127:0] counter;

    // Asynchronous reset/clear, synchronous increment
    always_ff @(posedge clk_i or posedge rst_i or posedge clr_i) begin
        if (rst_i || clr_i) begin
            counter <= 128'd0;
        end else if (enable_i) begin
            counter <= counter + 128'd1;
        end
    end

    assign count_o = counter;

endmodule
