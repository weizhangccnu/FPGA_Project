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
output [7:0]LED8Bit         //clock output
    );
//---------------------------------------------------------< signal define
wire reset;
wire sys_clk;
wire clk_25MHz;
wire clk_50MHz;
wire clk_100MHz;
wire clk_125MHz;
wire clk_200MHz;
wire clk_sgmii_i;
wire clk_sgmii;
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
reg [23:0]counter;
always @(posedge clk_125MHz)
begin
    if(reset)
        counter <= 24'd0;
    else
    begin
        counter <= counter + 1'b1; 
        if(counter == 24'h7fffff)
            counter <= 24'd0;
    end
end
assign LED8Bit[0] = counter[22];
assign LED8Bit[1] = counter[22];
assign LED8Bit[2] = counter[22];
assign LED8Bit[3] = counter[22];
assign LED8Bit[4] = counter[22];
assign LED8Bit[5] = counter[22];
assign LED8Bit[6] = counter[22];
assign LED8Bit[7] = counter[22];
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
