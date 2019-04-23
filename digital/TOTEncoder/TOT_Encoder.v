/**
 *
 *  file: TOT_Encoder.v
 *
 *  TOT_Encoder
 *  Encode the phase information based on two counters and fine phase.
 *
 *  History:
 *  2019/03/13 Datao Gong    : Created
 *
 **/
`timescale 1ns/1ps

module TOT_Encoder
(
	input [31:0] A,//input DFFs
	input [2:0] level, //user defined error tolerance.
    input [2:0] counterA, //ripple Counter A at tap 31 with positive input
    input [2:0] counterB, //ripple Counter B at tap 31 with negative input
	input [5:0] offset,  //user defined offset, default is 0
	input selRawCode,//output corrected code or raw code, defined by user
    output[2:0] outputCoarsePhase, //coarse phase
    output [5:0] outputFinePhase, //output fine phase code
	output errorFlag
);
	wire [5:0] finePhase; //fine phase code from finePhaseEncoder
    wire selA;
	wire [2:0]correctedCoarsePhase,rawCoarsePhase;
	wire [8:0]combinedCode;

	TOT_fineEncoder U_fineEnc(.encode_In(A),.level(level),.Binary_Out(finePhase),.errorFlag(errorFlag));
	
	assign selA = (offset+finePhase)%64>31;
	assign rawCoarsePhase = (selA==1'b1)?counterA:counterB;
	assign correctedCoarsePhase = (selA==1'b1)?rawCoarsePhase-1:rawCoarsePhase;
	assign combinedCode = {correctedCoarsePhase,finePhase};
	assign outputFinePhase = (selRawCode == 1'b1)?finePhase:combinedCode[5:0]; //corrected fine phase or raw code
	assign outputCoarsePhase = (selRawCode == 1'b1)?rawCoarsePhase:combinedCode[8:6]; //corrected coarse phase or raw code
endmodule

