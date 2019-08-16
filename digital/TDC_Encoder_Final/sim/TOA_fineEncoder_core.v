/**
 *
 *  file: TOA_fineEncoder_core.v
 *
 *  TOA_fineEncoder_core
 *  Encode the fine phase from 63 bits therometer code to 6 bits binary code
 *
 *  History:
 *  2019/02/25 Hanhan Sun    : Created
 *  2019/02/26 Datao Gong    : Revised
 *  2019/03/06 Hanhan Sun    : Revised and verified
 *  2019/08/01 Datao Gong    : Output bubble errors for testing
 *  2019/08/01 Datao Gong    : Update bubble error detect logic
 **/
`timescale 1ns/1ps


module OR64(input [63:0] A, output [7:0] ORA, output [7:0] ORB);
wire OR4A[15:0];

genvar gi;
generate
for(gi = 0; gi < 16; gi=gi+1) begin : OR4LOOP
	assign OR4A[gi] = A[gi*4]|A[gi*4+1]|A[gi*4+2]|A[gi*4+3];
end
endgenerate

generate
for(gi = 0; gi < 8; gi=gi+1) begin : OR2LOOP
	assign ORA[gi] = OR4A[gi*2]|OR4A[gi*2+1];
	assign ORB[gi] = OR4A[(gi*2+1)%16]|OR4A[(gi*2+2)%16];
end
endgenerate

endmodule
 
module TOA_fineEncoder_core
(
    input [62:0] encode_In,
    input [2:0] level,//proper values of level ={1,2,3}
	output [1:0] bubbleError,
    output[5:0] Binary_Out
);

/*************************************/
	wire [63:0] Din;
	wire [7:0] ORA;
	wire [7:0] ORB;
	wire[7:0] LSB8bCode;
	wire[2:0] MSB3b,LSB3b;
	wire LSBBubbleError;
    	wire MSBerror,LSBerror;
	wire[2:0] offset;
	reg MSBerrorA,MSBerrorB;
	reg[2:0] MSB3bA,MSB3bB;
    	reg[7:0] LSB8bCodeA,LSB8bCodeB;
	
	assign Din = {1'b0,encode_In};	
	OR64 U_OR64(.A(Din),.ORA(ORA),.ORB(ORB));

	always @ (Din or ORA or ORB)
	begin	
		case(ORA)
			8'b00000001: begin MSBerrorA = 1'b0; MSB3bA=0; LSB8bCodeA=Din[7:0]; end 
			8'b00000010: begin MSBerrorA = 1'b0; MSB3bA=1; LSB8bCodeA=Din[15:8]; end 
			8'b00000100: begin MSBerrorA = 1'b0; MSB3bA=2; LSB8bCodeA=Din[23:16]; end
			8'b00001000: begin MSBerrorA = 1'b0; MSB3bA=3; LSB8bCodeA=Din[31:24]; end
			8'b00010000: begin MSBerrorA = 1'b0; MSB3bA=4; LSB8bCodeA=Din[39:32]; end 
			8'b00100000: begin MSBerrorA = 1'b0; MSB3bA=5; LSB8bCodeA=Din[47:40]; end 
			8'b01000000: begin MSBerrorA = 1'b0; MSB3bA=6; LSB8bCodeA=Din[55:48]; end
			8'b10000000: begin MSBerrorA = 1'b0; MSB3bA=7; LSB8bCodeA=Din[63:56]; end
			default:begin MSBerrorA = 1'b1; MSB3bA=0; LSB8bCodeA=8'b00000000; end
		endcase

		case(ORB)
			8'b00000001: begin MSBerrorB = 1'b0; MSB3bB=0; LSB8bCodeB=Din[11:4]; end 
			8'b00000010: begin MSBerrorB = 1'b0; MSB3bB=1; LSB8bCodeB=Din[19:12]; end 
			8'b00000100: begin MSBerrorB = 1'b0; MSB3bB=2; LSB8bCodeB=Din[27:20]; end
			8'b00001000: begin MSBerrorB = 1'b0; MSB3bB=3; LSB8bCodeB=Din[35:28]; end
			8'b00010000: begin MSBerrorB = 1'b0; MSB3bB=4; LSB8bCodeB=Din[43:36]; end 
			8'b00100000: begin MSBerrorB = 1'b0; MSB3bB=5; LSB8bCodeB=Din[51:44]; end 
			8'b01000000: begin MSBerrorB = 1'b0; MSB3bB=6; LSB8bCodeB=Din[59:52]; end
			8'b10000000: begin MSBerrorB = 1'b0; MSB3bB=7; LSB8bCodeB={Din[63],Din[3:0],Din[62:60]}; end //special data
			default:begin MSBerrorB = 1'b1; MSB3bB=0; LSB8bCodeB=8'b00000000; end			
		endcase			
	end
/*************************************/  	 
	assign MSB3b = (MSBerrorA==1'b0)?MSB3bA:MSB3bB;
	assign LSB8bCode = (MSBerrorA==1'b0)?LSB8bCodeA:LSB8bCodeB;
	assign offset = (MSBerrorA==1'b0)?3'b000:3'b100;	
	assign MSBerror = MSBerrorA & MSBerrorB;
	
	encode8b3b encode8
	(
		.encode_In(LSB8bCode),
		.level(level),
		.Binary_Out(LSB3b),
		.bubbleError(LSBBubbleError),
		.error(LSBerror)
	);	 
/*************************************/  
	assign Binary_Out =((LSBerror == 1'b1)|(MSBerror == 1'b1))?6'b111111:(({MSB3b,LSB3b}+offset)%63);
	assign bubbleError = {LSBBubbleError&(!MSBerrorA),LSBBubbleError&MSBerrorA}; //consider LSB and MSB error
/*************************************/	 
endmodule

