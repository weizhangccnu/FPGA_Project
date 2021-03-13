//***********************************************************//
// module name: efuses_control_sm_tb.v 
// author: Wei Zhang
// Date: March 9th, 2021
// Description: This module is used to verify SSA efuses contorller.
//              
//***********************************************************//
`timescale 1ns/1ps
module efuses_control_sm_tb();
reg ext_clk;				// external 2 MHz clock
reg int_clk;				// internal 40 MHz clock								
reg rst;					// system reset
reg clk_sel;				// clock select
reg start;					// program start signal
reg [1:0] mode;				// 8'b1111_0000 : for programming, 8'b0000_1111 : for reading
wire VDDQ_2V5;				// Power switch 2.5 V output
reg [3:0] TCKHP;			// SCLK high period length, default value: 4 -- 5 us
reg [31:0] prog;			// 32-bit program data
wire [31:0] Q;				// 32-bit parallel data

initial begin
	ext_clk = 1'b0;
	#3 int_clk = 1'b0;
	clk_sel = 1'b0;
	rst = 1'b1;
	start = 1'b0;
	mode = 2'b00;
	prog = 32'ha5a5_5a5a;
	TCKHP = 4'd1;
	#5000 rst = 1'b0;
	#1000 rst = 1'b1;
	#5000 mode = 2'b01;
	#20000 start = 1'b1;
	#500 start = 1'b0;
	#250000 mode = 2'b10;
	#50000 $stop;
	 
end


always begin
	#62.5 ext_clk = ~ext_clk;			// 8 MHz external clock
end

always begin
	#12.5 int_clk = ~int_clk;			// 40 MHz internal clock
end

efuse_controller efuse_controller_inst(
.int_clk(int_clk),				// internal 40 MHz clock from PLL
.ext_clk(ext_clk), 				// external 2 MHz clock
.rst(rst),						// system reset, low active	
.clk_sel(clk_sel),				// clock select
.mode(mode),					// mode select, 2'b01 for programming mode, 2'b10 for reading mode
.start(start), 					// start program
.TCKHP(TCKHP),					// SCLK high period, default value is 4
.prog(prog),					// 32-bit program data
.EN(EN),						// EN for power switch
.RAMPENA(RAMPENA),				// RAMPENA for power switch
.SHORT(SHORT),					// SHORT for power switch
.CSB(CSB),						// chip select for eFuse, low active
.PGM(PGM), 						// program mode siganl for eFuse
.SCLK(SCLK)						// serial clock signal for eFuse
);

power_switch power_switch_inst(
.VDD(1'b1), 					// 1.2 V input voltage
.VDDQ(1'b1),					// 2.5 V input voltage
.EN(EN),						// Enable power switch
.RAMPENA(RAMPENA), 				// RAMPENA output of 2.5 V voltage
.SHORT(SHORT),					// SHORT signal tied the output to ground
.VDDQ_2V5(VDDQ_2V5)				// 2.5 V power output
);

TEF65LP32X1S_I TEF65LP32X1S_I_inst(
.CSB(CSB), 
.PGM(PGM), 
.SCLK(SCLK), 
.DIN(1'b0), 
.VDDQ(VDDQ_2V5), 
.DOUT(),
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
