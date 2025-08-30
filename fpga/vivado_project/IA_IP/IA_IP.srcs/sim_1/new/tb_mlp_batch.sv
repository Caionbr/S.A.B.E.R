`timescale 1ns/1ps
`default_nettype none

module tb_mlp_batch;

  // ---------- parâmetros ----------
  localparam int    N_IN         = 181;
  localparam string FRAMES_FILE  = "frames.mem";   // 1 linha = 181 bytes hex (362 chars)
  localparam string LABELS_FILE  = "labels.mem";   // 1 linha = 0 ou 1
  localparam int    MAX_SAMPLES  = 1_000_000;      // safety cap
  localparam int    TIMEOUT_CYC  = 5000;           // ~50 us @100MHz
  localparam int    PRINT_EVERY  = 100;            // imprime a cada N (1 = toda amostra)

  // ---------- DUT signals ----------
  logic                   clock_i = 1'b0;
  logic                   reset_i = 1'b1;
  logic                   data_valid_i = 1'b0;
  logic [N_IN-1:0][7:0]   data_i;
  logic                   out_valid_o;
  logic [15:0]            y_o;

  // ---------- DUT ----------
  mlp_top dut (
    .clock_i(clock_i),
    .reset_i(reset_i),
    .data_valid_i(data_valid_i),
    .data_i(data_i),
    .out_valid_o(out_valid_o),
    .y_o(y_o)
  );

  // ---------- clock 100 MHz ----------
  always #5 clock_i = ~clock_i;

  // ---------- globais / io / parsing ----------
  integer fd_frames, fd_labels, fd_csv;
  string  line_f, line_l;
  integer ok_scan;
  logic   have_labels;
  integer label;
  logic [N_IN*8-1:0] frame_vec;

  // métricas
  integer total, with_labels;
  integer TP, TN, FP, FN;
  real    y_float;
  logic   pred;
  integer tmo;

  // helper: parse 1 token hex -> vetor
  function automatic void parse_hex_line(input string line, output logic [N_IN*8-1:0] vec);
    string tok;
    integer ok1, ok2;
    ok1 = $sscanf(line, "%s", tok);
    if (ok1 != 1) $fatal(1, "[TB] Linha inválida em %s: '%s'", FRAMES_FILE, line);
    if (tok.len() < N_IN*2) $fatal(1, "[TB] Linha curta: len=%0d (esperado >= %0d)", tok.len(), N_IN*2);
    ok2 = $sscanf(tok, "%h", vec);
    if (ok2 != 1) $fatal(1, "[TB] Falha ao parsear HEX: '%s'", tok);
  endfunction

  // task: aplica um frame no DUT (porta 2D) + pulso de valid
  task automatic drive_frame(input logic [N_IN*8-1:0] vec);
    int i;
    for (i = 0; i < N_IN; i++) begin
      data_i[i] = vec[(N_IN-1-i)*8 +: 8];  // arquivo é MSB-first
    end
    @(posedge clock_i); data_valid_i <= 1'b1;
    @(posedge clock_i); data_valid_i <= 1'b0;
  endtask

  // ---------- estímulos ----------
  initial begin
    $dumpfile("tb_mlp_batch.vcd");
    $dumpvars(0, tb_mlp_batch);

    // reset
    repeat (5) @(posedge clock_i);
    reset_i = 1'b0;
    @(posedge clock_i);

    // abre arquivos
    fd_frames = $fopen(FRAMES_FILE, "r");
    if (fd_frames == 0) $fatal(1, "[TB] Não abriu %s. Adicione em Simulation Sources > Memory Initialization Files.", FRAMES_FILE);

    fd_labels   = $fopen(LABELS_FILE, "r");
    have_labels = (fd_labels != 0);

    // CSV de saída
    fd_csv = $fopen("results.csv", "w");
    if (fd_csv == 0) $fatal(1, "[TB] Não abriu results.csv para escrita.");
    // cabeçalho
    $fdisplay(fd_csv, "idx,y_hex,y_int,y_float,pred,label");

    // init métricas
    total = 0; with_labels = 0;
    TP = 0; TN = 0; FP = 0; FN = 0;

    // loop de amostras
    while (!$feof(fd_frames)) begin
      if (total >= MAX_SAMPLES) begin
        $display("[TB] Atingiu MAX_SAMPLES=%0d; parando.", MAX_SAMPLES);
        break;
      end

      // lê linha de frames; pula linhas vazias
      ok_scan = $fgets(line_f, fd_frames);
      if (ok_scan == 0) break;
      if (line_f.len() == 0) continue;

      // parse -> vetor
      parse_hex_line(line_f, frame_vec);

      // lê label (se existir)
      label = 0;
      if (have_labels && !$feof(fd_labels)) begin
        ok_scan = $fgets(line_l, fd_labels);
        if (ok_scan != 0 && line_l.len() > 0) void'($sscanf(line_l, "%d", label));
        with_labels = with_labels + 1;
      end

      // dirige DUT
      drive_frame(frame_vec);

      // espera saída com timeout de ciclos
      tmo = 0;
      while (out_valid_o !== 1'b1) begin
        @(posedge clock_i);
        tmo = tmo + 1;
        if (tmo > TIMEOUT_CYC) $fatal(1, "[TB] TIMEOUT na amostra %0d", total);
      end

      // coleta, registra e mostra
      y_float = real'(y_o) / 32768.0;
      pred    = (y_o >= 16'h4000);

      // CSV: idx,y_hex,y_int,y_float,pred,label
      $fdisplay(fd_csv, "%0d,0x%04h,%0d,%0.8f,%0d,%0d",
                total, y_o, $signed(y_o), y_float, pred, label);

      // console (a cada PRINT_EVERY)
      if ((total % PRINT_EVERY) == 0)
        $display("[TB] n=%0d  y=0x%04h (%0d) ~ %0.6f  pred=%0d  label=%0d",
                 total, y_o, $signed(y_o), y_float, pred, label);

      // métricas
      if (have_labels) begin
        if (label==1 && pred==1) TP = TP + 1;
        else if (label==0 && pred==0) TN = TN + 1;
        else if (label==0 && pred==1) FP = FP + 1;
        else if (label==1 && pred==0) FN = FN + 1;
      end

      total = total + 1;

      // gap entre amostras
      repeat (2) @(posedge clock_i);
    end

    $fclose(fd_frames);
    if (have_labels) $fclose(fd_labels);
    $fclose(fd_csv);

    // resumo
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

    #50ns; $finish;
  end

  // sanity-check de ROMs (opcional)
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
