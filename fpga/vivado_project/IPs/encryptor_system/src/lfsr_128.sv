`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project:     S.A.B.E.R. - Secure AI-Based Encrypted ECG Rhythm-Monitoring
// Engineer:    Murilo MULLER
// File:        lfsr_128.sv
// Module:      lfsr_128
// Version:     v1.0
//
// Description:
//   Combinational scrambling using a 128-step LFSR-like transformation.
//   For each step, feedback is computed from taps [127, 126, 121, 120] and
//   shifted into the LSB. After 128 iterations, data_o is produced.
//
// Notes:
//   - This is a combinational "whitening" pass over data_i; it is *not* a
//     clocked LFSR state machine.
//   - Taps as provided (example polynomial); logic unchanged.
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

module lfsr_128 (
    input  logic [127:0] data_i,
    output logic [127:0] data_o
);
    logic [127:0] out;
    logic         feedback;

    always_comb begin
        out = data_i;
        for (int i = 0; i < 128; i++) begin
            // Example taps: [127, 126, 121, 120] (primitive polynomial candidate)
            feedback = out[127] ^ out[126] ^ out[121] ^ out[120];
            out = {out[126:0], feedback};
        end
        data_o = out;
    end

endmodule
