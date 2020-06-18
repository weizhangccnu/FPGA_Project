/**
 *
 *  file: TOT_fineEncoder.v
 *
 *  TOT_fineEncoder.v
 *  Encode the fine phase from 21 bits therometer code to 7 bits binary code
 *
 *  History:
 * 	2020/04/30 Wei Zhang	 : revised and verified for ETROC2 TDC
 **/
`timescale 1ns/1ps

module TOT_fineEncoder(
	input [20:0] encode_In,				// 21-bit thermometer code from TOA sample DFFs
	input [1:0] level,					// Bubble tolerance, proper values of level = 1, 2, 3
	output [5:0] Binary_Out,			// 6-bit binary output code
	output errorFlag					// bubble Error
);

wire [20:0] Data;
/**************************************************************************/
//Raw data to one-hot code
/**************************************************************************/
genvar gi;
generate
for(gi = 0; gi < 21; gi=gi+1) begin : XNOR2LOOP
	assign Data[gi] = encode_In[gi]~^encode_In[(gi+20)%21];
end
endgenerate

/**************************************************************************/
//wire [5:0]Binary_Out1;
TOT_fineEncoder_core TOT_fineEncoder_core_tt(
	.encode_In(Data),
	.level(level),
	.errorFlag(errorFlag),
	.Binary_Out(Binary_Out[4:0])
);

assign Binary_Out[5] = ~encode_In[20];
//assign Binary_Out = Binary_Out1[5]?(Binary_Out1-4'b1011):Binary_Out1;
//assign Binary_Out = Binary_Out1;

endmodule

