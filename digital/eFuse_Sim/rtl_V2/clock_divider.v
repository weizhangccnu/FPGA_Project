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

reg [2:0] cnt1, cnt2;
reg clk_p, clk_n;
wire int_clk8M;

always @(posedge int_clock)
begin
	if(!rst)
	begin
		cnt1 <= 3'b000;
		clk_p <= 1'b0;
	end
	else
	begin
		if (cnt1 == 3'd4)
		begin
			cnt1 <= 3'd0;
			clk_p <= clk_p;
		end 
		else
		begin
			cnt1 <= cnt1 + 3'd1;
			if (cnt1 == 3'd1 || cnt1 == 3'd3)
			begin
				clk_p <= !clk_p;
			end 
		end
	end
end

always @(negedge int_clock)
begin
	if(!rst)
	begin
		cnt2 <= 3'b000;
		clk_n <= 1'b0;
	end
	else
	begin
		if (cnt2 == 3'd4)
		begin
			cnt2 <= 3'd0;
			clk_n <= clk_n;
		end 
		else
		begin
			cnt2 <= cnt2 + 3'd1;
			if (cnt2 == 3'd1 || cnt2 == 3'd3)
			begin
				clk_n <= !clk_n;
			end 
		end
	end
end
assign int_clk8M = clk_p | clk_n; 
assign clk_out = (clk_sel == 1'b1) ? int_clk8M : ext_clock;
endmodule

