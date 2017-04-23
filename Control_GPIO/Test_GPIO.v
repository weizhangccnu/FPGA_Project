`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CCNU    
// Engineer: WeiZhang
// 
// Create Date: 04/23/2017 10:18:40 AM
// Design Name: 
// Module Name: Test_GPIO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Test_GPIO(
input in,
output out
    );
assign out = ~in;

endmodule
