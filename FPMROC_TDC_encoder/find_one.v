/* find_one
 * description: find
 * author: Wei Zhang
 * date: October 9th, 2023
 * version: V0
 * 
 */
module find_one(
	input [10:0] din,			// input data, 11-bit
	output [3:0] index			// output index data, 4-bit
);

wire [7:0] tmp0;
wire [4:0] tmp1;
wire [1:0] tmp2;

assign index[3] = ~(|din[7:0]);
assign tmp0 = index[3] ? {5'b0000_0, din[10:8]} : din[7:0];

assign index[2] = ~(|tmp0[3:0]);
assign tmp1 = index[2] ? tmp0[7:4] : tmp0[3:0];

assign index[1] = ~(|tmp1[1:0]);
assign tmp2 = index[1] ? tmp1[3:2] : tmp1[1:0];

assign index[0] = ~tmp2[0];

endmodule
