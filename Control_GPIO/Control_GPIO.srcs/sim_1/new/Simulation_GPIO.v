`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2017 10:20:11 AM
// Design Name: 
// Module Name: Simulation_GPIO
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


module Simulation_GPIO(
    );

reg clk = 0;                //testbench clock
always #10 clk <= ~clk;     //clock period 20ns
wire out;                   //output signal
Test_GPIO mytest(clk,out);  //invoke Test_GPIO() module

endmodule