/**
 *
 *  file: TOT_fineEncoder_core.v
 *
 *  TOT_fineEncoder_core
 *  Encode the fine phase from 21 bits therometer code to 5 bits binary code
 *
 *  History:
 *  2020/05/1 Wei Zhang	 : Create and verified ETROC2 TDC
 **/
`timescale 1ns/1ps

module TOA_Latch(
	input TOA_Latch,						// TOA data latch clock
	input [62:0] TOA_Fine_In,				// TOA fine phase data input 
	input [2:0] TOA_CntA_In,				// TOA ripple counter A data input
	input [2:0] TOA_CntB_In,				// TOA ripple counter B data input
	output reg [62:0] TOA_Fine_Out,			// TOA fine phase data output
	output reg [2:0] TOA_CntA_Out,			// TOA ripple counter A data output
	output reg [2:0] TOA_CntB_Out			// TOA ripple counter B data output
);

always @(posedge TOA_Latch)
begin
	TOA_Fine_Out <= TOA_Fine_In;
	TOA_CntA_Out <= TOA_CntA_In;
	TOA_CntB_Out <= TOA_CntB_In;
end

endmodule

