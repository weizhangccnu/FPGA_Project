// author: WeiZhang
// date: 2023-03-28
// description: uart receive

module uart_tx(
	input clk, 
	input rst_n,
	output reg uart_tx, 
	input [7:0] data,
	input tx_start
);

parameter CLK_FREQ = 50000000;
parameter UART_BPS = 9600;					// Baud
localparam PERIOD = CLK_FREQ/UART_BPS;		

reg [7:0] tx_data;				// send data 
reg start_tx_flag;				// send data flag

//calculate one bit need time
reg [15:0] cnt0;
wire add_cnt0;
wire end_cnt0;

// send several bits 
reg [3:0] cnt1;
wire add_cnt1;
wire end_cnt1;

// send flag
always @(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		start_tx_flag <= 1'b0;
		tx_data <= 1'b0;
	end
	else if(tx_start)					// tx_start is high
	begin
		start_tx_flag <= 1'b1;
		tx_data <= data;
	end
	else if(end_cnt1)
	begin
		start_tx_flag <= 1'b0;
	end
end

always @(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		cnt0 <= 1'b0;
	end
	else if(end_cnt1)
	begin
		cnt0 <= 1'b0;
	end
	else if(end_cnt0)
	begin
		cnt0 <= 1'b0;
	end
	else if(add_cnt0)
	begin
		cnt0 <= cnt0 + 1'b1;
	end
end
assign add_cnt0 = start_tx_flag;
assign end_cnt0 = add_cnt0 && cnt0 == PERIOD-1;

always @(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
	   cnt1 <= 1'b0;
	end
	else if(end_cnt1)
	begin
	   cnt1 <= 1'b0;
	end
	else if(add_cnt1)
	begin
	   cnt1 <= cnt1 + 1'b1;
	end
end
assign add_cnt1 = end_cnt0;
assign end_cnt1 = (cnt0==((PERIOD-1)/2)) && (cnt1==10-1);

always @(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		uart_tx <= 1'b1;			// idle state
	end
	else if(start_tx_flag)
	begin
		if(cnt0==1'b0)
		begin
			case(cnt1)
			4'd0: uart_tx <= 1'b0;		// start bit
			4'd1: uart_tx <= tx_data[0];
			4'd2: uart_tx <= tx_data[1];
			4'd3: uart_tx <= tx_data[2];
			4'd4: uart_tx <= tx_data[3];
			4'd5: uart_tx <= tx_data[4];
			4'd6: uart_tx <= tx_data[5];
			4'd7: uart_tx <= tx_data[6];
			4'd8: uart_tx <= tx_data[7];
			4'd9: uart_tx <= 1'b1;
			default: ;
			endcase
		end
	end
end
endmodule
	
