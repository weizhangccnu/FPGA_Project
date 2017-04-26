`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CCNU
// Engineer: WeiZhang
// 
// Create Date: 04/25/2017 10:28:00 PM
// Design Name: 
// Module Name: Two_Dual_Ram
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

module Two_Dual_Ram(
input rst,                  //system reset
input [7:0]ain,             //input address
input [7:0]aout,            //output address
input [7:0]din,             //input data
input wr_clk,               //write clock
input wr_en,                //write enable, active is high
input rd_clk,               //read clock
input rd_en,                //read enable, active is high
output reg [15:0]dout       //read output data
    );

reg [7:0]memory[0:255];     //define a memory, width = 8bit, depth = 256
reg [15:0]H_data;
reg [15:0]L_data;

initial begin               //Initial memory with "Init_Memory.dat"
$readmemh("/home/wz/Desktop/FPGA_Project/Two_Dual_Ram/Init_Memory.txt", memory);       
end

always @(posedge wr_clk)    //write operation
begin
    if(!rst)
        if(wr_en)
        begin
            memory[ain] <= din;
        end
end

always @(posedge rd_clk)    //read operation
begin
    if(!rst)
        if(rd_en)
        begin
            H_data <= memory[aout];
            L_data <= memory[aout+1];
            dout <= H_data<<8 | L_data;
        end
end
endmodule
