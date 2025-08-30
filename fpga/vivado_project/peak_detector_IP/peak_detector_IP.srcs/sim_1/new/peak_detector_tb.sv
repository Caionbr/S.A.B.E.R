`timescale 1ns/1ps

module tb_peak_detector;

  logic         clock_i;
  logic         reset_i;
  logic         add_i;
  logic [7:0]   data_i;

  logic         peak_valid_o;
  logic [7:0]   frame_o [0:180];
  logic         frame_valid_o;

  // Clock 100 MHz (10 ns)
  initial clock_i = 1'b0;
  always #5 clock_i = ~clock_i;

 
  // Amostras (181 bytes)
localparam int N = 362;
byte unsigned samples [0:N-1] = '{
    8'h07, 8'h11, 8'h5B, 8'h5A, 8'h5A, 8'h5A, 8'h5A, 8'h5A, 8'h59, 8'h55, 
    8'h4E, 8'h4A, 8'h4C, 8'h4F, 8'h54, 8'h55, 8'h53, 8'h51, 8'h53, 8'h54, 
    8'h56, 8'h57, 8'h58, 8'h57, 8'h5A, 8'h5A, 8'h59, 8'h57, 8'h56, 8'h59, 
    8'h5B, 8'h5A, 8'h55, 8'h54, 8'h54, 8'h52, 8'h52, 8'h50, 8'h4F, 8'h4F, 
    8'h4C, 8'h4C, 8'h4D, 8'h4D, 8'h4A, 8'h49, 8'h44, 8'h44, 8'h47, 8'h47, 
    8'h46, 8'h44, 8'h42, 8'h43, 8'h41, 8'h40, 8'h3B, 8'h36, 8'h38, 8'h3E, 
    8'h44, 8'h49, 8'h49, 8'h47, 8'h47, 8'h46, 8'h46, 8'h44, 8'h43, 8'h42, 
    8'h43, 8'h45, 8'h47, 8'h45, 8'h44, 8'h45, 8'h46, 8'h47, 8'h4A, 8'h49,
    8'h47, 8'h45, 8'h48, 8'h4F, 8'h58, 8'h69, 8'h7C, 8'hE1, 8'hF1, 8'hFB, 
    8'hFF, 
    8'hFB, 8'hF1, 8'hE1, 8'hB4, 8'h7C, 8'h47, 8'h16, 8'h00, 8'h04, 8'h17, 
    8'h29, 8'h36, 8'h3C, 8'h3F, 8'h3E, 8'h40, 8'h41, 8'h41, 8'h41, 8'h40, 
    8'h3F, 8'h3F, 8'h40, 8'h3F, 8'h3E, 8'h3B, 8'h3A, 8'h3B, 8'h3E, 8'h3D, 
    8'h3E, 8'h3C, 8'h39, 8'h3C, 8'h41, 8'h46, 8'h46, 8'h46, 8'h45, 8'h44, 
    8'h47, 8'h46, 8'h4A, 8'h4C, 8'h4F, 8'h4C, 8'h50, 8'h55, 8'h55, 8'h52, 
    8'h4F, 8'h51, 8'h55, 8'h59, 8'h5C, 8'h5A, 8'h59, 8'h5A, 8'h5C, 8'h5C, 
    8'h5B, 8'h59, 8'h59, 8'h57, 8'h53, 8'h51, 8'h50, 8'h4F, 8'h4F, 8'h53, 
    8'h57, 8'h5A, 8'h5C, 8'h5A, 8'h5B, 8'h5D, 8'h5E, 8'h60, 8'h60, 8'h61, 
    8'h5F, 8'h60, 8'h5F, 8'h5E, 8'h5A, 8'h58, 8'h57, 8'h54, 8'h07, 8'h11,
    
    8'h06, 8'h11, 8'h5B, 8'h5A, 8'h5A, 8'h5A, 8'h5A, 8'h5A, 8'h59, 8'h55, 
    8'h4E, 8'h4A, 8'h4C, 8'h4F, 8'h54, 8'h55, 8'h53, 8'h51, 8'h53, 8'h54, 
    8'h56, 8'h57, 8'h58, 8'h57, 8'h5A, 8'h5A, 8'h59, 8'h57, 8'h56, 8'h59, 
    8'h5B, 8'h5A, 8'h55, 8'h54, 8'h54, 8'h52, 8'h52, 8'h50, 8'h4F, 8'h4F, 
    8'h4C, 8'h4C, 8'h4D, 8'h4D, 8'h4A, 8'h49, 8'h44, 8'h44, 8'h47, 8'h47, 
    8'h46, 8'h44, 8'h42, 8'h43, 8'h41, 8'h40, 8'h3B, 8'h36, 8'h38, 8'h3E, 
    8'h44, 8'h49, 8'h49, 8'h47, 8'h47, 8'h46, 8'h46, 8'h44, 8'h43, 8'h42, 
    8'h43, 8'h45, 8'h47, 8'h45, 8'h44, 8'h45, 8'h46, 8'h47, 8'h4A, 8'h49,
    8'h47, 8'h45, 8'h48, 8'h4F, 8'h58, 8'h69, 8'h7C, 8'hE1, 8'hF1, 8'hFB, 
    8'hFF, 
    8'hFB, 8'hF1, 8'hE1, 8'hB4, 8'h7C, 8'h47, 8'h16, 8'h00, 8'h04, 8'h17, 
    8'h29, 8'h36, 8'h3C, 8'h3F, 8'h3E, 8'h40, 8'h41, 8'h41, 8'h41, 8'h40, 
    8'h3F, 8'h3F, 8'h40, 8'h3F, 8'h3E, 8'h3B, 8'h3A, 8'h3B, 8'h3E, 8'h3D, 
    8'h3E, 8'h3C, 8'h39, 8'h3C, 8'h41, 8'h46, 8'h46, 8'h46, 8'h45, 8'h44, 
    8'h47, 8'h46, 8'h4A, 8'h4C, 8'h4F, 8'h4C, 8'h50, 8'h55, 8'h55, 8'h52, 
    8'h4F, 8'h51, 8'h55, 8'h59, 8'h5C, 8'h5A, 8'h59, 8'h5A, 8'h5C, 8'h5C, 
    8'h5B, 8'h59, 8'h59, 8'h57, 8'h53, 8'h51, 8'h50, 8'h4F, 8'h4F, 8'h53, 
    8'h57, 8'h5A, 8'h5C, 8'h5A, 8'h5B, 8'h5D, 8'h5E, 8'h60, 8'h60, 8'h61, 
    8'h5F, 8'h60, 8'h5F, 8'h5E, 8'h5A, 8'h58, 8'h57, 8'h54, 8'h07, 8'h11
};


  // Estímulo simples (sem task/VCD)
  initial begin
    // reset
    reset_i = 1'b1;
    add_i   = 1'b0;
    data_i  = 8'h00;
    repeat (5) @(posedge clock_i);
    reset_i = 1'b0;
    repeat (2) @(posedge clock_i);

    // envia todas as amostras: prepara no negedge e amostra no posedge
    for (int i = 0; i < N; i++) begin
      @(negedge clock_i);
      data_i = samples[i];
      add_i  = 1'b1;

      @(posedge clock_i);     // DUT vê add_i=1 e data_i estável

      @(negedge clock_i);
      add_i  = 1'b0;
    end

    // aguarda possíveis saídas
    repeat (20) @(posedge clock_i);
    $finish;
  end

  // Log mínimo
  always @(posedge clock_i) begin
    if (peak_valid_o)
      $display("[%0t] peak_valid_o=1  data_i=0x%02h", $time, data_i);

    if (frame_valid_o) begin
      $display("[%0t] frame_valid_o=1  frame_o[0]=0x%02h  frame_o[90]=0x%02h  frame_o[180]=0x%02h",
               $time, frame_o[0], frame_o[90], frame_o[180]);
      // Se quiser ver tudo, descomente:
      // for (int k = 0; k <= 180; k++) $write("%02h%s", frame_o[k], (k==180) ? "\n" : " ");
    end
  end

  // DUT
  peak_detector dut (
    .clock_i(clock_i),
    .reset_i(reset_i),
    .add_i(add_i),
    .data_i(data_i),
    .peak_valid_o(peak_valid_o),
    .frame_o(frame_o),
    .frame_valid_o(frame_valid_o)
  );

endmodule
