//Verilog HDL for "ETROC1_Project", "TDC_Encoder_Function" "functional"
//
//Createe: Wei Zhang
//Date: April 2rd,
//Address: SMU Dallas, TX

`timescale 1ns / 1ps

module counter(clk, resetn, cnt, cout);
input clk, resetn;
output reg [3:0] cnt;
output wire cout;

always @(posedge clk)
begin
	if(!resetn)
		cnt <= 4'b0000;
	else
		cnt <= cnt + 1'b1;
end

assign cout = &cnt;

endmodule
