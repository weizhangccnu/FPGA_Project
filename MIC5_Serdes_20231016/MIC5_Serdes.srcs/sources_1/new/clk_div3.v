`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/16 16:10:33
// Design Name: 
// Module Name: clk_div3
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


module clk_div3(
    input clk,                  // input clock 20MHz
    input rst_n,                // reset signal, low active
    output clk_div3             // clock divide three
);

reg [1:0] cnt;
reg clk_13;
reg clk_13_r;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt <= 2'd0;
    else if(cnt == 2'd2)
        cnt <= 2'd0;
    else
        cnt <= cnt + 1'b1;
end    


always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        clk_13 <= 1'b0;
    else if(cnt == 2'd2)
        clk_13 <= 1'b1;
    else
        clk_13 <= 1'b0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        clk_13_r <= 1'b0;
    else
        clk_13_r <= clk_13;
end

assign clk_div3 = clk_13 | clk_13_r;
endmodule
