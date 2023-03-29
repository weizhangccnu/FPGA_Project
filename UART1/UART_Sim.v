`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/29 09:15:14
// Design Name: 
// Module Name: UART_Sim
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
module UART_Sim();
reg clk;                    // clock frequency 50 MHz
reg rst_n;                  // reset signal, low active
reg uart_rx;                // uart rx port 
reg [7:0] tx_data;          // tx data
reg tx_start;               // tx start
wire uart_tx;               // uart tx port 
wire uart_rx_done;          // uart rx done signal 

integer i=0;
integer TX_Data = 10'h262;
initial 
begin
    clk = 1'b0; 
    uart_rx = 1'b1;
    tx_start = 1'b0;
    rst_n = 1'b1;     
    #500 rst_n = 1'b0;
    #200 rst_n = 1'b1; 
    #50000000 $stop; 
end

initial 
begin
    #2000 uart_rx = 1'b1;              // rx port idle state 
    for(i=0; i<10; i=i+1)
    begin
        uart_rx = TX_Data & 10'h001;
        #104166 TX_Data = TX_Data >> 1;
    end
    
    #2000 tx_data = 8'h32;
    #100 tx_start = 1'b1;
    #100 tx_start = 1'b0;
end

always 
begin
    #10 clk <= ~clk;
end

uart uart_inst(
    .clk(clk),
    .rst_n(rst_n),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),
    .rx_data(rx_data),
    .uart_rx_done(uart_rx_done),
	.tx_data(tx_data),
    .tx_start(tx_start)
);
endmodule
