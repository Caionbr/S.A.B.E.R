`timescale 1ns/1ps
`default_nettype none

module mlp_pipeline_top #(
  // preprocess
  parameter int PRE_ZERO_POINT = 128,
  parameter int PRE_SHIFT_UP   = 1,

  // requant shifts
  parameter int SHIFT1 = 7,
  parameter int SHIFT2 = 7,
  parameter int SHIFT3 = 7
)(
  input  logic        clk_i,
  input  logic        rst_i,

  // controle topo
  input  logic        start_i,
  output logic        busy_o,
  output logic        done_o,

  // stream de entrada: 181 bytes u8
  input  logic        in_valid_i,
  output logic        in_ready_o,
  input  logic [7:0]  in_data_u8_i,

  // resultado final
  output logic        out_valid_o,
  output logic [15:0] out_value_o
);

  // ===== Preprocess =====
  logic pre_valid;
  logic pre_out_ready;     // <- novo wire
  logic [7:0] pre_s8;

  pre_block_u8_to_s8 #(
    .ZERO_POINT (PRE_ZERO_POINT),
    .SHIFT_UP   (PRE_SHIFT_UP)
  ) u_pre (
    .clk_i        (clk_i),
    .rst_i        (rst_i),
    .in_valid_i   (in_valid_i),
    .in_ready_o   (in_ready_o),
    .in_data_u8_i (in_data_u8_i),
    .out_valid_o  (pre_valid),
    .out_ready_i  (pre_out_ready),   // <- ligado ao wire
    .out_data_s8_o(pre_s8)
  );

  // ===== Dense1 =====
  logic d1_start, d1_busy, d1_done;
  logic d1_in_ready, d1_out_valid;
  logic [15:0] d1_out_data;

  dense_stage1 #(.SHIFT(SHIFT1)) u_d1 (
    .clk_i(clk_i), .rst_i(rst_i),
    .start_i(d1_start), .busy_o(d1_busy), .done_o(d1_done),
    .in_valid_i(pre_valid), .in_ready_o(d1_in_ready), .in_data_s8_i(pre_s8),
    .out_valid_o(d1_out_valid), .out_data_s16_o(d1_out_data)
  );

  // ===== Dense2 =====
  logic d2_start, d2_busy, d2_done;
  logic d2_in_ready, d2_out_valid;
  logic [15:0] d2_out_data;

  dense_stage2 #(.SHIFT(SHIFT2)) u_d2 (
    .clk_i(clk_i), .rst_i(rst_i),
    .start_i(d2_start), .busy_o(d2_busy), .done_o(d2_done),
    .in_valid_i(d1_out_valid), .in_ready_o(d2_in_ready), .in_data_s16_i(d1_out_data),
    .out_valid_o(d2_out_valid), .out_data_s16_o(d2_out_data)
  );

  // ===== Dense3 =====
  logic d3_start, d3_busy, d3_done;
  logic d3_in_ready, d3_out_valid;
  logic [15:0] d3_out_data;

  dense_stage3 #(.SHIFT(SHIFT3)) u_d3 (
    .clk_i(clk_i), .rst_i(rst_i),
    .start_i(d3_start), .busy_o(d3_busy), .done_o(d3_done),
    .in_valid_i(d2_out_valid), .in_ready_o(d3_in_ready), .in_data_s16_i(d2_out_data),
    .out_valid_o(d3_out_valid), .out_data_s16_o(d3_out_data)
  );

  // ===== Orquestração =====
  typedef enum logic [2:0] {T_IDLE, T_COLLECT1, T_RUN1, T_COLLECT2, T_RUN2, T_COLLECT3, T_RUN3, T_DONE} tstate_t;
  tstate_t st;

  // conecta ready do PRE na D1 só quando estamos coletando a D1
  assign pre_out_ready = (st == T_COLLECT1) ? d1_in_ready : 1'b0;

  // busy/done/out
  assign busy_o      = (st != T_IDLE) && (st != T_DONE);
  assign done_o      = (st == T_DONE);
  assign out_valid_o = (st == T_RUN3) && d3_out_valid;
  assign out_value_o = d3_out_data;

  always_ff @(posedge clk_i) begin
    if (rst_i) begin
      st       <= T_IDLE;
      d1_start <= 1'b0;
      d2_start <= 1'b0;
      d3_start <= 1'b0;
    end else begin
      d1_start <= 1'b0;
      d2_start <= 1'b0;
      d3_start <= 1'b0;

      unique case (st)
        T_IDLE:     if (start_i) begin d1_start <= 1'b1; st <= T_COLLECT1; end
        T_COLLECT1: if (d1_busy && !d1_in_ready) st <= T_RUN1;
        T_RUN1:     if (d1_done) begin d2_start <= 1'b1; st <= T_COLLECT2; end
        T_COLLECT2: if (d2_busy && !d2_in_ready) st <= T_RUN2;
        T_RUN2:     if (d2_done) begin d3_start <= 1'b1; st <= T_COLLECT3; end
        T_COLLECT3: if (d3_busy && !d3_in_ready) st <= T_RUN3;
        T_RUN3:     if (d3_done) st <= T_DONE;
        T_DONE:     st <= T_IDLE;
      endcase
    end
  end

endmodule

`default_nettype wire
