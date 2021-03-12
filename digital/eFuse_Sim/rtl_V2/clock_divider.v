//***********************************************************//
// module name: clock_divider.v 
// author: Wei Zhang
// Date: March 11th, 2021
// Description: This module is used to descript eFuse power switch behavior.
//              
//***********************************************************//
`timescale 1ns/1ps
module clock_divider(
	input int_clock,				// internal 40 MHz clock from PLL
	input ext_clock,				// external 2 MHz clock
	input clk_sel,					// clock select, 1: internal 40 MHz clock, 0: external 2 MHz clock, default value is 1
	input rst,						// system reset
	output clk_out					// 2 MHz clock output
);

reg [3:0] cnt;
reg int_clk2M;

always @(posedge int_clock)
begin
	if(!rst)
	begin
		cnt <= 4'b0000;
		int_clk2M <= 1'b0;
	end
	else
	begin
		if (cnt == 4'd9)
		begin
			cnt <= 4'd0;
			int_clk2M <= !int_clk2M;
		end 
		else
		begin
			cnt <= cnt + 4'd1;
		end
	end
end

assign clk_out = (clk_sel == 1'b1) ? int_clk2M : ext_clock;
endmodule

