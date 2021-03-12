//***********************************************************//
// module name: Program_mode_tb.v 
// author: Wei Zhang
// Date: March 3rd, 2021
// Description: This module is used to verify program module.
//              
//***********************************************************//
`timescale 1ns/1ps
module Program_mode_tb();
reg clk_1M;
reg rst;
reg [31:0] program_bit;
reg VDDQ;
wire DOUT;

wire CSB;
wire PGM;
wire SCLK;
wire DIN;
wire [31:0] Q;  

initial
begin
	clk_1M = 1'b0;
	rst = 1'b0;
	VDDQ = 1'b0;
	program_bit = 32'h5555aaaa;
	#10000	VDDQ = 1'b1;
	#5000 rst = 1'b1;
	#12000 rst = 1'b0;
	#400000 VDDQ = 1'b0;
	#1000000 $stop;
end

always begin
	#500 clk_1M = ~ clk_1M;
end

Program_mode Program_mode_inst(
.clk_1M(clk_1M),			// system clock
.rst(rst),					// system rst
.program_bit(program_bit),	// 32-bit program data
.CSB(CSB),					// chip select enable
.PGM(PGM),					// Program mode
.SCLK(SCLK),				// serial clock
.DIN(DIN),					// serial data input
.DOUT(DOUT)					// serial data output
);

TEF65LP32X1S_I TEF65LP32X1S_I_inst(
.CSB(CSB), 
.PGM(PGM), 
.SCLK(SCLK), 
.DIN(DIN), 
.VDDQ(VDDQ), 
.DOUT(DOUT),
.Q0(Q[0]),
.Q1(Q[1]),
.Q2(Q[2]),
.Q3(Q[3]),
.Q4(Q[4]),
.Q5(Q[5]),
.Q6(Q[6]),
.Q7(Q[7]),
.Q8(Q[8]),
.Q9(Q[9]),
.Q10(Q[10]),
.Q11(Q[11]),
.Q12(Q[12]),
.Q13(Q[13]),
.Q14(Q[14]),
.Q15(Q[15]),
.Q16(Q[16]),
.Q17(Q[17]),
.Q18(Q[18]),
.Q19(Q[19]),
.Q20(Q[20]),
.Q21(Q[21]),
.Q22(Q[22]),
.Q23(Q[23]),
.Q24(Q[24]),
.Q25(Q[25]),
.Q26(Q[26]),
.Q27(Q[27]),
.Q28(Q[28]),
.Q29(Q[29]),
.Q30(Q[30]),
.Q31(Q[31])
);
endmodule
