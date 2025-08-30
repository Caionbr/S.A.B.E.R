`timescale 1ns / 1ps

module peak_detector (
    input  logic         clock_i,
    input  logic         reset_i,
    input  logic         add_i,
    input  logic [7:0]   data_i,
    
    output logic         peak_valid_o,
    output logic [7:0]   frame_o [0:180],
    output logic         frame_valid_o
);

    // === Buffers ===
    logic [7:0]  data_buf[0:9];      // janela curta para correlação
    logic [7:0]  out_buf [0:180];    // buffer longo para exportar o frame
    logic [7:0]  out_buf_next [0:180]; // << NOVO: versão shiftada deste ciclo
    logic [19:0] corr_buf[0:2];
    logic [19:0] corr_value;

    // === Contador para centralizar (83 amostras após o pico) ===
    logic        waiting_center;
    logic [7:0]  wait_cnt;           // conta em ciclos com add_i=1

    // === Threshold adaptativo ===
    logic [15:0] threshold;
    logic [15:0] scaled_peak;
    logic [7:0]  peak_value_s;

    // === Template fixo ===
    logic [7:0] template[0:6];

    // --------- out_buf_next: estado pós-shift deste ciclo ---------
    always_comb begin
        // por padrão, "next" = estado atual
        for (int i = 0; i < 181; i++) out_buf_next[i] = out_buf[i];
        if (add_i) begin
            for (int i = 0; i < 180; i++) out_buf_next[i] = out_buf[i+1];
            out_buf_next[180] = data_i;
        end
    end

    // === Shift de dados ===
    always_ff @(posedge clock_i) begin
        if (reset_i) begin
            for (int i = 0; i < 10;  i++) data_buf[i] <= 8'd0;
            for (int i = 0; i < 181; i++) out_buf[i]  <= 8'd0;
        end else if (add_i) begin
            // janela curta (10)
            for (int i = 0; i < 9; i++) data_buf[i] <= data_buf[i+1];
            data_buf[9] <= data_i;

            // buffer longo (181) - usa versão next para registrar
            for (int i = 0; i < 181; i++) out_buf[i] <= out_buf_next[i];
        end
    end

    // === Correlação ===
    always_ff @(posedge clock_i) begin
        if (reset_i) begin
            corr_value <= '0;
            for (int i = 0; i < 3; i++)
                corr_buf[i] <= '0;
        end else if (add_i) begin
            corr_value = '0;
            for (int i = 0; i < 7; i++) begin
                corr_value += data_buf[i+3] * template[i]; // mantém seu índice
            end
            corr_buf[2] <= corr_buf[1];
            corr_buf[1] <= corr_buf[0];
            corr_buf[0] <= corr_value;
        end
    end

    // === Atualização dinâmica do threshold ===
    always_ff @(posedge clock_i) begin
        if (reset_i) begin
            threshold <= 8'd204; // 80% de 255
        end else if (peak_valid_o) begin
            scaled_peak = (peak_value_s * 16'd204) >> 8;
            threshold   <= (threshold + scaled_peak) >> 1;
        end
    end

    // === Atualização dinâmica do template ===
    always_ff @(posedge clock_i) begin
        if (reset_i) begin
            template <= '{8'd225, 8'd241, 8'd251, 8'd255, 8'd251, 8'd241, 8'd225};
        end else if (peak_valid_o) begin
            for (int i = 0; i < 7; i++) begin
                logic [8:0] sum9;
                sum9 = template[i] + data_buf[i];
                template[i] <= sum9 >> 1; // média simples
            end
        end
    end

    // === Detecção de pico (sem período refratário) ===
    always_ff @(posedge clock_i) begin
        if (reset_i) begin
            peak_value_s  <= 8'd0;
            peak_valid_o  <= 1'b0;
        end else if (add_i) begin
            if ((corr_buf[1] > corr_buf[0]) && (corr_buf[1] > corr_buf[2])) begin
                peak_value_s <= data_buf[4]; // mantém seu índice de pico
                if (data_buf[4] > threshold) begin
                    peak_valid_o <= 1'b1;     // <-- sem checar refratário
                end else begin
                    peak_valid_o <= 1'b0;
                end
            end else begin
                peak_value_s  <= 8'd0;
                peak_valid_o  <= 1'b0;
            end
        end else begin
            peak_value_s  <= 8'd0;
            peak_valid_o  <= 1'b0;
        end
    end

    // === Contagem 83 e emissão do frame com o buffer ATUAL ===
    always_ff @(posedge clock_i) begin
        if (reset_i) begin
            waiting_center <= 1'b0;
            wait_cnt       <= 8'd0;
            frame_valid_o  <= 1'b0;
            for (int i = 0; i < 181; i++) frame_o[i] <= 8'd0;
        end else begin
            frame_valid_o <= 1'b0; // pulso 1 ciclo

            // inicia a contagem quando detecta pico (e não está aguardando)
            if (peak_valid_o && !waiting_center) begin
                waiting_center <= 1'b1;
                wait_cnt       <= 8'd83; // conta 83 amostras novas (com add_i=1)
            end

            // decrementa somente quando chega amostra nova
            if (waiting_center && add_i) begin
                if (wait_cnt == 8'd0) begin
                    // >>> captura o estado ATUAL (pós-shift) deste ciclo
                    for (int i = 0; i < 181; i++) frame_o[i] <= out_buf_next[i];
                    frame_valid_o  <= 1'b1;
                    waiting_center <= 1'b0;
                end else begin
                    wait_cnt <= wait_cnt - 8'd1;
                end
            end
        end
    end

endmodule
