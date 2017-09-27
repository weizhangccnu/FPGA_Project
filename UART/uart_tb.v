`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2017 09:03:00 AM
// Design Name: 
// Module Name: uart_tb
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


module uart_tb(

    );
reg CLK = 1'b0;
reg RST_N = 1'b1;
reg RS232_RX = 1'b1;
wire RS232_TX;
integer i = 0;
integer TX_Data1 = 10'h262;
integer TX_Data2 = 10'h262;
integer TX_Data3 = 10'h264;
initial begin

#1000 RST_N = 1'b1;
#1000 RST_N = 1'b0;
#1000 RST_N = 1'b1;
#2000 RS232_RX = 1'b1;
for(i=0; i<10;i=i+1)
begin
RS232_RX <= TX_Data1 & 10'h01;
#104166    TX_Data1 = TX_Data1 >> 1;
end

#20000000 RS232_RX = 1'b1;
for(i=0; i<10;i=i+1)
begin
RS232_RX <= TX_Data2 & 10'h01;
#104166    TX_Data2 = TX_Data2 >> 1;
end

#20000000 RS232_RX = 1'b1;
for(i=0; i<10;i=i+1)
begin
RS232_RX <= TX_Data3 & 10'h01;
#104166    TX_Data3 = TX_Data3 >> 1;
end
end


always begin
#12.5 CLK <= ~CLK;
end
    
uart uart_tt(
.clk(CLK),
.rst_n(RST_N),
.rs232_rx(RS232_RX),
.rs232_tx(RS232_TX)
);
endmodule
