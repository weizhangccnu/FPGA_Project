// author: WeiZhang
// date: 2023-03-28
// description: uart receive

module uart_rx(
	input clk,
	input rst_n,
	input uart_rx,
	output reg uart_rx_done,
	output reg [7:0] data
);

parameter CLK_FREQ = 50000000;				// clcok frequency
parameter UART_BPS = 9600;					// serial port buad
localparam PERIOD = CLK_FREQ/UART_BPS;		// period of a UI

// receive data
reg [7:0] rx_data;

reg rx1, rx2;
wire start_bit;
reg start_flag;

reg [15:0] cnt0;
wire add_cnt0;
wire end_cnt0;

reg [3:0] cnt1;
wire add_cnt1;
wire end_cnt1;

// falling edge check
always @(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		rx1 <= 1'b0;
		rx2 <= 1'b0;
	end
	else
	begin
		rx1 <= uart_rx;
		rx2 <= rx1;
	end
end

assign start_bit = rx2 & (~rx1);

// start flag
always @(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)				//sync reset
	begin
		start_flag <= 1'b0;
	end
	else if(start_bit)                 // check the first falling edge of uart_rx
	begin
		start_flag <= 1'b1;
	end
	else if(end_cnt1)
	begin
		start_flag <= 1'b0;
	end
end

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
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

assign add_cnt0 = start_flag;
assign end_cnt0 = add_cnt0 && cnt0==PERIOD-1;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
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
assign end_cnt1 = (cnt0==((PERIOD-1)/2))&&(cnt1==10-1);

// data receive 
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		rx_data <= 8'd0;
	end
	else if(start_flag)
	begin
		if(cnt0 == PERIOD/2)
		begin
			case(cnt1)
				4'd1: rx_data[0] <= rx2;
				4'd2: rx_data[1] <= rx2;
				4'd3: rx_data[2] <= rx2;
				4'd4: rx_data[3] <= rx2;
				4'd5: rx_data[4] <= rx2;
				4'd6: rx_data[5] <= rx2;
				4'd7: rx_data[6] <= rx2;
				4'd8: rx_data[7] <= rx2;
				default: rx_data <= rx_data;
			endcase
		end
		else
		begin
			rx_data <= rx_data;
		end
	end
	else
	begin
		rx_data <= 8'd0;
	end
end

// data receive
always @(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		data <= 0;
	end
	else if(end_cnt1)
	begin
		data <= rx_data;
	end
end

// receive finish flag
always @(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		uart_rx_done <= 1'b0;
	end
	else if(end_cnt1)
	begin
		uart_rx_done <= 1'b1;
	end
	else
	begin
		uart_rx_done <= 1'b0;
	end
end
endmodule
