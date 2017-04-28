`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CCNU
// Engineer: WeiZhang
// 
// Create Date: 04/27/2017 04:29:17 PM
// Design Name: Synchronous FIFO
// Module Name: Sync_FIFO
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
//=======================================================//
//Macro define
//=======================================================//
`define WRITE_DATA_WIDTH    8
`define READ_DATA_WIDTH     8
`define BUFF_DATA_DEPTH     256
`define BUFF_DATA_WIDTH     8
`define ADDR_WIDTH          8
//=======================================================//
//Module Define
//=======================================================//
module Sync_FIFO(
input rst,                          //system reset
input wr_clk,                       //write clock
input wr_en,                        //write enable
input rd_clk,                       //read clock
input rd_en,                        //read enable
input [`WRITE_DATA_WIDTH-1:0] Din,  //write in data width
output [`READ_DATA_WIDTH-1:0] Dout, //Read out data width
output Full,                        //FIFO Full flag
output Empty                        //FIFO Empty flag
    );
reg Full, Empty;                    //define Full and Empty reg variable
reg [`BUFF_DATA_WIDTH-1:0]Buff[`BUFF_DATA_DEPTH-1:0];       //reg array
reg [`ADDR_WIDTH:0] Wr_Addr_Bin, Rd_Addr_Bin;               //Write and Read Address

reg [`ADDR_WIDTH:0] Sync_Wr_Addr0_Gray;
reg [`ADDR_WIDTH:0] Sync_Wr_Addr1_Gray;
reg [`ADDR_WIDTH:0] Sync_Wr_Addr2_Gray;

reg [`ADDR_WIDTH:0] Sync_Rd_Addr0_Gray;
reg [`ADDR_WIDTH:0] Sync_Rd_Addr1_Gray;
reg [`ADDR_WIDTH:0] Sync_Rd_Addr2_Gray;

wire [`ADDR_WIDTH-1:0] FIFO_Entry_Addr, FIFO_Exit_Addr;
wire [`ADDR_WIDTH:0] Wr_NextAddr_Bin, Rd_NextAddr_Bin;      //ADDR_WIDTH+1 the ADDR_WIDTH bit 
wire [`ADDR_WIDTH:0] Wr_NextAddr_Gray, Rd_NextAddr_Gray;    //Gray code Address

wire Asyn_Full, Asyn_Empty;
//=======================================================//
//Inital FIFO
//=======================================================//
initial begin
Full = 1'b0;
Empty = 1'b1;

Wr_Addr_Bin = 9'b0000_0000_0;
Rd_Addr_Bin = 9'b0000_0000_0;

Sync_Wr_Addr0_Gray = 9'b0000_0000_0;
Sync_Wr_Addr1_Gray = 9'b0000_0000_0;
Sync_Wr_Addr2_Gray = 9'b0000_0000_0;

Sync_Rd_Addr0_Gray = 9'b0000_0000_0;
Sync_Rd_Addr1_Gray = 9'b0000_0000_0;
Sync_Rd_Addr2_Gray = 9'b0000_0000_0;
end
//=======================================================//
//FIFO Data write in and read out
//=======================================================//
assign FIFO_Exit_Addr = Rd_Addr_Bin[`ADDR_WIDTH-1:0];
assign FIFO_Entry_Addr = Wr_Addr_Bin[`ADDR_WIDTH-1:0];

assign Dout = Buff[FIFO_Exit_Addr];     //Read Data
always @(posedge wr_clk)
begin
    if(wr_en & ~Full)                  //Write enable active is high and  Full
    begin
        Buff[FIFO_Entry_Addr] <= Din;
    end
    else
    begin
        Buff[FIFO_Entry_Addr] <= Buff[FIFO_Entry_Addr];
    end
end
//=======================================================//
//Generate Write Address and Read Address using Gray Code
//=======================================================//
assign Wr_NextAddr_Bin = (wr_en&~Full)?Wr_Addr_Bin[`ADDR_WIDTH:0]+1'b1:Wr_Addr_Bin[`ADDR_WIDTH:0];
assign Rd_NextAddr_Bin = (rd_en&~Empty)?Rd_Addr_Bin[`ADDR_WIDTH:0]+1'b1:Rd_Addr_Bin[`ADDR_WIDTH:0];

assign Wr_NextAddr_Gray = (Wr_NextAddr_Bin >> 1) ^ Wr_NextAddr_Bin;     //Binary to Gray
assign Rd_NextAddr_Gray = (Rd_NextAddr_Bin >> 1) ^ Rd_NextAddr_Bin;     

always @(posedge wr_clk)
begin
    Wr_Addr_Bin <= Wr_NextAddr_Bin;
    Sync_Wr_Addr0_Gray <= Wr_NextAddr_Gray;
end

always @(posedge rd_clk)
begin
    Rd_Addr_Bin <= Rd_NextAddr_Bin;
    Sync_Rd_Addr0_Gray <= Rd_NextAddr_Gray;
end
//=======================================================//
//Synchnorous the Asynchnorous signal with dual latch
//=======================================================//
always @(posedge wr_clk)
begin
    Sync_Wr_Addr2_Gray <= Sync_Wr_Addr1_Gray;
    Sync_Wr_Addr1_Gray <= Sync_Wr_Addr0_Gray;
end

always @(posedge rd_clk)
begin
    Sync_Rd_Addr2_Gray <= Sync_Rd_Addr1_Gray;
    Sync_Rd_Addr1_Gray <= Sync_Rd_Addr0_Gray;
end
//=======================================================//
//Synchnorous time domain for Full signal and Empty signal
//=======================================================//
assign Asyn_Empty = (Rd_NextAddr_Gray==Sync_Wr_Addr2_Gray);
assign Asyn_Full = (Wr_NextAddr_Gray=={~Sync_Rd_Addr2_Gray[`ADDR_WIDTH:`ADDR_WIDTH-1],Sync_Rd_Addr2_Gray[`ADDR_WIDTH-2:0]});

always @(posedge wr_clk)
begin
    Full <= Asyn_Full;
end 

always @(posedge rd_clk)
begin
    Empty <= Asyn_Empty;
end 

endmodule
