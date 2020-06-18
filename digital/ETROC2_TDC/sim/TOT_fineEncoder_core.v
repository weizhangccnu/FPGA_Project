/**
 *
 *  file: TOT_fineEncoder_core.v
 *
 *  TOT_fineEncoder_core
 *  Encode the fine phase from 21 bits therometer code to 5 bits binary code
 *
 *  History:
 *  2020/04/30 Wei Zhang	 : Create and verified ETROC2 TDC
 **/
`timescale 1ps/100fs

/***********************************************************************/
//
/***********************************************************************/
module OR24(
	input [23:0] A,
	output [2:0] ORA,
	output [2:0] ORB
);
wire OR4A[5:0];
genvar gi;
generate
for(gi = 0; gi < 6; gi=gi+1) begin : OR4LOOP
	assign OR4A[gi] = A[gi*4]|A[gi*4+1]|A[gi*4+2]|A[gi*4+3];
end
endgenerate

generate
for(gi = 0; gi < 3; gi=gi+1) begin : OR2LOOP
	assign ORA[gi] = OR4A[gi*2]|OR4A[gi*2+1];
	assign ORB[gi] = OR4A[(gi*2+1)%6]|OR4A[(gi*2+2)%6];
end
endgenerate

endmodule

/***********************************************************************/
//
/***********************************************************************/
module TOT_fineEncoder_core(
	input [20:0] encode_In,
	input [1:0] level,	
	output errorFlag,
	output [4:0] Binary_Out
);

wire [23:0] Din;
wire [2:0] ORA;
wire [2:0] ORB;

reg MSBerrorA, MSBerrorB;
wire MSBerror, LSBerror;
wire [1:0] MSB2b;
reg [1:0] MSB2bA, MSB2bB;
wire [2:0] LSB3b;
reg [7:0] LSB8bCodeA, LSB8bCodeB;
wire [7:0] LSB8bCode;
wire [2:0] offset;
 
assign Din = {3'b000, encode_In};

OR24 OR24_TT(
	.A(Din),
	.ORA(ORA),
	.ORB(ORB)
);

always @(Din or ORA or ORB)
begin
	case(ORA)
		3'b001:	begin MSBerrorA = 1'b0; MSB2bA = 2'b00; LSB8bCodeA = Din[7:0]; end
		3'b010: begin MSBerrorA = 1'b0; MSB2bA = 2'b01;	LSB8bCodeA = Din[15:8];	end
		3'b100: begin MSBerrorA = 1'b0;	MSB2bA = 2'b10; LSB8bCodeA = Din[23:16]; end
		default: begin MSBerrorA = 1'b1; MSB2bA = 2'b00; LSB8bCodeA = 8'b00000000; end
	endcase

	case(ORB)
		3'b001:	begin MSBerrorB = 1'b0; MSB2bB = 2'b00; LSB8bCodeB = Din[11:4]; end
		3'b010: begin MSBerrorB = 1'b0; MSB2bB = 2'b01;	LSB8bCodeB = Din[19:12]; end
		3'b100: begin MSBerrorB = 1'b0;	MSB2bB = 2'b10; LSB8bCodeB = {Din[23:21],Din[3:0],Din[20]}; end
		default: begin MSBerrorB = 1'b1; MSB2bB = 2'b00; LSB8bCodeB = 8'b00000000; end
	endcase
end
/***********************************************************************/
assign MSB2b = (MSBerrorA==1'b0)?MSB2bA:MSB2bB;
assign LSB8bCode = (MSBerrorA==1'b0)?LSB8bCodeA:LSB8bCodeB;
assign offset = (MSBerrorA==1'b0)?3'b000:3'b100;
assign MSBerror = MSBerrorA & MSBerrorB;

encode8b3b encode8b3b_tt(
	.encode_In(LSB8bCode),
	.level(level),
	.Binary_Out(LSB3b),
	.error(LSBerror)
);

assign errorFlag = (LSBerror == 1'b1)|(MSBerror == 1'b1);
assign Binary_Out = (errorFlag == 1'b1)?5'b11111:(({MSB2b,LSB3b}+offset)%21);

endmodule


