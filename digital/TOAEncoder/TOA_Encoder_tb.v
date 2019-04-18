//testbench TOA_Encoder
//Auther: Wei Zhang
//Date: April 16, 2019
//Address: SMU Dallas TX.

`timescale 1ns / 1ps

module TOA_Encoder_tb(

);
reg [62:0] TOARaw;
reg [2:0] TOACntA;
reg [2:0] TOACntB;

wire [2:0] outputCoarsePhase;
wire [6:0] outputFinePhase;
wire errorFlag;

integer level = 3'b001;
integer offset = 7'b000_0000;
integer selRawCode = 1'b0;

//====================================================================//
initial begin

	TOARaw = 63'b010_1010_1010_1101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101;
	TOACntA = 3'b010;
	TOACntB = 3'b000;
	#1000;
	TOARaw = 63'b010_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101;
	TOACntA = 3'b010;
	TOACntB = 3'b010;
	#1000 $stop;
end

TOA_Encoder TOA_Encoder_tt(
.A(TOARaw),
.level(level),
.counterA(TOACntA),
.counterB(TOACntB),
.offset(offset),
.selRawCode(selRawCode),
.outputCoarsePhase(outputCoarsePhase),
.outputFinePhase(outputFinePhase),
.errorFlag(errorFlag)
);
endmodule
