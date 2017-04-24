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
reg clk = 0;            //clock signal
reg clk_en = 0;         //clock enable, active is high
reg sclear = 0;         //sychnorous clear, active is high
reg [3:0]a = 5;         //input signal, variable should be defined reg 
reg [3:0]b = 5;         //input signal
wire [7:0]out;          //output

initial begin           //inital 
b = 5;                  
#200 b = 6;             //delay 200ns
#200 b = 7;
#200 b = 8;
#200 b = 9;
#200 b = 10;
end

initial begin           //initial clock enable
clk_en = 0;             
#500 clk_en = 1'b1;     //delay 200ns assert clk_en
end

initial begin           //initial sychnorous clear 
sclear = 0;
#700 sclear = 1'b1;     //delay 700ns assert sclear 
#150 sclear = 1'b0;     //delay 100ns deassert sclear
end

always begin            //generate period = 20ns clock
#10 clk <= ~clk;
end

Multiplier my_test(clk, a, b, clk_en, sclear, out);         //invoke top module
endmodule
