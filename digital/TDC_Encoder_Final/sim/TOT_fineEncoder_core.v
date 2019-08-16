/**
 *
 *  file: TOT_fineEncoder_core.v
 *
 *  TOT_fineEncoder_core
 *  Encode the fine phase from 32 bits therometer code to 6 bits binary code
 *
 *  History:
 *  2019/03/07 Hanhan Sun    : Created
 *
 **/
`timescale 1ns/1ps


module OR32(input [31:0] A, output [3:0] ORA, output [3:0] ORB);
wire OR4A[7:0];

genvar gi;
generate
for(gi = 0; gi < 8; gi=gi+1) begin : OR4LOOP
assign OR4A[gi] = A[gi*4]|A[gi*4+1]|A[gi*4+2]|A[gi*4+3];
end
endgenerate

generate
for(gi = 0; gi < 4; gi=gi+1) begin : OR2LOOP
assign ORA[gi] = OR4A[gi*2]|OR4A[gi*2+1];
assign ORB[gi] = OR4A[(gi*2+1)%8]|OR4A[(gi*2+2)%8];
end
endgenerate

endmodule
 
module TOT_fineEncoder_core
(
    input [31:0] encode_In,
    input [2:0] level,//proper values of level ={1,2,3}
    output[4:0] Binary_Out,
    output errorFlag
);

/*************************************/
	wire [31:0] encode_In;
	wire [3:0] ORA;
	wire [3:0] ORB;
//	wire[2:0] SumORA,SumORB;
	wire[7:0] LSB8bCode;
	wire[2:0] LSB3b;
	wire[1:0] MSB2b;
    wire MSBerror,LSBerror;  //Add a mark for SOS database check
	wire LSBBubbleError;
	wire[2:0] offset;
	reg MSBerrorA,MSBerrorB;
	reg[1:0] MSB2bA,MSB2bB;
    reg[7:0] LSB8bCodeA,LSB8bCodeB;

		
	OR32 U_OR32(.A(encode_In),.ORA(ORA),.ORB(ORB));

always @ (encode_In or ORA or ORB)
begin		
	case(ORA)
		4'b0001: begin MSBerrorA=0; MSB2bA=0; LSB8bCodeA=encode_In[7:0]; end 
		4'b0010: begin MSBerrorA=0; MSB2bA=1; LSB8bCodeA=encode_In[15:8]; end 
		4'b0100: begin MSBerrorA=0; MSB2bA=2; LSB8bCodeA=encode_In[23:16]; end
		4'b1000: begin MSBerrorA=0; MSB2bA=3; LSB8bCodeA=encode_In[31:24]; end
		default: begin MSBerrorA=1; MSB2bA=0; LSB8bCodeA=8'b00000000; end //wrong data		
	endcase
	
	case(ORB)
		4'b0001: begin MSBerrorB=0; MSB2bB=0; LSB8bCodeB=encode_In[11:4]; end 
		4'b0010: begin MSBerrorB=0; MSB2bB=1; LSB8bCodeB=encode_In[19:12]; end 
		4'b0100: begin MSBerrorB=0; MSB2bB=2; LSB8bCodeB=encode_In[27:20]; end
		4'b1000: begin MSBerrorB=0; MSB2bB=3; LSB8bCodeB={encode_In[3:0],encode_In[31:28]}; end
		default: begin MSBerrorB=1; MSB2bB=0; LSB8bCodeB=8'b00000000; end //wrong data					
	endcase			
end

	assign MSB2b = (MSBerrorA==1'b0)?MSB2bA:MSB2bB;
	assign LSB8bCode = (MSBerrorA==1'b0)?LSB8bCodeA:LSB8bCodeB;
	assign offset = (MSBerrorA==1'b0)?3'b000:3'b100;
	assign MSBerror = MSBerrorA & MSBerrorB;

/*************************************/  	 
encode8b3b encode8
(
	.encode_In(LSB8bCode),
	.level(level),
	.Binary_Out(LSB3b),
	.bubbleError(LSBBubbleError),
	.error(LSBerror)
);	 

/*************************************/  
	assign errorFlag = (LSBerror == 1'b1)|(MSBerror == 1'b1);
	assign Binary_Out =(errorFlag == 1)? 5'b00000:({MSB2b,LSB3b}+offset);
/*************************************/
	 
endmodule

