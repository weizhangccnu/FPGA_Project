`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CCNU
// Engineer: WeiZhang
// 
// Create Date: 04/24/2017 10:41:44 AM
// Design Name: 
// Module Name: Native_Interface_FIFO_Simulation
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


module Native_Interface_FIFO_Simulation(

    );
reg rst = 1'b0;
reg wr_clk = 1'b0;
reg rd_clk = 1'b0;
reg [15:0]din = 16'h0000;
reg wr_en = 1'b0;
reg rd_en = 1'b0;
reg [15:0]counter = 16'h0000;

wire [7:0]dout;
wire full;
wire almost_full;
wire empty;
wire almost_empty;
wire [9:0]rd_data_count;
wire [8:0]wr_data_count;

always begin 
#5 wr_clk <= ~wr_clk;       //generate write clock period = 10ns
end

always begin
#10 rd_clk <= ~rd_clk;      //generate read clok period = 40ns
end

initial begin               //generate din via counter
counter = 16'h0000;
din = 16'h0;
    forever begin
    #10 counter <= counter + 1'b1; 
    din <= 16'hff00 | counter;
    end
end

initial begin 
wr_en = 1'b0;
#0 wr_en = 1'b1;           //assert write enable
end

initial begin               
rd_en = 1'b0;
#2000 rd_en = 1'b1;         //assert read enable
end

Native_Interface_FIFO my_test(                 //invoke top module
rst,              //system reset
wr_clk,           //write clock
rd_clk,           //read clock
din,              //input data
wr_en,            //write enable
rd_en,            //read enable
dout,             //data output
full,             //FIFO full
almost_full,      //FIFO almost full
empty,            //FIFO empty
almost_empty,     //FIFO almost empty
rd_data_count,    //read data counter
wr_data_count     //write data counter
);
endmodule
