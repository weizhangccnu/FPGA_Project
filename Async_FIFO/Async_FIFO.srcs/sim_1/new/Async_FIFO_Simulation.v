`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/28/2017 10:39:31 AM
// Design Name: 
// Module Name: Async_FIFO_Simulation
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
`define WRITE_DATA_WIDTH    8
`define READ_DATA_WIDTH     8
`define BUFF_DATA_DEPTH     256
`define BUFF_DATA_WIDTH     8
`define ADDR_WIDTH          8

module Async_FIFO_Simulation(
    );
reg rst = 1'b0;
reg wr_clk=1'b0;                                //write clock
reg wr_en=1'b0;                                 //write enable
reg rd_clk=1'b0;                                //read clock
reg rd_en=1'b0;                                 //read enable
reg [`WRITE_DATA_WIDTH-1:0] Din = 8'h00;        //write in data width
wire [`READ_DATA_WIDTH-1:0] Dout;               //Read out data width
wire Full;                                      //FIFO Full flag
wire Empty;
integer i;
initial begin
for(i=0;i<1200;i=i+1)
begin                                    //generate write clock
#5 wr_clk <= ~wr_clk;
end
wr_clk = 1'b0;
end

always begin                                    //generate write clock
#10 rd_clk <= ~rd_clk;
end

initial begin
#100 wr_en = 1'b1;
end 

initial begin
#100 rd_en = 1'b1;
end 

initial begin
forever begin
#10 if(Din < 8'hff)
        Din <= Din +1'b1;
    else
        Din <= 8'h00;    
end
end

Sync_FIFO my_test(
rst,                            //system reset
wr_clk,                         //write clock
wr_en,                          //write enable
rd_clk,                         //read clock
rd_en,                          //read enable
Din,                            //write in data width
Dout,                           //Read out data width
Full,                           //FIFO Full flag
Empty                           //FIFO Empty flag
    );
endmodule
