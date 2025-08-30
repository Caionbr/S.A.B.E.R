`timescale 1ns/1ps
`default_nettype none

module tb_mlp_top;

  // ---------------- Parâmetros ----------------
  localparam int    N_IN        = 181;
  localparam string FRAMES_FILE = "frames.mem";
  localparam string LABELS_FILE = "labels.mem";   // opcional

  // ---------------- DUT signals ----------------
  logic                   clock_i = 1'b0;
  logic                   reset_i = 1'b1;
  logic                   data_valid_i = 1'b0;
  logic [N_IN-1:0][7:0]   data_i;
  logic                   out_valid_o;
  logic [15:0]            y_o;

  // ---------------- DUT ----------------
  mlp_top dut (
    .clock_i(clock_i),
    .reset_i(reset_i),
    .data_valid_i(data_valid_i),
    .data_i(data_i),
    .out_valid_o(out_valid_o),
    .y_o(y_o)
  );

  // ---------------- Clock 100 MHz ----------------
  always #5 clock_i = ~clock_i;

  // ---------------- Variáveis globais p/ I/O e parsing ----------------
  // (declaradas fora dos blocks para agradar o parser do Vivado)
  integer fd_frames, fd_labels;
  integer have_label;
  integer label;
  string  line_f, line_l;
  string  token_hex;
  integer ok_scan;
  logic [N_IN*8-1:0] FRAME_VEC;
  real    y_float;
  bit     pred;

  // -------- helper: carrega 1 token HEX -> vetor [N_IN*8-1:0] --------
  function automatic void load_vector_from_hex(input string hexline,
                                               output logic [N_IN*8-1:0] vec);
    string tok;
    integer ok1, ok2;
    ok1 = $sscanf(hexline, "%s", tok);  // pega 1º token da linha
    if (ok1 != 1) begin
      $fatal(1, "[TB] Linha inválida em %s: '%s'", FRAMES_FILE, hexline);
    end
    if (tok.len() < N_IN*2) begin
      $fatal(1, "[TB] Linha curta em %s: len=%0d (esperado >= %0d)",
                 FRAMES_FILE, tok.len(), N_IN*2);
    end
    ok2 = $sscanf(tok, "%h", vec);
    if (ok2 != 1) begin
      $fatal(1, "[TB] Falha ao parsear HEX em %s: '%s'", FRAMES_FILE, tok);
    end
  endfunction

  // ---------------- Estímulos ----------------
  initial begin
    $dumpfile("tb_mlp_top.vcd");
    $dumpvars(0, tb_mlp_top);

    // reset
    repeat (5) @(posedge clock_i);
    reset_i = 1'b0;
    @(posedge clock_i);

    // abre arquivos
    fd_frames = $fopen(FRAMES_FILE, "r");
    if (fd_frames == 0) $fatal(1, "[TB] Não abriu %s. Adicione como Simulation Source > Memory Initialization Files.", FRAMES_FILE);

    fd_labels = $fopen(LABELS_FILE, "r");
    have_label = (fd_labels != 0);

    // lê primeira linha de frames.mem
    ok_scan = $fgets(line_f, fd_frames);
    if (ok_scan == 0 || line_f.len() == 0) $fatal(1, "[TB] %s vazio.", FRAMES_FILE);

    // converte para vetor grande e mapeia para porta 2D
    load_vector_from_hex(line_f, FRAME_VEC);
    for (int i = 0; i < N_IN; i++) begin
      // arquivo é MSB-first; byte 0 → data_i[0]
      data_i[i] = FRAME_VEC[(N_IN-1-i)*8 +: 8];
    end

    // lê primeiro label (se existir)
    label = -1;
    if (have_label) begin
      ok_scan = $fgets(line_l, fd_labels);
      if (ok_scan != 0 && line_l.len() > 0) void'($sscanf(line_l, "%d", label));
      $display("[TB] label(0=N,1=A) = %0d", label);
      $fclose(fd_labels);
    end
    $fclose(fd_frames);

    // 1 pulso de data_valid_i
    @(posedge clock_i); data_valid_i <= 1'b1;
    @(posedge clock_i); data_valid_i <= 1'b0;

    // watchdog e coleta
    fork
      begin : TIMEOUT
        #2000ns;
        $fatal(1, "[TB] TIMEOUT: out_valid_o não ficou 1 em 2 us. Verifique .mem e conexões.");
      end
      begin : RUN
        wait (out_valid_o === 1'b1);
        y_float = real'(y_o) / 32768.0;
        pred    = (y_o >= 16'h4000);

        $display("[TB] out_valid_o=1 @ %0t", $time);
        if (have_label)
          $display("[TB] y_o (Q1.15) = 0x%04h (%0d) ~ %0.6f  => pred=%0d  %s",
                   y_o, $signed(y_o), y_float, pred,
                   (pred == (label==1)) ? "OK" : "MISS");
        else
          $display("[TB] y_o (Q1.15) = 0x%04h (%0d) ~ %0.6f  => pred=%0d",
                   y_o, $signed(y_o), y_float, pred);

        #20ns; $finish;
      end
    join_any
    disable fork;
  end

  // ---------------- Sanity check (útil) ----------------
  initial begin
    #1ns;
    $display("[CHK] STDZ A[0]=0x%0h B[0]=0x%0h", dut.u_stdz.A[0], dut.u_stdz.B[0]);
    $display("[CHK] D1   W1[0]=0x%0h b1[0]=0x%0h", dut.u_d1.W1[0],  dut.u_d1.B1[0]);
    $display("[CHK] D2   W2[0]=0x%0h b2[0]=0x%0h", dut.u_d2.W2[0],  dut.u_d2.B2[0]);
    $display("[CHK] D3   W3[0]=0x%0h b3[0]=0x%0h SIG[0]=0x%0h",
             dut.u_d3.W3[0],  dut.u_d3.B3[0], dut.u_d3.SIGMOID_LUT[0]);
  end

endmodule

`default_nettype wire
