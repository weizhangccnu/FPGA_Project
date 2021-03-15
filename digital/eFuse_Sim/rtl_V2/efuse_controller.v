//***********************************************************//
// module name: efuse_controller.v 
// author: Wei Zhang
// Date: March 13th, 2021
// Description: This module is top module to control efuse.
//              
//***********************************************************//
`timescale 1ns/1ps
module efuse_controller(
	input int_clk,				// internal 40 MHz clock from PLL
	input ext_clk, 				// external 2 MHz clock
	input rst,					// system reset, low active	
	input clk_sel,				// clock select
	input [1:0] mode,			// mode select, 2'b01 for programming mode, 2'b10 for reading mode
	input start, 				// start program
	input [3:0] TCKHP,			// SCLK high period, default value is 4
	input [31:0] prog,			// 32-bit program data
	output EN,					// EN for power switch
	output RAMPENA,				// RAMPENA for power switch
	output SHORT,				// SHORT for power switch
	output CSB,					// chip select for eFuse, low active
	output PGM, 				// program mode siganl for eFuse
	output SCLK					// serial clock signal for eFuse
);

wire clk_8M;
reg [2:0] start_cnt;
reg enable_cnt1, enable_cnt2;
reg start_pulse;
always @(posedge start or negedge rst)
begin
	if(!rst)
	begin
		enable_cnt1 = 1'b0;
	end
	else
	begin
		enable_cnt1 = 1'b1;
	end
end

always @(posedge clk_8M)
begin
	if(!rst)
	begin
		start_cnt <= 3'b000;
		start_pulse <= 1'b0;
		enable_cnt2 = 1'b1;
	end
	else if(enable_cnt1 == 1'b1 && enable_cnt2 == 1'b1)
	begin
		if(start_cnt != 3'b111)
		begin
			start_cnt <= start_cnt + 1'b1;
			start_pulse <= 1'b1;
		end
		else
		begin
			enable_cnt2 <= 1'b0;
			start_pulse <= 1'b0;
		end
	end
end

clock_divider clock_divider_inst(
.int_clock(int_clk),			// internal 40 MHz clock from PLL
.ext_clock(ext_clk),			// external 2 MHz clock
.clk_sel(clk_sel),				// clock select, 1: internal 40 MHz clock, 0: external 2 MHz clock, default value is 1
.rst(rst),						// system reset
.clk_out(clk_8M)				// 2 MHz clock output
);

efuses_control_sm efuses_control_sm_inst(
.clk(clk_8M),					// 40 MHz 
.rst(rst),						// system reset
.start(start_pulse),			// Progarmming start signal
.mode(mode),					// program mode or read mode selection
.TCKHP(TCKHP),					// SCLK high period, default value is 4
.prog(prog),					// 32-bit program data
.sw_en(EN),						// power switch signal
.sw_rampena(RAMPENA),			// power switch rampena signal
.sw_short(SHORT),				// power switch output tied to ground
.CSB(CSB),						// efuse chip select, low active
.PGM(PGM),						// efuse progarm signal
.SCLK(SCLK)						// efuse serial clock
 );
endmodule
