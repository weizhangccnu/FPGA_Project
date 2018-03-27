`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2018 11:33:07 AM
// Design Name: 
// Module Name: create_input_data
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


module create_input_data(
input wire clk,         //input clock
input wire reset,       //system reset
input wire fifo_wr_en,
input wire fifo_rd_clk,
input wire fifo_rd_en,
output wire [255:0] fifo_data_out,
output wire fifo_empty
);
//-------------------------------------------------< generate 32 bit data
reg [31:0] data_in_r;
wire [31:0] data_in;
//reg fifo_wr_en_r;
always @(posedge clk)
begin
    if(reset)
    begin 
        data_in_r <= 32'h00000000;
    end
    else
    begin
//        if(fifo_wr_en == 1'b1 && fifo_full ＝= 1'b0)
        if(fifo_wr_en == 1'b1 && fifo_full == 1'b0)        
            data_in_r <= data_in_r + 1'b1;
        else
            data_in_r <= data_in_r;
    end
end
assign data_in = 32'ha0000000 | data_in_r;
//-------------------------------------------------> generate 32 bit data
//-------------------------------------------------< fifo32to256
//wire fifo_wr_en;

fifo_32to256 fifo_32to256_inst (
  .rst(reset),              // input wire rst
  .wr_clk(clk),             // input wire wr_clk
  .rd_clk(fifo_rd_clk),     // input wire rd_clk
  .din(data_in),            // input wire [31 : 0] din
  .wr_en(fifo_wr_en),       // input wire wr_en
  .rd_en(fifo_rd_en),       // input wire rd_en
  .dout(fifo_data_out),     // output wire [255 : 0] dout
  .full(fifo_full),         // output wire full
  .empty(fifo_empty)        // output wire empty
);
//-------------------------------------------------> fifo32to256
endmodule
