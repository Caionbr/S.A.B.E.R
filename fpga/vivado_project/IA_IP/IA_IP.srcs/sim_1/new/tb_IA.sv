`timescale 1ns/1ps

module tb_IA;

  // ---------------- clock & reset ----------------
  logic clk = 0;
  logic rst = 1;
  always #5 clk = ~clk;      // 100 MHz

  // DUT I/Os (wrapper)
  logic        data_valid_i_0;
  logic [1447:0] data_i_0;       // 181*8 bits
  wire         out_valid_o_0;
  wire [1023:0] y_o_0;           // 64*16 bits (Q2.14)

  // --------- DUT: seu BD wrapper ----------
  IA_wrapper dut (
    .clock_i_0      (clk),
    .reset_i_0      (rst),
    .data_valid_i_0 (data_valid_i_0),
    .data_i_0       (data_i_0),
    .out_valid_o_0  (out_valid_o_0),
    .y_o_0          (y_o_0)
  );

  // ---------------- vetor de entrada (181 bytes) ----------------
  byte xi [0:180] = '{
    8'h5A,8'h5A,8'h5B,8'h5B,8'h5B,8'h5B,8'h5D,8'h5D,8'h5C,8'h59,
    8'h56,8'h52,8'h50,8'h4F,8'h4D,8'h4A,8'h47,8'h43,8'h43,8'h45,
    8'h45,8'h44,8'h43,8'h43,8'h44,8'h43,8'h45,8'h44,8'h44,8'h42,
    8'h44,8'h44,8'h46,8'h44,8'h44,8'h43,8'h43,8'h44,8'h45,8'h44,
    8'h42,8'h42,8'h42,8'h43,8'h44,8'h44,8'h45,8'h43,8'h44,8'h45,
    8'h45,8'h45,8'h44,8'h44,8'h45,8'h46,8'h47,8'h47,8'h47,8'h46,
    8'h48,8'h49,8'h4A,8'h4A,8'h48,8'h47,8'h47,8'h47,8'h46,8'h44,
    8'h40,8'h3F,8'h3F,8'h42,8'h4A,8'h55,8'h62,8'h70,8'h7F,8'h8C,
    8'h96,8'hA0,8'hAD,8'hBC,8'hCC,8'hDC,8'hEB,8'hF5,8'hFC,8'hFF,
    8'hFE,8'hFF,8'hF9,8'hED,8'hD9,8'hC4,8'hB3,8'hA4,8'h94,8'h82,
    8'h6E,8'h54,8'h40,8'h30,8'h22,8'h16,8'h09,8'h01,8'h00,8'h00,
    8'h00,8'h01,8'h00,8'h01,8'h02,8'h03,8'h05,8'h08,8'h0D,8'h10,
    8'h13,8'h16,8'h1A,8'h1D,8'h1E,8'h20,8'h23,8'h27,8'h29,8'h2C,
    8'h2C,8'h2B,8'h2C,8'h2C,8'h2D,8'h2E,8'h2C,8'h2C,8'h2A,8'h2B,
    8'h2A,8'h2A,8'h29,8'h29,8'h27,8'h27,8'h28,8'h28,8'h26,8'h27,
    8'h25,8'h26,8'h27,8'h27,8'h27,8'h26,8'h25,8'h25,8'h25,8'h27,
    8'h27,8'h26,8'h26,8'h27,8'h28,8'h29,8'h29,8'h28,8'h29,8'h2A,
    8'h2B,8'h2C,8'h2B,8'h2C,8'h2B,8'h2C,8'h2F,8'h31,8'h31,8'h31,
    8'h32
  };

  // ---------------- estímulo ----------------
  initial begin
    data_valid_i_0 = 1'b0;
    data_i_0       = '0;

    // reset por alguns ciclos
    repeat (6) @(posedge clk);
    rst <= 1'b0;
    @(posedge clk);

    // empacotamento = mesmo do TB da pré-camada
    for (int i=0; i<181; i++) begin
      data_i_0[i*8 +: 8] = xi[i];
    end

    // 1 pulso de valid
    data_valid_i_0 <= 1'b1;
    @(posedge clk);
    data_valid_i_0 <= 1'b0;

    // espera saída da pipeline
    wait (out_valid_o_0 === 1'b1);
    $display("[%0t] out_valid_o=1", $time);

    // imprime alguns dos 64 resultados (cada 16 bits Q2.14 signed)
    for (int k=0; k<8; k++) begin
      logic signed [15:0] yk;
      yk = y_o_0[16*k +: 16];
      $display("y[%0d] = 0x%h  (dec %0d)", k, yk, yk);
    end

    repeat (5) @(posedge clk);
    $finish;
  end

endmodule
