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


//module XNOR2(input A,input B,output Out);
/************generated by NAND and NOT*************/
//wire NA,NB;
//wire[1:0] NAND;
//not U1 (NA,A);
//not U2 (NB,B);
//nand U3 (NAND[0],A,B);
//nand U4 (NAND[1],NA,NB);
//nand U5 (Out,NAND[1],NAND[0]);
//endmodule



//module XOR2(input A,input B,output Out);
/************generated by NAND*************/
//wire[2:0] NAND;
//nand U0 (NAND[0],A,B);
//nand U1 (NAND[1],A,NAND[0]);
//nand U2 (NAND[2],NAND[0],B);
//nand U3 (Out,NAND[1],NAND[2]);
//endmodule


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
//XNOR2 U0( .A(encode_In[0]), .B(encode_In[31]), .Out(Data[0]) );
assign Data[0] = encode_In[0]~^encode_In[31];

genvar gi;
generate
for(gi = 1; gi < 32; gi=gi+1) begin : XOR2LOOP
//XOR2 UXOR2(encode_In[gi], encode_In[gi-1],Data[gi]);
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

