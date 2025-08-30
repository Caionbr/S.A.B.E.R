`timescale 1ns/1ps
`default_nettype none

module tb_mlp_pipeline_top;

  localparam int    N_IN         = 181;
  localparam string FRAMES_FILE  = "frames.mem";   // 1 linha = 181 bytes em HEX contínuo
  localparam string LABELS_FILE  = "labels.mem";   // 1 linha = 0 ou 1
  localparam int    MAX_SAMPLES  = 1_000_000;
  localparam int    TIMEOUT_CYC  = 1_000_000;
  localparam int    PRINT_EVERY  = 100;

  // ---- DUT I/O ----
  logic clk_i=1'b0, rst_i=1'b1;
  logic start_i=1'b0;

  logic in_valid_i=1'b0;
  wire  in_ready_o;
  logic [7:0] in_data_u8_i;

  wire  busy_o, done_o;
  wire  out_valid_o;
  wire signed [15:0] out_value_o;

  // ---- VARS GLOBAIS DO TB (declare no topo) ----
  logic [N_IN*8-1:0] frame_vec;   // <- AQUI!
  integer fd_frames, fd_labels, fd_csv;
  string  line_f, line_l;
  integer ok_scan;
  logic   have_labels;
  integer label;

  integer total, with_labels;
  integer TP, TN, FP, FN;
  real    y_float;
  logic   pred;
  integer tmo;

  // DUT
  mlp_pipeline_top dut (
    .clk_i(clk_i), .rst_i(rst_i),
    .start_i(start_i), .busy_o(busy_o), .done_o(done_o),
    .in_valid_i(in_valid_i), .in_ready_o(in_ready_o), .in_data_u8_i(in_data_u8_i),
    .out_valid_o(out_valid_o), .out_value_o(out_value_o)
  );

  // clock
  always #5 clk_i = ~clk_i;

  // helpers
  function automatic void parse_hex_line(input string line, output logic [N_IN*8-1:0] vec);
    string tok;
    integer ok1, ok2;
    ok1 = $sscanf(line, "%s", tok);
    if (ok1 != 1) $fatal(1, "[TB] Linha inválida em %s: '%s'", FRAMES_FILE, line);
    if (tok.len() < N_IN*2) $fatal(1, "[TB] Linha curta: len=%0d (>= %0d)", tok.len(), N_IN*2);
    ok2 = $sscanf(tok, "%h", vec);
    if (ok2 != 1) $fatal(1, "[TB] Falha ao parsear HEX: '%s'", tok);
  endfunction

  task automatic drive_frame_stream(input logic [N_IN*8-1:0] vec);
    int i;
    logic [7:0] byte_i;

    // start
    @(posedge clk_i);
    start_i <= 1'b1;
    @(posedge clk_i);
    start_i <= 1'b0;

    // 181 bytes (arquivo MSB-first)
    for (i = 0; i < N_IN; i++) begin
      byte_i = vec[(N_IN-1-i)*8 +: 8];
      // aguarda ready
      do @(posedge clk_i); while (!in_ready_o);
      // seta dado e valid
      in_data_u8_i <= byte_i;
      in_valid_i   <= 1'b1;
      @(posedge clk_i);
      in_valid_i   <= 1'b0;
    end
  endtask

  // estímulos
  initial begin
    $dumpfile("tb_mlp_pipeline_top.vcd");
    $dumpvars(0, tb_mlp_pipeline_top);

    repeat (10) @(posedge clk_i);
    rst_i = 1'b0;
    @(posedge clk_i);

    fd_frames = $fopen(FRAMES_FILE, "r");
    if (fd_frames == 0) $fatal(1, "[TB] Não abriu %s", FRAMES_FILE);

    fd_labels   = $fopen(LABELS_FILE, "r");
    have_labels = (fd_labels != 0);

    fd_csv = $fopen("results.csv", "w");
    if (fd_csv == 0) $fatal(1, "[TB] Não abriu results.csv");
    $fdisplay(fd_csv, "idx,y_hex,y_int,y_float,pred,label");

    total = 0; with_labels = 0;
    TP=0; TN=0; FP=0; FN=0;

    while (!$feof(fd_frames)) begin
      if (total >= MAX_SAMPLES) begin
        $display("[TB] Atingiu MAX_SAMPLES=%0d; parando.", MAX_SAMPLES);
        break;
      end

      ok_scan = $fgets(line_f, fd_frames);
      if (ok_scan == 0) break;
      if (line_f.len() == 0) continue;

      // parse -> frame_vec (declarado no topo)
      parse_hex_line(line_f, frame_vec);

      label = 0;
      if (have_labels && !$feof(fd_labels)) begin
        ok_scan = $fgets(line_l, fd_labels);
        if (ok_scan != 0 && line_l.len() > 0) void'($sscanf(line_l, "%d", label));
        with_labels = with_labels + 1;
      end

      drive_frame_stream(frame_vec);

      tmo = 0;
      while (out_valid_o !== 1'b1) begin
        @(posedge clk_i);
        tmo = tmo + 1;
        if (tmo > TIMEOUT_CYC) $fatal(1, "[TB] TIMEOUT na amostra %0d", total);
      end

      y_float = real'(out_value_o) / 32768.0;
      pred    = (out_value_o >= 16'h4000);

      $fdisplay(fd_csv, "%0d,0x%04h,%0d,%0.8f,%0d,%0d",
                total, out_value_o, $signed(out_value_o), y_float, pred, label);

      if ((total % PRINT_EVERY) == 0)
        $display("[TB] n=%0d  y=0x%04h (%0d) ~ %0.6f  pred=%0d  label=%0d",
                 total, out_value_o, $signed(out_value_o), y_float, pred, label);

      if (have_labels) begin
        if (label==1 && pred==1) TP = TP + 1;
        else if (label==0 && pred==0) TN = TN + 1;
        else if (label==0 && pred==1) FP = FP + 1;
        else if (label==1 && pred==0) FN = FN + 1;
      end

      total = total + 1;
      repeat (2) @(posedge clk_i);
    end

    $fclose(fd_frames);
    if (have_labels) $fclose(fd_labels);
    $fclose(fd_csv);

    if (have_labels && with_labels>0) begin
      real acc, sens, espec;
      acc   = real'(TP+TN) / real'(with_labels);
      sens  = (TP+FN)>0 ? real'(TP)/real'(TP+FN) : 0.0;
      espec = (TN+FP)>0 ? real'(TN)/real'(TN+FP) : 0.0;
      $display("\n[TB] --- Métricas ---");
      $display("[TB] Total rotuladas: %0d (total lidas: %0d)", with_labels, total);
      $display("[TB] TP=%0d  TN=%0d  FP=%0d  FN=%0d", TP,TN,FP,FN);
      $display("[TB] Acurácia = %0.4f  |  Sensibilidade = %0.4f  |  Especificidade = %0.4f",
               acc, sens, espec);
      $display("[TB] CSV salvo em results.csv");
    end else begin
      $display("\n[TB] Rodou %0d amostras (sem labels). CSV salvo em results.csv", total);
    end

    #200ns; $finish;
  end

  // sanity
  initial begin
    #1us;
    $display("[CHK] D1 W[0]=0x%0h B[0]=0x%0h", dut.u_d1.u_core.W[0], dut.u_d1.u_core.B[0]);
    $display("[CHK] D2 W[0]=0x%0h B[0]=0x%0h", dut.u_d2.u_core.W[0], dut.u_d2.u_core.B[0]);
    $display("[CHK] D3 W[0]=0x%0h B[0]=0x%0h", dut.u_d3.u_core.W[0], dut.u_d3.u_core.B[0]);
  end

endmodule

`default_nettype wire
