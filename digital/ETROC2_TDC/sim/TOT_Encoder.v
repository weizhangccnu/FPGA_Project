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
`timescale 1ps/100fs

module TOT_Encoder
(
	input [20:0] A,			//input fine time DFFs
	input [1:0] level, 		//user defined error tolerance.
    input [2:0] counterA, 	//ripple Counter A at tap 31 with positive input
    input [2:0] counterB, 	//ripple Counter B at tap 31 with negative input
	input [6:0] offset,  	//user defined offset, default is 0
    output[2:0] outputCoarsePhase, 	//coarse phase
    output [5:0] outputFinePhase, 	//output fine phase code
	output errorFlag
);
	wire [5:0] correctedfinePhase, finePhase; //fine phase code from finePhaseEncoder
    wire selA;
	wire [2:0] correctedCoarsePhase,rawCoarsePhase;
	wire [8:0] correctedcombinedCode,combinedCode;

TOT_fineEncoder U_fineEnc(
	.encode_In(A),
	.level(level),
	.Binary_Out(finePhase),
	.errorFlag(errorFlag)
);
assign correctedfinePhase = (finePhase[5]==1'b1)?(finePhase-4'b1011):finePhase;
assign selA = (offset+correctedfinePhase)%42>21;
assign rawCoarsePhase  = (selA==1'b1)?counterA:counterB;
assign correctedCoarsePhase = (selA==1'b1)?rawCoarsePhase-1:rawCoarsePhase;
assign combinedCode = {correctedCoarsePhase,correctedfinePhase};
assign correctedcombinedCode = combinedCode - correctedCoarsePhase*5'b10110;
assign outputFinePhase = correctedcombinedCode[5:0]; //corrected fine phase or raw code
assign outputCoarsePhase = correctedcombinedCode[8:6]; //corrected coarse phase or raw code
endmodule

