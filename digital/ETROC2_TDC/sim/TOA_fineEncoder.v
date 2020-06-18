/**
 *
 *  file: TOA_fineEncoder.v
 *
 *  TOA_fineEncoder.v
 *  Encode the fine phase from 63 bits therometer code to 7 bits binary code
 *
 *  History:
 *  2019/03/07 Hanhan Sun    : Revised and verified
 *  2019/08/01 Datao Gong    : Output bubble errors
 * 	2020/05/27 Wei Zhang	 : revise level from 3-bit to 2-bit
 **/

`timescale 1ns/1ps 

module TOA_fineEncoder(
   	input [62:0] encode_In,  	//63-bit thermometer code from TOA sample DFFs
    input [1:0] level,       	//Fault tolerance, proper values of level ={1,2,3}
	output [1:0] bubbleError,	// 2-bit bubble error for testing
    output [6:0] Binary_Out 	//7-bit binary output code 
);

wire[62:0] Data; 

/*************************************/  
// Data[n]=  encode_In[n] ^~ encode_In[(n+62)%63];
// Data[0]=  encode_In[0] ^~ encode_In[62];
/*************************************/ 
genvar gi;
generate
for(gi = 0; gi < 63; gi=gi+1) begin : XNOR2LOOP
	assign Data[gi] = encode_In[gi]~^encode_In[(gi+62)%63];
end
endgenerate


/*************************************/  	
TOA_fineEncoder_core TOA_fineEncoder_core_tt(
	.encode_In(Data),
	.level(level),
	.bubbleError(bubbleError),
	.Binary_Out(Binary_Out[5:0]) 
);

assign Binary_Out[6] = ~encode_In[62];

endmodule

