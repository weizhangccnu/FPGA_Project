`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2017 09:43:49 PM
// Design Name: 
// Module Name: Multiplier_Simulation
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


module Multiplier_Simulation(

    );
reg clk = 0; 

reg [3:0]a = 5;
reg [3:0]b = 5;
wire [7:0]out;

initial begin
b = 5;
#200 b = 6;
#200 b = 7;
#200 b = 8;
#200 b = 9;
#200 b = 10;
end

always begin
#10 clk <= ~clk;
end

Multiplier my_test(clk, a, b, out);
endmodule
