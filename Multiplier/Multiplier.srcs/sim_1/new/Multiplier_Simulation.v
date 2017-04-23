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

always begin            //generate period = 20ns clock signal
#10 clk <= ~clk;
end

Multiplier my_test(clk, a, b, out);         //invoke top module
endmodule
