/**
 *
 *  file: Ripple_Counter_tb.v
 *
 *  Ripple Counter testbench: Test the ripple counter
 *
 *  History:
 *  2019/03/12 Datao, Wei Zhang    : Created for ETROC2 TDC
 **/
`timescale 1ns/1ps
//********* Module Declaration *********//
module Ripple_Counter_tb;

//********* Signals Declaration *********//
reg Clk_In;						// ripple counter driver clock
reg RSTN;						// Reset signal, falling edge active
reg TOA_Clk;					// TOA latch clock
reg TOT_Clk;					// TOT latch clock

wire [2:0] TOA_CntA;			// TOA ripple counter A
wire [2:0] TOA_CntB;			// TOA ripple counter B
wire [2:0] TOT_CntA;			// TOT ripple counter A
wire [2:0] TOT_CntB;			// TOT ripple counter B

Ripple_Counter Ripple_Counter_tt
(
.Clk_In(Clk_In),
.RSTN(RSTN),
.TOA_Clk(TOA_Clk),
.TOT_Clk(TOT_Clk),
.TOA_CntA(TOA_CntA),
.TOA_CntB(TOA_CntB),
.TOT_CntA(TOT_CntA),
.TOT_CntB(TOT_CntB)	
);

//********* Provide Stimulus *********//
initial begin
	Clk_In = 1'b0;
	RSTN = 1'b1;
	TOA_Clk = 1'b0;
	TOT_Clk = 1'b0;
	#500 RSTN = 1'b0;
	#500 RSTN = 1'b1;
	#200 TOA_Clk = 1'b1;
	#100 TOT_Clk = 1'b1;
	#100 TOA_Clk = 1'b0;
	#100 TOT_Clk = 1'b0;
	#200 TOA_Clk = 1'b1;
	#100 TOT_Clk = 1'b1;
	#5000 $stop;
	
end
always begin
	#30 Clk_In = ~Clk_In;
end


endmodule
