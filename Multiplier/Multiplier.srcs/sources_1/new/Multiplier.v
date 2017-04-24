`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2017 09:25:48 PM
// Design Name: 
// Module Name: Multiplier
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


module Multiplier(
input clk,              //input clock
input a,                //input data a, width = 4bit
input b,                //input data b, width = 4bit
input clk_en,           //clock enable, active is high
input sclear,           //sychnorous clear, active is high
output out              //multiply result width = 8bit
    );
wire clk;
wire clk_en;
wire sclear;
wire [3:0]a;
wire [3:0]b;
wire [7:0]out;

mult_gen_0 mult (
  .CLK(clk),        // input wire CLK
  .A(a),            // input wire [3 : 0] A
  .B(b),            // input wire [3 : 0] B
  .CE(clk_en),      // input wire CE
  .SCLR(sclear),    // input wire SCLR
  .P(out)           // output wire [7 : 0] P
);
endmodule
