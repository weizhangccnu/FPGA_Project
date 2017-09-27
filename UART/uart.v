module uart(clk,rst_n,rs232_rx,rs232_tx);
input clk,rst_n;
input rs232_rx;
output rs232_tx;
wire bps_start1,bps_start2; //接收到数据后，波特率时钟启动信号置位
wire clk_bps1,clk_bps2;     //clk_bps_r高电平为接收数据位的中间采样点,同时也作为发送数据的数据改变点
wire [7:0]rx_data;          //接收数据寄存器
wire [7:0]tx_data_r;        //发送数据寄存器
reg [7:0]tx_data;           //发送数据寄存器

wire rx_int;                //接收数据中断信号,接收到数据期间始终为高电平
reg rst_pulse = 1'b1;
reg tx_int0;                //信号寄存器,捕捉下降沿
wire neg_tx_int;            //下降沿标志
reg flag = 1'b0;    
reg [16:0]cont;
reg [1:0]cont1 = 2'b00;

reg rx_int0,rx_int1,rx_int2;//信号寄存器,捕捉下降沿
wire neg_rx_int;    //下降沿标志

always @(posedge clk or negedge rst_n) 
begin
    if(!rst_n) 
        begin
            rx_int0 <= 1'b0;
            rx_int1 <= 1'b0;
            rx_int2 <= 1'b0;
        end
    else 
        begin
            rx_int0 <= rx_int;
            rx_int1 <= rx_int0;
            rx_int2 <= rx_int1;
        end
end
 
assign neg_rx_int = ~rx_int1 & rx_int2;     //capture negedge of rx_int to reset flag
assign neg_tx_int = tx_int0 ^ rst_pulse;    //generate a pulse

always @(posedge clk)                       
begin
    if(!rst_n)
    begin
        cont <= 17'd0;
        flag <= 1'b0;
        cont1 <= 2'd0;
        tx_int0 <= 1'b0;
        rst_pulse <= 1'b1;
    end
    else
    begin
        if(neg_rx_int)                  //to reset flag and to receive other character 
        begin
            flag <= 1'b0;
        end
        tx_int0 <= rst_pulse;           //generate sent pulse
        cont <= cont + 1'b1;
        if(cont == 17'd100000000)       //sent interval time
        begin
            cont <= 17'd0;
            if(rx_data == 8'h31 && flag == 1'b0)                //if received '1'(8'h31) 
            begin
                case(cont1)                                     //sent 'C', 'C', 'N', 'U'
                2'd0:  begin tx_data <= 8'h43; rst_pulse <= ~rst_pulse; cont1 <= 2'd1; end                                 //sent 'C'
                2'd1:  begin tx_data <= 8'h43; rst_pulse <= ~rst_pulse; cont1 <= 2'd2; end                                 //sent 'C'
                2'd2:  begin tx_data <= 8'h4E; rst_pulse <= ~rst_pulse; cont1 <= 2'd3; end                                 //sent 'N'
                2'd3:  begin tx_data <= 8'h55; rst_pulse <= ~rst_pulse; flag <= 1'b1; cont1<= 2'd0; end                     //sent 'U'
                default: begin tx_data <= 8'h24; rst_pulse <= rst_pulse; flag <= 1'b1; end
                endcase
            end
            else if(rx_data == 8'h32 && flag == 1'b0)           //if received '2'(8'h32)
            begin 
                case(cont1)                                     //sent 'P', 'L', 'A', 'C'
                2'd0:  begin tx_data <= 8'h50; rst_pulse <= ~rst_pulse; cont1 <= 2'd1; end                                 //sent 'P'
                2'd1:  begin tx_data <= 8'h4C; rst_pulse <= ~rst_pulse; cont1 <= 2'd2; end                                 //sent 'L'
                2'd2:  begin tx_data <= 8'h41; rst_pulse <= ~rst_pulse; cont1 <= 2'd3; end                                 //sent 'A'
                2'd3:  begin tx_data <= 8'h43; rst_pulse <= ~rst_pulse; flag <= 1'b1; cont1<= 2'd0; end                     //sent 'C'
                default: begin tx_data <= 8'h24; rst_pulse <= rst_pulse; flag <= 1'b1; end
                endcase
            end
        end
    end
end

assign tx_data_r = tx_data;

speed_select  speed_rx_inst(
.clk(clk),
.rst_n(rst_n),
.clk_bps(clk_bps1),
.bps_start(bps_start1)
);
		 
speed_select  speed_tx_inst(
.clk(clk),
.rst_n(rst_n),
.clk_bps(clk_bps2),
.bps_start(bps_start2)
);
		 
uart_rx  uart_rx_inst(
.clk(clk),
.rst_n(rst_n),
.rx_data(rx_data),    //??
.rx_int(rx_int),
.clk_bps(clk_bps1),
.bps_start(bps_start1),
.rs232_rx(rs232_rx)
);
						
uart_tx  uart_tx_inst(
.clk(clk),
.rst_n(rst_n),
.rx_data(tx_data_r),
.rx_int(neg_tx_int),
.clk_bps(clk_bps2),
.bps_start(bps_start2),
.rs232_tx(rs232_tx)
);
						
endmodule
		 
