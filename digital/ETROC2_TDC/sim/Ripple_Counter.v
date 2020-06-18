/**
 *
 *  file: Ripple_Counter.v
 *
 *  Ripple Counter: Recording the coarse phase of TOA, TOT, and Cal
 *
 *  History:
 *  2019/03/12 Datao, Wei Zhang    : Created for ETROC2 TDC
 **/
`timescale 1ns/1ps
/*****************************************************************************/
module dff(
	input D,
	input CLK,
	input RSTN,
	output reg Q,
	output	QN
);
always @(posedge CLK or negedge RSTN)
begin
	if(!RSTN)
		Q <= 1'b0;
	else
		Q <= D;
end

assign QN = ~Q;
endmodule

/*****************************************************************************/
module Ripple_Counter(
	input Clk_In,				// ripple counter driver clock
	input RSTN,					// Reset signal
	input TOA_Clk,				// TOA coarse phase latch clock
	input TOT_Clk,				// TOT coarse phase latch clock
	output reg [2:0] TOA_CntA,		// TOA coarse phase counter A
	output reg [2:0] TOA_CntB,		// TOA coarse phase counter B
	output reg [2:0] TOT_CntA,		// TOT coarse phase counter A
	output reg [2:0] TOT_CntB		// TOA coarse phase counter B
);

wire [2:0] CntA;
wire [2:0] CntNA;
wire [2:0] CntB;
wire [2:0] CntNB;

/*****************************************************************************/
wire Clk_In_Bar;
assign Clk_In_Bar = ~Clk_In;

dff dff0(						// first stage dff for Ripple Counter A
	.D(CntNA[0]),
	.CLK(Clk_In),
	.RSTN(RSTN),
	.Q(CntA[0]),
	.QN(CntNA[0])
);

dff dff1(						// second stage dff for Ripple Counter A
	.D(CntNA[1]),
	.CLK(CntNA[0]),
	.RSTN(RSTN),
	.Q(CntA[1]),
	.QN(CntNA[1])
);

dff dff2(						// third stage dff for Ripple Counter A
	.D(CntNA[2]),
	.CLK(CntNA[1]),
	.RSTN(RSTN),
	.Q(CntA[2]),
	.QN(CntNA[2])
);


dff dff3(						// first stage dff for Ripple Counter B
	.D(CntNB[0]),
	.CLK(Clk_In_Bar),
	.RSTN(RSTN),
	.Q(CntB[0]),
	.QN(CntNB[0])
);

dff dff4(						// second stage dff for Ripple Counter B
	.D(CntNB[1]),
	.CLK(CntNB[0]),
	.RSTN(RSTN),
	.Q(CntB[1]),
	.QN(CntNB[1])
);

dff dff5(						// third stage dff for Ripple Counter B
	.D(CntNB[2]),
	.CLK(CntNB[1]),
	.RSTN(RSTN),
	.Q(CntB[2]),
	.QN(CntNB[2])
);
/*****************************************************************************/
//TOA coarse phase snapshot
always @(posedge TOA_Clk)
begin
	TOA_CntA <= CntA;
	TOA_CntB <= CntB;
end

//TOT coarse phase snapshot
always @(posedge TOT_Clk)
begin
	TOT_CntA <= CntA;
	TOT_CntB <= CntB;
end

endmodule

