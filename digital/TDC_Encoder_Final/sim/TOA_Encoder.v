/**
 *
 *  file: TOA_Encoder.v
 *
 *  TOA_Encoder
 *  Encode the phase information based on two counters and fine phase.
 *
 *  History:
 *  2019/03/12 Datao Gong    : Created
 *  2019/08/01 Datao Gong    : Output bubble errors
 **/
`timescale 1ns/1ps

module TOA_Encoder
(
	input [62:0] A,//input DFFs
	input [2:0] level, //user defined error tolerance.
    input [2:0] counterA, //ripple Counter A at tap 31 with positive input
    input [2:0] counterB, //ripple Counter B at tap 31 with negative input
	input [6:0] offset,  //user defined offset, default is 0
	input selRawCode,//output corrected code or raw code, defined by user
    output[2:0] outputCoarsePhase, //coarse phase
    output [6:0] outputFinePhase, //output fine phase code
	output [1:0] bubbleError, //bubble error occurred
	output errorFlag
);
	wire [6:0] finePhase; //fine phase code from finePhaseEncoder
    wire selA;
	wire [2:0]correctedCoarsePhase,rawCoarsePhase;
	wire [9:0]combinedCode;
	
	TOA_fineEncoder U_fineEnc(.encode_In(A),.level(level),.bubbleError(bubbleError),.Binary_Out(finePhase));

	assign errorFlag = (finePhase[5:0] == 6'b111111);
	assign selA = (offset+finePhase)%127>62;
	assign rawCoarsePhase = (selA==1'b1)?counterA:counterB;
	assign correctedCoarsePhase = (selA==1'b1)?rawCoarsePhase-1:rawCoarsePhase;
	assign combinedCode = {correctedCoarsePhase,finePhase}-{correctedCoarsePhase,finePhase[6]};
	assign outputFinePhase = (selRawCode == 1'b1)?finePhase:combinedCode[6:0]; //corrected fine phase or raw code
	assign outputCoarsePhase = (selRawCode == 1'b1)?rawCoarsePhase:combinedCode[9:7]; //corrected coarse phase or raw code

endmodule

