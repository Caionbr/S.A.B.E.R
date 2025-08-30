`timescale 1 ns / 1 ps

module reg_v3_slave_lite_v1_0_S00_AXI #
(
  parameter integer C_S_AXI_DATA_WIDTH = 32,
  parameter integer C_S_AXI_ADDR_WIDTH = 8
)
(
  // AXI4-Lite
  input  wire                           S_AXI_ACLK,
  input  wire                           S_AXI_ARESETN,
  input  wire [C_S_AXI_ADDR_WIDTH-1:0]  S_AXI_AWADDR,
  input  wire [2:0]                     S_AXI_AWPROT,
  input  wire                           S_AXI_AWVALID,
  output wire                           S_AXI_AWREADY,
  input  wire [C_S_AXI_DATA_WIDTH-1:0]  S_AXI_WDATA,
  input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0] S_AXI_WSTRB,
  input  wire                           S_AXI_WVALID,
  output wire                           S_AXI_WREADY,
  output wire [1:0]                     S_AXI_BRESP,
  output wire                           S_AXI_BVALID,
  input  wire                           S_AXI_BREADY,
  input  wire [C_S_AXI_ADDR_WIDTH-1:0]  S_AXI_ARADDR,
  input  wire [2:0]                     S_AXI_ARPROT,
  input  wire                           S_AXI_ARVALID,
  output wire                           S_AXI_ARREADY,
  output wire [C_S_AXI_DATA_WIDTH-1:0]  S_AXI_RDATA,
  output wire [1:0]                     S_AXI_RRESP,
  output wire                           S_AXI_RVALID,
  input  wire                           S_AXI_RREADY,

  // PL
  input  wire [1791:0]                  data_i,       // 56 x 32b
  input  wire                           ready_i,      // status (do packer)
  input  wire                           send_wifi_i,  // PULSO 1 ciclo: capturar data_i
  output wire                           clr_o         // pulso 1 ciclo (write-1 em 0xE0 bit0)
);

  // --------------------------
  // Constantes locais (Verilog-2001)
  // --------------------------
  localparam integer N_WORDS    = 56;
  localparam integer TOTAL_BITS = N_WORDS*32; // 1792

  // --------------------------
  // AXI internas
  // --------------------------
  reg axi_awready, axi_wready, axi_bvalid;
  reg axi_arready, axi_rvalid;
  reg [C_S_AXI_DATA_WIDTH-1:0] axi_rdata;

  assign S_AXI_AWREADY = axi_awready;
  assign S_AXI_WREADY  = axi_wready;
  assign S_AXI_BVALID  = axi_bvalid;
  assign S_AXI_BRESP   = 2'b00; // OKAY
  assign S_AXI_ARREADY = axi_arready;
  assign S_AXI_RVALID  = axi_rvalid;
  assign S_AXI_RDATA   = axi_rdata;
  assign S_AXI_RRESP   = 2'b00; // OKAY

  // Índices (addr/4)
  wire [7:0] widx_w = S_AXI_AWADDR[C_S_AXI_ADDR_WIDTH-1:2];
  wire [7:0] widx_r = S_AXI_ARADDR[C_S_AXI_ADDR_WIDTH-1:2];

  // --------------------------
  // WRITE: aceita AW e W em ciclos diferentes
  // --------------------------
  reg aw_seen, w_seen;
  reg [C_S_AXI_ADDR_WIDTH-1:0] awaddr_lat;

  wire aw_hs = S_AXI_AWVALID && S_AXI_AWREADY;
  wire w_hs  = S_AXI_WVALID  && S_AXI_WREADY;

  always @(posedge S_AXI_ACLK) begin
    if (!S_AXI_ARESETN) begin
      axi_awready <= 1'b0;
      axi_wready  <= 1'b0;
      axi_bvalid  <= 1'b0;
      aw_seen     <= 1'b0;
      w_seen      <= 1'b0;
      awaddr_lat  <= {C_S_AXI_ADDR_WIDTH{1'b0}};
    end else begin
      axi_awready <= (~aw_seen && ~axi_bvalid);
      axi_wready  <= (~w_seen  && ~axi_bvalid);

      if (aw_hs) begin
        aw_seen    <= 1'b1;
        awaddr_lat <= S_AXI_AWADDR;
      end
      if (w_hs) begin
        w_seen <= 1'b1;
      end

      if (aw_seen && w_seen && ~axi_bvalid) begin
        axi_bvalid <= 1'b1;   // resposta OKAY
        aw_seen    <= 1'b0;
        w_seen     <= 1'b0;
      end

      if (axi_bvalid && S_AXI_BREADY)
        axi_bvalid <= 1'b0;
    end
  end

  // --------------------------
  // CLR: write-1 em 0xE0 (índice 56), bit0 → 1 ciclo
  // --------------------------
  reg clr_pulse_r;
  assign clr_o = clr_pulse_r;

  always @(posedge S_AXI_ACLK) begin
    if (!S_AXI_ARESETN) begin
      clr_pulse_r <= 1'b0;
    end else begin
      clr_pulse_r <= 1'b0;
      if (aw_seen && w_seen && ~axi_bvalid) begin
        if ((awaddr_lat[C_S_AXI_ADDR_WIDTH-1:2] == 8'd56) && S_AXI_WDATA[0])
          clr_pulse_r <= 1'b1;
      end
    end
  end

  // --------------------------
  // CAPTURA de wifi_pack no pulso send_wifi_i
  //   - sync do pulso no clock AXI
  //   - borda ↑
  //   - latch 1792b em buf_r
  //   - flag captured_r (bit2 do status)
  // --------------------------
  reg send_wifi_meta, send_sync_d1, send_sync_d2;
  wire send_rise;

  always @(posedge S_AXI_ACLK) begin
    if (!S_AXI_ARESETN) begin
      send_wifi_meta <= 1'b0;
      send_sync_d1   <= 1'b0;
      send_sync_d2   <= 1'b0;
    end else begin
      send_wifi_meta <= send_wifi_i;
      send_sync_d1   <= send_wifi_meta;
      send_sync_d2   <= send_sync_d1;
    end
  end

  assign send_rise = send_sync_d1 & ~send_sync_d2;

  reg [TOTAL_BITS-1:0] buf_r;
  reg                  captured_r;

  always @(posedge S_AXI_ACLK) begin
    if (!S_AXI_ARESETN) begin
      buf_r      <= {TOTAL_BITS{1'b0}};
      captured_r <= 1'b0;
    end else begin
      if (send_rise) begin
        buf_r      <= data_i;   // captura em UM ciclo
        captured_r <= 1'b1;
      end
      if (clr_pulse_r)
        captured_r <= 1'b0;
    end
  end

  // --------------------------
  // READ: AR handshake e MUX (MSB-first)
  //   words [0..55] = buf_r em ordem MSB→LSB:
  //     0..3 NONCE, 4..5 AD, 6..9 TAG, 10..55 CIPH22..CIPH0
  //   word 56 = STATUS {captured, ready, clr=0}
  // --------------------------
  reg [31:0] rd_mux;
  integer j;
  always @* begin
    rd_mux = 32'd0;
    for (j = 0; j < N_WORDS; j = j + 1) begin
      if (widx_r == j[7:0]) begin
        // MSB-first (alinha com layout do wifi_pack)
        rd_mux = buf_r[TOTAL_BITS-1 - j*32 -: 32];
      end
    end
    if (widx_r == 8'd56)
      rd_mux = {29'd0, captured_r, ready_i, 1'b0};
  end

  always @(posedge S_AXI_ACLK) begin
    if (!S_AXI_ARESETN) begin
      axi_arready <= 1'b0;
      axi_rvalid  <= 1'b0;
      axi_rdata   <= {C_S_AXI_DATA_WIDTH{1'b0}};
    end else begin
      if (~axi_rvalid && S_AXI_ARVALID) begin
        axi_arready <= 1'b1;         // 1 ciclo de ready
        axi_rvalid  <= 1'b1;
        axi_rdata   <= rd_mux;
      end else begin
        axi_arready <= 1'b0;
        if (axi_rvalid && S_AXI_RREADY)
          axi_rvalid <= 1'b0;
      end
    end
  end

endmodule
