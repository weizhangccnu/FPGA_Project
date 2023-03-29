// author: WeiZhang
// date: 2023-03-28
// description: uart

module uart(
	input clk,
	input rst_n,
	input uart_rx,
	output uart_tx,
	output [7:0] rx_data,
	output uart_rx_done,
	input [7:0] tx_data,
	input tx_start
);
wire [7:0] rx_data;
//wire [7:0] tx_data;
//wire uart_rx_done;
//wire tx_start;

// invoke uart_rx module
uart_rx uart_rx_inst(
	.clk(clk),
	.rst_n(rst_n),
	.uart_rx(uart_rx),
	.uart_rx_done(uart_rx_done),
	.data(rx_data)
);

uart_tx uart_tx_inst(
	.clk(clk), 
	.rst_n(rst_n),
	.uart_tx(uart_tx), 
	.data(tx_data),
	.tx_start(tx_start)
);

endmodule