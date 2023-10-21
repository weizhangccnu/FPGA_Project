`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Wuhan Textile University
// Engineer: Wei Zhang
// 
// Create Date: 2023/10/14 20:26:35
// Design Name: mic5 serdes
// Module Name: mic5_serdes
// Project Name: mic5 serdes
// Target Devices: KC705 FPGA
// Tool Versions: vivado 2019.2
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mic5_serdes(
input SYS_RST,              //system reset
input SYS_CLK_P,            //system clock 200MHz
input SYS_CLK_N,

//---------------------< GTX
input Q2_CLK1_GTREFCLK_PAD_N_IN,
input Q2_CLK1_GTREFCLK_PAD_P_IN,
input RXN_IN,
input RXP_IN,
output TXN_OUT,
output TXP_OUT 
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

//---------------------------------------------------------> GTX
wire gt0_txusrclk2_i;
reg [79:0] gt0_txdata_i;
wire gt0_rxusrclk2_i;
wire [79:0] gt0_rxdata_i;

gtwizard_0_exdes gtwizard_0_exdes_inst(
    .Q2_CLK1_GTREFCLK_PAD_N_IN(Q2_CLK1_GTREFCLK_PAD_N_IN),
    .Q2_CLK1_GTREFCLK_PAD_P_IN(Q2_CLK1_GTREFCLK_PAD_P_IN),
    .DRPCLK_IN(clk_100MHz),
    .TRACK_DATA_OUT("open"),
    .RXN_IN(RXN_IN),
    .RXP_IN(RXP_IN),
    .TXN_OUT(TXN_OUT),
    .TXP_OUT(TXP_OUT),
    .gt0_rxdata_i(gt0_rxdata_i),
    .gt0_txdata_i(gt0_txdata_i),
    .gt0_rxusrclk2_i(gt0_rxusrclk2_i),
    .gt0_txusrclk2_i(gt0_txusrclk2_i)
);      
//---------------------------------------------------------< GTX

//---------------------------------------------------------< Data Send  
reg [1:0] count;
wire [95:0] data_96B;
wire [119:0] data_120B;
reg [87:0] cnt;
assign data_96B = {8'hbc, cnt};

always @(posedge gt0_txusrclk2_i or posedge reset)
begin
    if(reset)
    begin
        count <= 2'b00;
        cnt <= 88'd0;
    end
    else
    begin
        count <= count + 1'b1;
        gt0_txdata_i <= data_120B[(39+count*40)-:40];
        if(count == 2'b10)
        begin
            cnt <= cnt + 1'b1;
            count <= 2'b00;
        end
    end
end

//---------------------------------------------------------> Data Send  

//---------------------------------------------------------< Data 96B to 120B
Data_96Bto120B Data_96Bto120B_inst(
    .clk(gt0_txusrclk2_i),                     // input clock, clock_div3
    .reset(reset),                      // reset, high active
    .data_96b(data_96B),                // 96bit input data
    .data_120b(data_120B)               // 120bit output data
    );
//---------------------------------------------------------< Data 96B to 120B

//---------------------------------------------------------< header alignment 
wire [109:0] received_data;
wire [9:0] header;
header_alignment header_alignment_inst(
    .clk(gt0_rxusrclk2_i),                  // input clock 20 MHz
    .rstn(!reset),                           // system reset, low active
    .frame_data(gt0_rxdata_i),              // input data 64-bit
    .header(header),                        // header 0xBC
    .received_data(received_data)           // received data 48-bit
);
//---------------------------------------------------------> header alignment

//---------------------------------------------------------< Data 110B to 88B
wire [87:0] data_88B;
Data_110Bto88B Data_110Bto88B_inst(
    .clk(gt0_rxusrclk2_i),                      // input clock, clock_div3
    .reset(reset),                              // reset, high active
    .data_110b(received_data),                  // 96bit input data
    .data_88b(data_88B)                         // 120bit output data
    );
//---------------------------------------------------------< Data 110B to 88B

//---------------------------------------------------------< ila
wire [87:0] probe0;
wire [9:0] probe1;
wire [109:0] probe2;
wire [39:0] probe3;
wire [39:0] probe4;
wire probe5;
wire [1:0] probe6;
wire [119:0] probe7;
wire [87:0] probe8;

ila_0 ila_0_inst (
	.clk(clk_100MHz),          // input wire clk
	.probe0(probe0),           // input wire [87:0]  probe0  
	.probe1(probe1),           // input wire [9:0]  probe1 
	.probe2(probe2),           // input wire [109:0]  probe2 
	.probe3(probe3),           // input wire [39:0]  probe3 
	.probe4(probe4),           // input wire [39:0]  probe4 
	.probe5(probe5),           // input wire [0:0]  probe5 
	.probe6(probe6),           // input wire [1:0]  probe6 
	.probe7(probe7),           // input wire [119:0]  probe7 
	.probe8(probe8)            // input wire [87:0]  probe8
);

assign probe8 = cnt;
assign probe7 = data_120B;
assign probe6 = count;
assign probe5 = gt0_txusrclk2_i;
assign probe4 = gt0_rxdata_i;
assign probe3 = gt0_txdata_i;
assign probe2 = received_data;
assign probe1 = header;
assign probe0 = data_88B;
//---------------------------------------------------------< ila
endmodule

