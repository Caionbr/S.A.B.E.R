`timescale 1ns/1ps

module tb_mlp_top_stdzdense1;

  // ----------------- Parâmetros -----------------
  localparam int N_IN   = 181;
  localparam int N_OUT1 = 64;

  // ------------- Clocks/Resets/Sinais ----------
  logic                   clock_i;
  logic                   reset_i;
  logic                   data_valid_i;
  logic [N_IN-1:0][7:0]   data_i;

  logic                   dense_valid_o;
  logic [N_OUT1*16-1:0]   dense_y_o;

  // ----------------- DUT ------------------------
  mlp_top_stdzdense1 #(
    .N_IN(N_IN),
    .N_OUT1(N_OUT1)
  ) dut (
    .clock_i      (clock_i),
    .reset_i      (reset_i),
    .data_valid_i (data_valid_i),
    .data_i       (data_i),
    .dense_valid_o(dense_valid_o),
    .dense_y_o    (dense_y_o)
  );

  // ------------- Geração de clock --------------
  // 100 MHz => 10 ns de período
  initial clock_i = 1'b0;
  always  #5 clock_i = ~clock_i;

  // ------------- Frame de entrada ---------------
  // 181 bytes (MSB-first no literal). Largura = 181*8 = 1448 bits.
  localparam int W_BITS = N_IN*8;
  localparam [W_BITS-1:0] FRAME_HEX = 1448'h
    ABA9A49F9B9A9B99958F8D8A8986827D7C7C7C77716C6C6D6D6B686566656360605F5E5D5E5E5C5C5B5B5F5D5754575A5B5D5B5C5C6060615F5F6061636464616466696C6B6969696C7275777A7C7E7A7A808E9FB1C5DCEFF9FEFFFAF1E0C6A37542170300070E0F0A07050306090B0D10171E2224262A2F363C3F3F4046484B4B4B4C4C4C4D504F4C4F50515151515454555555555758565455595B5C5D5E5D5F616467696B6D6F71757B8083888F929395979FA6;

  // ------------- Estímulos ----------------------
  initial begin
    // dump genérico (Icarus/Verilator). Em Vivado, use a waveform GUI.
    $dumpfile("tb_mlp_top_stdzdense1.vcd");
    $dumpvars(0, tb_mlp_top_stdzdense1);

    // Reset
    reset_i       = 1'b1;
    data_valid_i  = 1'b0;
    data_i        = '0;
    repeat (5) @(posedge clock_i);
    reset_i       = 1'b0;
    @(posedge clock_i);

    // Carrega o vetor paralelo (byte 0 = 0xAB vai para data_i[0])
    for (int i = 0; i < N_IN; i++) begin
      data_i[i] = FRAME_HEX[(N_IN-1-i)*8 +: 8];
    end

    // Pulso de data_valid_i por 1 ciclo
    @(posedge clock_i);
    data_valid_i <= 1'b1;
    @(posedge clock_i);
    data_valid_i <= 1'b0;

    // Aguarda saída válida do DENSE1 (latência total = 2 ciclos)
    wait (dense_valid_o == 1'b1);
    // imprime as 64 saídas (Q2.14)
    $display("\n=== DENSE1 OUT (64 × Q2.14) ===");
    for (int j = 0; j < N_OUT1; j++) begin
      logic signed [15:0] yj;
      yj = dense_y_o[j*16 +: 16];
      $display("y[%0d] = 0x%04h (%0d)", j, yj[15:0], $signed(yj));
    end

    // encerra
    #20;
    $finish;
  end

endmodule
