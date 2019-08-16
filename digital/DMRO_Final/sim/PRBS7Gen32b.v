//`timescale 1ns / 1fs
//////////////////////////////////////////////////////////////////////////////////
// Company:        FNAL/SMU
// Engineer:       Quan Sun
// 
// Create Date:    Mon Feb 18 1551 CST 2019
// Design Name:    ETROC1  
// Module Name:    PRBS7Gen32b 
// Project Name: 
// Description: Generate PRBS7 data in 32-bit width.
//
// Dependencies: PRBS 7 generation
//
// Revision: v1, reversed output vector order
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ps/1fs
module PRBS7Gen32b(
    CLK,	
    RSTn,	
    dataOutA
    );
    input CLK;	
    input RSTn;	
    output [31:0] dataOutA;
    wire [31:0] data_int;	
	
//	wire allzeroA;
	wire rstA;
//	wire [6:0] vA
	
	reg [6:0] SA;  //seed 	
	
//	assign allzeroA = ~SA[0]&~SA[1]&~SA[2]&~SA[3]&~SA[4]&~SA[5]&~SA[6];	

//	assign rstA =  resetA | allzeroA;

	assign rstA = RSTn;
	assign dataOutA = data_int;

//Section A
	assign data_int[31] = SA[0];
	assign data_int[30] = SA[1];
	assign data_int[29] = SA[2];
	assign data_int[28] = SA[3];
	assign data_int[27] = SA[4];
	assign data_int[26] = SA[5];
	assign data_int[25] = SA[6];
	assign data_int[24] = SA[0]^SA[1];
	assign data_int[23] = SA[1]^SA[2];
	assign data_int[22] = SA[2]^SA[3];
	assign data_int[21] = SA[3]^SA[4];
	assign data_int[20] = SA[4]^SA[5];
	assign data_int[19] = SA[5]^SA[6];
	assign data_int[18] = SA[0]^SA[1]^SA[6];
	assign data_int[17] = SA[0]^SA[2];
	assign data_int[16] = SA[1]^SA[3];
	assign data_int[15] = SA[2]^SA[4];
	assign data_int[14] = SA[3]^SA[5];
	assign data_int[13] = SA[4]^SA[6];
	assign data_int[12] = SA[0]^SA[1]^SA[5];
	assign data_int[11] = SA[1]^SA[2]^SA[6];
	assign data_int[10] = SA[0]^SA[1]^SA[2]^SA[3];
	assign data_int[9] = SA[1]^SA[2]^SA[3]^SA[4];
	assign data_int[8] = SA[2]^SA[3]^SA[4]^SA[5];
	assign data_int[7] = SA[3]^SA[4]^SA[5]^SA[6];
	assign data_int[6] = SA[0]^SA[1]^SA[4]^SA[5]^SA[6];
	assign data_int[5] = SA[0]^SA[2]^SA[5]^SA[6];
	assign data_int[4] = SA[0]^SA[3]^SA[6];
	assign data_int[3] = SA[0]^SA[4];
	assign data_int[2] = SA[1]^SA[5];
	assign data_int[1] = SA[2]^SA[6];
	assign data_int[0] = SA[0]^SA[1]^SA[3];
		
	always @(negedge rstA or posedge CLK )
	begin
		if (!rstA)begin
            SA <= 7'b1111111;  
        end
		else begin
			SA[0]<= SA[1]^SA[2]^SA[4];
			SA[1]<= SA[2]^SA[3]^SA[5];
			SA[2]<= SA[3]^SA[4]^SA[6];
			SA[3]<= SA[0]^SA[1]^SA[4]^SA[5];
			SA[4]<= SA[1]^SA[2]^SA[5]^SA[6];
			SA[5]<= SA[0]^SA[1]^SA[2]^SA[3]^SA[6];
			SA[6]<= SA[0]^SA[2]^SA[3]^SA[4];		
        end
	end
	
endmodule
