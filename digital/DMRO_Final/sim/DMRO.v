//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL&SMU
// Author:      Quan Sun
// 
// Create Date:    Mon Feb 18 14:59 CST 2019
// Design Name:    ETROC1 
// Module Name:    DMRO
// Project Name: 
// Description: Diagnostic Mode Readout Module
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ps/1fs
`define header 2'b10
module DMRO(
	CLKBit,
        CLKWord,
	RSTn,
	REVData,
	REVCLK,
	ENScr,
	TestMode,
	DataIn,
	DataOut
);

input CLKBit;          //input clock at 1.28 GHz
input CLKWord;         //input clock at 40 MHz, this clock is only used to sychronize the input data by controling the release of the reset.
input RSTn;
input REVData;		//reverse input data in bit-wise, active-high
input REVCLK;		//reverse word clock, active-high. input data can be latched correctly at least in one clock phase
input ENScr;		//enable Scrambler, active-high
input TestMode;		//sending PRBS7 in test mode(TestMode == 1)
input [29:0] DataIn;
//input [1:0] Header;	//2-bit header
output DataOut;

//reg [29:0] In_reg;
wire [29:0] In_reg;
//wire [4:0] Load;
wire [29:0] DataScrambled;
wire [31:0] DataPRBS7;
wire [31:0] DatatobeSent;
reg rst_int;
wire DOBuf;
wire CLKWordINT;
//wire CLKWordPRBS7;
//wire CLKWordScr;
wire CLKWordRST;

//assign CLKWordPRBS7 = TestMode?CLKWordINT:0;
//assign CLKWordScr = (!TestMode)?CLKWordINT:0;
assign CLKWordRST = REVCLK?~CLKWord:CLKWord;

assign DataOut = DOBuf;
assign DatatobeSent = TestMode?DataPRBS7:{`header,DataScrambled};

//always@(negedge RSTn or posedge CLKBit) begin
always@(negedge RSTn or posedge CLKWordRST) begin
if(!RSTn)
	rst_int <= 0;
else
	rst_int <= 1;
end

/*
always@(negedge rst_int or posedge CLKWord) begin
if(!rst_int)		
	In_reg <= 0;
else begin
	In_reg <= DataIn;
end
end
*/

assign In_reg = DataIn;

SCR30b INS_SCR30b(
	.CLK(CLKWordINT),
	.RSTn(rst_int),
	.DataIn(In_reg),
	.REV(REVData),
	.EN(ENScr),
	.DataOut(DataScrambled)
);

SER32b INS_SER32b(
	.CLKBit(CLKBit),
	.RSTn(rst_int),
	.DataIn(DatatobeSent),
	.CLKWord(CLKWordINT),
	.DataOut(DOBuf)
);

PRBS7Gen32b INS_PRBS7Gen32b(
    .CLK(CLKWordINT),	
    .RSTn(rst_int),	
    .dataOutA(DataPRBS7)
    );



endmodule
