`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Project:     S.A.B.E.R. - Secure AI-Based Encrypted ECG Rhythm-Monitoring
// Engineer:    Murilo MULLER
// File:        data_reg.sv
// Module:      data_reg
// Version:     v1.2
//
// Description:
//   Sliding byte-wise input register that emits 64-bit plaintext words every
//   8 received bytes. After the 181st byte (index 0..180), it emits a final
//   64-bit word composed of the last 5 bytes plus padding 0x80_00_00.
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

module data_reg (
    input  logic        clock_i,
    input  logic        reset_i,       // asynchronous reset
    input  logic        clear_i,       // asynchronous clear
    input  logic        add_i,         // strobe to accept a new byte
    input  logic [7:0]  data_i,        // incoming byte

    output logic        data_reg_valid_o, // 1-cycle pulse when plain_text_o is valid
    output logic [63:0] plain_text_o      // emitted 64-bit word
);
    // ===== Parameters =====
    localparam int TOTAL_BITS = 8*8; // 64 bits (8-byte sliding window)

    // ===== Internal registers =====
    logic [TOTAL_BITS-1:0] sh_s;      // shift register (LSB holds newest byte)
    logic [2:0]            count_s;   // counts 0..7 to form 64-bit words
    logic [7:0]            total_cnt; // counts 0..180 (181 bytes total)

    // Next shift value (combinational)
    logic [TOTAL_BITS-1:0] sh_next;
    always_comb begin
        // Precompute next shift (new byte enters at LSB)
        sh_next = { sh_s[TOTAL_BITS-9:0], data_i };
    end

    // ===== Asynchronous reset/clear & operation =====
    always_ff @(posedge clock_i or posedge reset_i or posedge clear_i) begin
        if (reset_i || clear_i) begin
            sh_s              <= '0;
            count_s           <= 3'd0;
            data_reg_valid_o  <= 1'b0;
            plain_text_o      <= '0;
            total_cnt         <= 8'd0;

        end else begin
            // defaults
            data_reg_valid_o <= 1'b0;

            if (add_i) begin
                // Shift by one byte (use combinational sh_next)
                sh_s <= sh_next;

                // ===== Reached the 181st byte? (index 0..180) =====
                if (total_cnt == 8'd180) begin
                    // Emit final block with padding:
                    // last 5 bytes from sh_next[39:0] + 0x80 00 00
                    plain_text_o     <= {
                        sh_next[39:32], // oldest of the 5
                        sh_next[31:24],
                        sh_next[23:16],
                        sh_next[15:8],
                        sh_next[7:0],   // newest of the 5
                        8'h80, 8'h00, 8'h00
                    };
                    data_reg_valid_o <= 1'b1;

                    // Restart counters (continuous window: sh_s is preserved)
                    count_s   <= 3'd0;
                    total_cnt <= 8'd0;

                end else begin
                    // Normal path (not yet at 181 bytes)
                    total_cnt <= total_cnt + 8'd1;

                    if (count_s == 3'd7) begin
                        // Every 8 bytes, emit the 64 LSBs
                        count_s          <= 3'd0;
                        data_reg_valid_o <= 1'b1;
                        plain_text_o     <= sh_next[63:0];
                    end else begin
                        count_s <= count_s + 3'd1;
                    end
                end
            end
        end
    end
endmodule
