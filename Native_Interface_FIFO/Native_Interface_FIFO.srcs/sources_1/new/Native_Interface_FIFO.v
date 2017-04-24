`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2017 10:20:59 AM
// Design Name: 
// Module Name: Native_Interface_FIFO
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


module Native_Interface_FIFO(
input rst,              //system reset
input wr_clk,           //write clock
input rd_clk,           //read clock
input din,              //input data
input wr_en,            //write enable
input rd_en,            //read enable
output dout,            //data output
output full,            //FIFO full
output almost_full,     //FIFO almost full
output empty,           //FIFO empty
output almost_empty,    //FIFO almost empty
output rd_data_count,   //read data counter
output wr_data_count    //write data counter
    );
wire rst;
wire wr_clk;
wire rd_clk;
wire [15:0]din;
wire wr_en;
wire rd_en;
wire [7:0]dout;
wire full;
wire almost_full;
wire empty;
wire almost_empty;
wire [9:0]rd_data_count;
wire [8:0]wr_data_count;
    
fifo_generator_0 fifo_512_1024 (
      .rst(rst),                      // input wire rst
      .wr_clk(wr_clk),                // input wire wr_clk
      .rd_clk(rd_clk),                // input wire rd_clk
      .din(din),                      // input wire [15 : 0] din
      .wr_en(wr_en),                  // input wire wr_en
      .rd_en(rd_en),                  // input wire rd_en
      .dout(dout),                    // output wire [7 : 0] dout
      .full(full),                    // output wire full
      .almost_full(almost_full),      // output wire almost_full
      .empty(empty),                  // output wire empty
      .almost_empty(almost_empty),    // output wire almost_empty
      .rd_data_count(rd_data_count),  // output wire [9 : 0] rd_data_count
      .wr_data_count(wr_data_count)  // output wire [8 : 0] wr_data_count
    );
endmodule
