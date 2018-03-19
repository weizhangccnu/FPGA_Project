`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CCNU
// Engineer: WeiZhang
// 
// Create Date: 03/16/2018 09:34:02 PM
// Design Name: kc705_mig
// Module Name: kc705_mig
// Project Name: kc705_mig
// Target Devices: KC705 EVB
// Tool Versions: 
// Description: 
// This project is used to learning ddr3 in KC705 EVB
// Dependencies: 
// 
// Revision: V1.0
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module kc705_mig(
input SYS_RST,              //system reset
input SYS_CLK_P,            //system clock 200MHz
input SYS_CLK_N,
input SGMIICLK_Q0_P,        //125MHz for GTP/GTH/GTX  for 1G Ethernet interface
input SGMIICLK_Q0_N,
//----------------------< LED        
output [7:0]LED8Bit,        //clock output
//----------------------< DIPSw4Bit
input  [3:0]DIPSw4Bit,
//----------------------> Gigbit eth interface (RGMII)
output PHY_RESET_N,
output [3:0]RGMII_TXD,
output RGMII_TX_CTL,
output RGMII_TXC,
input  [3:0]RGMII_RXD,
input  RGMII_RX_CTL,
input  RGMII_RXC,
inout  MDIO,
output MDC
);
//---------------------------------------------------------< signal define
wire reset;
wire sys_clk;
wire clk_25MHz;
wire clk_50MHz;
wire clk_100MHz;
wire clk_200MHz;
//---------------------------------------------------------> signal define
//---------------------------------------------------------< global_clock_reset
global_clock_reset global_clock_reset_inst(
    .SYS_CLK_P(SYS_CLK_P),
    .SYS_CLK_N(SYS_CLK_N),
    .FORCE_RST(SYS_RST),
    // output
    .GLOBAL_RST(reset),
    .SYS_CLK(sys_clk),
    .CLK_OUT1(clk_25MHz),
    .CLK_OUT2(clk_50MHz),
    .CLK_OUT3(clk_100MHz),
    .CLK_OUT4("open"),
    .CLK_OUT5(clk_200MHz)
  );
//---------------------------------------------------------> global_clock_reset
//---------------------------------------------------------< generate sgmii_i clock
wire clk_sgmii_i;
wire clk_sgmii;
wire clk_125MHz;
IBUFDS_GTE2 #(
   .CLKCM_CFG("TRUE"),          // Refer to Transceiver User Guide
   .CLKRCV_TRST("TRUE"),        // Refer to Transceiver User Guide
   .CLKSWING_CFG(2'b11)         // Refer to Transceiver User Guide
)
IBUFDS_GTE2_inst (
   .O(clk_sgmii_i),             // 1-bit output: Refer to Transceiver User Guide
   .ODIV2("open"),              // 1-bit output: Refer to Transceiver User Guide
   .CEB(1'b0),                  // 1-bit input: Refer to Transceiver User Guide
   .I(SGMIICLK_Q0_P),           // 1-bit input: Refer to Transceiver User Guide
   .IB(SGMIICLK_Q0_N)           // 1-bit input: Refer to Transceiver User Guide
);

BUFG BUFG_inst (
   .O(clk_sgmii),               // 1-bit output: Clock output
   .I(clk_sgmii_i)              // 1-bit input: Clock input
);
assign clk_125MHz = clk_sgmii;
//---------------------------------------------------------> generate sgmii_i clock
//---------------------------------------------------------< dbg_ila
dbg_ila dbg_ila_inst(
	.clk(clk_25MHz), // input wire clk
	.probe0(counter[3:0]) // input wire [3:0] probe0
);
//---------------------------------------------------------> dbg_ila
//---------------------------------------------------------< vio core
wire [15:0]probe_in0;
wire [31:0]probe_in1;
wire [15:0]probe_out0;
assign probe_in0 = {12'h000,DIPSw4Bit[3:0]};
assign probe_in1 = gig_eth_ipv4_addr;
vio_0 vio_0_inst (
  .clk(clk_25MHz),                // input wire clk
  .probe_in0(probe_in0),    // input wire [15 : 0] probe_in0
  .probe_in1(probe_in1),    // input wire [31 : 0] probe_in1
  .probe_out0(probe_out0)  // output wire [15 : 0] probe_out0
);
//---------------------------------------------------------> vio core
reg [24:0]counter;
wire select;
assign select = probe_out0[0];
always @(posedge clk_125MHz)
begin
    if(reset)
        counter <= 25'd0;
    else
    begin
        counter <= counter + 1'b1; 
        if(counter == 25'h1ffffff)
            counter <= 25'd0;
    end
end
assign LED8Bit[0] = counter[22];
assign LED8Bit[1] = counter[24];
assign LED8Bit[2] = select?counter[22]:counter[24];
assign LED8Bit[3] = select?counter[22]:counter[24];
assign LED8Bit[4] = select?counter[22]:counter[24];
assign LED8Bit[5] = select?counter[22]:counter[24];
assign LED8Bit[6] = select?counter[22]:counter[24];
assign LED8Bit[7] = select?counter[22]:counter[24];
//---------------------------------------------------------< gig_eth 
wire [47:0]gig_eth_mac_addr;
wire [31:0]gig_eth_ipv4_addr;
wire [31:0]gig_eth_subnet_mask;
wire [31:0]gig_eth_gateway_ip_addr; 
wire [7:0]gig_eth_tx_tdata;
wire gig_eth_tx_tvalid;
wire gig_eth_tx_tready;
wire [7:0]gig_eth_rx_tdata;
wire gig_eth_rx_tvalid;
wire gig_eth_rx_tready;
wire gig_eth_tcp_use_fifo;
wire gig_eth_tx_fifo_wrclk;
wire [31:0]gig_eth_tx_fifo_q;
wire gig_eth_tx_fifo_wren;
wire gig_eth_tx_fifo_full;
wire gig_eth_rx_fifo_rdclk;
wire gig_eth_rx_fifo_q;
wire gig_eth_rx_fifo_rden;
wire gig_eth_rx_fifo_empty;

assign gig_eth_mac_addr = {44'h000a3502a75,DIPSw4Bit[3:0]};
assign gig_eth_ipv4_addr = {28'hc0a8020,DIPSw4Bit[3:0]};
assign gig_eth_subnet_mask = 32'hffffff00;
assign gig_eth_gateway_ip_addr = 32'hc0a80201;
//assign gpio_high = 2'b11;
gig_eth gig_eth_inst
(
// asynchronous reset
   .GLBL_RST(reset),
// clocks
   .GTX_CLK(clk_125MHz),
   .REF_CLK(sys_clk), // 200MHz for IODELAY
// PHY interface
   .PHY_RESETN(PHY_RESET_N),
//         -- RGMII Interface
   .RGMII_TXD(RGMII_TXD),
   .RGMII_TX_CTL(RGMII_TX_CTL),
   .RGMII_TXC(RGMII_TXC),
   .RGMII_RXD(RGMII_RXD),
   .RGMII_RX_CTL(RGMII_RX_CTL),
   .RGMII_RXC(RGMII_RXC),
// MDIO Interface
   .MDIO(MDIO),
   .MDC(MDC),
// TCP
//   .MAC_ADDR(48'h000a3502a758),
   .MAC_ADDR(gig_eth_mac_addr),
   .IPv4_ADDR(gig_eth_ipv4_addr),
   .IPv6_ADDR(128'h0),
   .SUBNET_MASK(gig_eth_subnet_mask),
   .GATEWAY_IP_ADDR(gig_eth_gateway_ip_addr),
   .TCP_CONNECTION_RESET(1'b0),
   .TX_TDATA(gig_eth_tx_tdata),
   .TX_TVALID(gig_eth_tx_tvalid),
   .TX_TREADY(gig_eth_tx_tready),
   .RX_TDATA(gig_eth_rx_tdata),
   .RX_TVALID(gig_eth_rx_tvalid),
   .RX_TREADY(gig_eth_rx_tready),
//fifo8to32 and fifo32to8
   .TCP_USE_FIFO(gig_eth_tcp_use_fifo),
   .TX_FIFO_WRCLK(gig_eth_tx_fifo_wrclk),
   .TX_FIFO_Q(gig_eth_tx_fifo_q),
   .TX_FIFO_WREN(gig_eth_tx_fifo_wren),
   .TX_FIFO_FULL(gig_eth_tx_fifo_full),
   .RX_FIFO_RDCLK(gig_eth_rx_fifo_rdclk),
   .RX_FIFO_Q(gig_eth_rx_fifo_q),
   .RX_FIFO_RDEN(gig_eth_rx_fifo_rden),
   .RX_FIFO_EMPTY(gig_eth_rx_fifo_empty)
);
//---------------------------------------------------------> gig_eth
//---------------------------------------------------------< control_interface
wire control_clk;
assign control_clk = clk_100MHz;
//---------------------------------------------------------> control_interface
//---------------------------------------------------------< mig_7series_0
//  mig_7series_0 mig_7series_0_inst (

//  // Memory interface ports
//  .ddr3_addr                      (ddr3_addr),          // output [13:0]        ddr3_addr
//  .ddr3_ba                        (ddr3_ba),            // output [2:0]        ddr3_ba
//  .ddr3_cas_n                     (ddr3_cas_n),         // output            ddr3_cas_n
//  .ddr3_ck_n                      (ddr3_ck_n),          // output [0:0]        ddr3_ck_n
//  .ddr3_ck_p                      (ddr3_ck_p),          // output [0:0]        ddr3_ck_p
//  .ddr3_cke                       (ddr3_cke),           // output [0:0]        ddr3_cke
//  .ddr3_ras_n                     (ddr3_ras_n),         // output            ddr3_ras_n
//  .ddr3_reset_n                   (ddr3_reset_n),       // output            ddr3_reset_n
//  .ddr3_we_n                      (ddr3_we_n),          // output            ddr3_we_n
//  .ddr3_dq                        (ddr3_dq),            // inout [63:0]        ddr3_dq
//  .ddr3_dqs_n                     (ddr3_dqs_n),         // inout [7:0]        ddr3_dqs_n
//  .ddr3_dqs_p                     (ddr3_dqs_p),         // inout [7:0]        ddr3_dqs_p
//  .init_calib_complete            (init_calib_complete),// output            init_calib_complete
    
//  .ddr3_cs_n                      (ddr3_cs_n),          // output [0:0]        ddr3_cs_n
//  .ddr3_dm                        (ddr3_dm),            // output [7:0]        ddr3_dm
//  .ddr3_odt                       (ddr3_odt),           // output [0:0]        ddr3_odt
//  // Application interface ports
//  .app_addr                       (app_addr),           // input [27:0]        app_addr
//  .app_cmd                        (app_cmd),            // input [2:0]        app_cmd
//  .app_en                         (app_en),             // input                app_en
//  .app_wdf_data                   (app_wdf_data),       // input [511:0]        app_wdf_data
//  .app_wdf_end                    (app_wdf_end),        // input                app_wdf_end
//  .app_wdf_wren                   (app_wdf_wren),       // input                app_wdf_wren
//  .app_rd_data                    (app_rd_data),        // output [511:0]        app_rd_data
//  .app_rd_data_end                (app_rd_data_end),    // output            app_rd_data_end
//  .app_rd_data_valid              (app_rd_data_valid),  // output            app_rd_data_valid
//  .app_rdy                        (app_rdy),            // output            app_rdy
//  .app_wdf_rdy                    (app_wdf_rdy),        // output            app_wdf_rdy
//  .app_sr_req                     (app_sr_req),         // input            app_sr_req
//  .app_ref_req                    (app_ref_req),        // input            app_ref_req
//  .app_zq_req                     (app_zq_req),         // input            app_zq_req
//  .app_sr_active                  (app_sr_active),      // output            app_sr_active
//  .app_ref_ack                    (app_ref_ack),        // output            app_ref_ack
//  .app_zq_ack                     (app_zq_ack),         // output            app_zq_ack
//  .ui_clk                         (ui_clk),             // output            ui_clk
//  .ui_clk_sync_rst                (ui_clk_sync_rst),    // output            ui_clk_sync_rst
//  .app_wdf_mask                   (app_wdf_mask),       // input [63:0]        app_wdf_mask
//  // System Clock Ports
//  .sys_clk_i                      (sys_clk_i),
//  // Reference Clock Ports
//  .clk_ref_i                      (clk_ref_i),
//  .sys_rst                        (sys_rst)             // input sys_rst
//  );
//---------------------------------------------------------> mig_7series_0
endmodule
