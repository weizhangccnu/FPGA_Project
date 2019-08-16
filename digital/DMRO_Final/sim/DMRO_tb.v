//////////////////////////////////////////////////////////////////////////////////
// Org:    	FNAL&SMU
// Author:	Quan Sun
// 
// Create Date:    Mon Feb 18 16:24 CST 2019
// Design Name:    ETROC1 
// Module Name:    DMRO_tb 
// Project Name: 
// Description: testbench of the DMRO
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ps/1fs
//`define header 2'b10
`define clk_period 400
//`define DataOffset 11
`define AligOffset 17		// reverse_clock = 1
//`define AligOffset 1		// reverse_clock = 0
`define AligOffsetWordNormal 3	
`define AligOffsetWordTest 3
module DMRO_tb;
reg clk_bit;
wire clk_word;
reg reset;
reg [29:0] DataIn;
reg [4:0] counter;
wire DataOut;
reg [31:0] WordREC;
wire [29:0] DataREC;
reg [63:0] DataSteamREC;
reg test_mode;
reg reverse_data;
reg ena_scram;
reg reverse_clock;
wire [29:0] DataBeforeDESCR;
wire [29:0] DataAfterDESCR;


initial begin
reset = 1;
clk_bit = 0;
test_mode = 0;
reverse_data = 0;
ena_scram = 1;
reverse_clock = 1;
#10000
reset = 0;
DataIn = 0;
#40000
reset = 1;

#10000000
$finish();
end

always #(`clk_period) clk_bit = ~clk_bit;

assign DataBeforeDESCR = WordREC[29:0];

assign clk_word = counter[4];
always@(negedge reset or posedge clk_bit) begin
if(!reset)		
	counter[4:0] <= `AligOffset;
else begin
	counter[4:0] <= counter[4:0] - 1;
end
end



always@(negedge reset or posedge clk_word) begin
if(!reset)
	DataIn <= 0;
else
	//DataIn <= DataIn;
	DataIn <= DataIn + 1;
end

DMRO INS_DMRO(
	.CLKBit(clk_bit),
        .CLKWord(clk_word),
	.RSTn(reset),
	.REVData(reverse_data),
	.REVCLK(reverse_clock),
	.ENScr(ena_scram),
	.TestMode(test_mode),
	.DataIn(DataIn),
	.DataOut(DataOut)
	);


DESCR30b DESCR30b_Ins(
	.CLK(clk_word),
	.RSTn(reset),
	.DataIn(DataBeforeDESCR),
	.REV(reverse_data),
	.DataOut(DataAfterDESCR)
);

wire [31:0] GoldenPRBS7;

PRBS7Gen32b INS_PRBS7Gen32b(
    .CLK(clk_word),	
    .RSTn(reset),	
    .dataOutA(GoldenPRBS7)
    );


always@(negedge reset or posedge clk_bit) begin
if(!reset)		
	DataSteamREC[63:0] <= 0;
else begin
	DataSteamREC[63:0] <= {DataSteamREC[62:0], DataOut};
end
end

//assign WordREC = DataSteamREC[31:0];

always@(negedge reset or posedge clk_word) begin
if(!reset)
	WordREC <= 0;
else
	WordREC[31:0] <= DataSteamREC[`AligOffset+31:`AligOffset];
end

assign DataREC = DataAfterDESCR;

////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////          for normal mode check    //////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
reg[29:0] MEMDataSent30[1023:0];			//sent data
reg[29:0] MEMDataRec30[1023:0];			//received data
reg[15:0] CLKWordCNTChecking = 0;				// Counter for synchronizing data checking
reg ErrorFlag;					//ErrorFlag == 1 --> error
reg[29:0] ErrData30;

always@(negedge reset or posedge clk_word) begin
	if(!reset)
		CLKWordCNTChecking <= 0;
	else
		CLKWordCNTChecking <= CLKWordCNTChecking + 1;
end

always@(negedge reset or posedge clk_word) begin
	MEMDataSent30[CLKWordCNTChecking] <= DataIn;
	MEMDataRec30[CLKWordCNTChecking] <= DataREC;
	if(MEMDataSent30[CLKWordCNTChecking - 1 - `AligOffsetWordNormal] == MEMDataRec30[CLKWordCNTChecking - 1]) begin
		ErrorFlag <= 0;
		ErrData30 <= MEMDataSent30[CLKWordCNTChecking - 1 - `AligOffsetWordNormal] ^ MEMDataRec30[CLKWordCNTChecking - 1];
	end
	else begin
		ErrorFlag <= 1;
		ErrData30 <= MEMDataSent30[CLKWordCNTChecking - 1 - `AligOffsetWordNormal] ^ MEMDataRec30[CLKWordCNTChecking - 1];
	end
end


////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////          for test mode check    //////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
reg[31:0] MEMGoldenPRBS7[1023:0];			//golden prbs 7
reg[31:0] MEMDataRec32[1023:0];			//received data
reg ErrorFlagTestMode;					//ErrorFlagTestMode == 1 --> error
reg[31:0] ErrData32;

always@(negedge reset or posedge clk_word) begin
	MEMGoldenPRBS7[CLKWordCNTChecking] <= GoldenPRBS7;
	MEMDataRec32[CLKWordCNTChecking] <= WordREC;
	if(MEMGoldenPRBS7[CLKWordCNTChecking - 1 - `AligOffsetWordTest] == MEMDataRec32[CLKWordCNTChecking - 1]) begin
		ErrorFlagTestMode <= 0;
		ErrData32 <= MEMGoldenPRBS7[CLKWordCNTChecking - 1 - `AligOffsetWordTest] ^ MEMDataRec32[CLKWordCNTChecking - 1];
	end
	else begin
		ErrorFlagTestMode <= 1;
		ErrData32 <= MEMGoldenPRBS7[CLKWordCNTChecking - 1 - `AligOffsetWordTest] ^ MEMDataRec32[CLKWordCNTChecking - 1];
	end
end



endmodule
