//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL/SMU
// Author:      Quan Sun
// 
// Create Date:    Mon Jul 8th 17:18 CST 2019
// Design Name:    ETROC1 
// Module Name:    ROCtrl
// Project Name: 
// Description: Testbench of ROCtrl
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ps/100fs
`define clk_period 12500
module ROCtrl_tb;
reg clock;
reg RO_SEL;
reg [1:0] DMRO_COL;
reg [29:0] DataDMRO0, DataDMRO1, DataDMRO2, DataDMRO3, DataSRO;
wire [29:0] DataOut;

initial begin
clock = 0;
RO_SEL = 0;
DMRO_COL = 0;
DataDMRO0 = 0;
DataDMRO1 = 2000;
DataDMRO2 = 4000;
DataDMRO3 = 8000;
DataSRO = 20000;
#300000
DMRO_COL = 1;
#300000
DMRO_COL = 2;
#300000
DMRO_COL = 3;
#300000
DMRO_COL = 0;
#300000
DMRO_COL = 1;
#300000
RO_SEL = 1;
#300000
$finish();
end

always #(`clk_period) clock = ~clock;
always @(posedge clock) begin
	DataDMRO0 <= DataDMRO0 + 3;
	DataDMRO1 <= DataDMRO1 + 3;
	DataDMRO2 <= DataDMRO2 + 3;
	DataDMRO3 <= DataDMRO3 + 3;
	DataSRO <= DataSRO + 3;
end

ROCtrl INS_ROCtrl(
	.RO_SEL(RO_SEL),
	.DMRO_COL(DMRO_COL),
	.DataDMRO0(DataDMRO0),
	.DataDMRO1(DataDMRO1),
	.DataDMRO2(DataDMRO2),
	.DataDMRO3(DataDMRO3),
	.DataSRO(DataSRO),
	.DataOut(DataOut)	
);

endmodule
