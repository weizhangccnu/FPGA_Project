//***********************************************************//
// module name: start_generator.v 
// author: Wei Zhang
// Date: March 15th, 2021
// Description: This module is to generate start_pulse with fixed pulse width at rising edge of start
//              
//***********************************************************//
module start_generator(
	input clk_8M,				// input clk
	input rst,					// system rst
	input start,				// start signal
	output reg start_pulse		// start_pulse output
);
reg [2:0] start_cnt;
reg enable_cnt1, enable_cnt2;
always @(posedge start or negedge rst)			// start rising edge to trigger start_pulse
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

always @(posedge clk_8M)						// generate start_pulse signal
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

endmodule

