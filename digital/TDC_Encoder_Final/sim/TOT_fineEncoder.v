/**
 *
 *  file: TOT_fineEncoder.v
 *
 *  TOT_fineEncoder.v
 *  Encode the fine phase from 32 bits therometer code to 6 bits binary code
 *
 *  History:
 *  2019/03/07 Hanhan Sun    : Created
 **/
`timescale 1ns/1ps


module TOT_fineEncoder
(
 encode_In,level,Binary_Out,errorFlag  
);
    input [31:0] encode_In;  //32-bit thermometer code from TOT sample DFFs
    input [2:0] level;       //Fault tolerance, proper values of level ={1,2,3}
    output[5:0] Binary_Out;  //6-bit binary output code 
    output errorFlag;        //error flag
    wire[31:0] Data; 



/*************************************/  
// Data[0]=  encode_In[0] ^~ encode_In[31];
// Data[n]=  encode_In[n] ^ encode_In[n-1], n=1~31
/*************************************/ 
assign Data[0] = encode_In[0]~^encode_In[31];

genvar gi;
generate
for(gi = 1; gi < 32; gi=gi+1) begin : XOR2LOOP
	assign Data[gi] = encode_In[gi]^encode_In[gi-1];
end
endgenerate

/*************************************/  	
TOT_fineEncoder_core Encoder1
(
	.encode_In(Data),
	.level(level),
	.Binary_Out(Binary_Out[4:0]),
	.errorFlag(errorFlag) 
);

assign Binary_Out[5]= !(encode_In[31]);

endmodule

