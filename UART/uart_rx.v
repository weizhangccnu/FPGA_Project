module uart_rx(clk,rst_n,rx_data,rs232_rx,clk_bps,bps_start,rx_int);
input clk,rst_n;
input clk_bps;  //clk_bps的高电平为接收数据位的中间采样点
input rs232_rx;  
output bps_start;  //接收到数据后，波特率时钟启动信号置位
output rx_int;   //接收数据中断信号,接收到数据期间始终为高电平
output [7:0]rx_data;

reg rs232_rx0,rs232_rx1,rs232_rx2,rs232_rx3;	//接收数据寄存器，滤波用
wire neg_rs232_rx;	//表示数据线接收到下降沿

always @(posedge clk or negedge rst_n) 
begin
     if(!rst_n)
	     begin
            rs232_rx0 <= 1'b0;
            rs232_rx1 <= 1'b0;
            rs232_rx2 <= 1'b0;
            rs232_rx3 <= 1'b0;
        end
	 else
	     begin
            rs232_rx0 <= rs232_rx;
            rs232_rx1 <= rs232_rx0;
            rs232_rx2 <= rs232_rx1;
            rs232_rx3 <= rs232_rx2;
		 end
end
assign neg_rs232_rx = rs232_rx3 & rs232_rx2 & ~rs232_rx1 & ~rs232_rx0;	//接收到下降沿后neg_rs232_rx置高一个时钟周期

reg bps_start_r;
reg[3:0] num;	//移位次数
reg rx_int;		//接收数据中断信号,接收到数据期间始终为高电平

always @(posedge clk or negedge rst_n)
begin
     if(!rst_n)
	     begin
            bps_start_r <= 1'bZ;
            rx_int <= 1'b0;
		  end
	  else if(neg_rs232_rx)  //接收到串口接收线rs232_rx的下降沿标志信号
	     begin
            bps_start_r <= 1'b1;	//启动串口准备数据接收
            rx_int <= 1'b1;			//接收数据中断信号使能
		  end
	  else if(num == 4'd12)  //接收完有用数据信息
	     begin
            bps_start_r <= 1'b0; //接收完数据释放波特率时钟信号
            rx_int <= 1'b0; //接收数据中断信号关闭
		  end
end
assign bps_start = bps_start_r;

reg[7:0] rx_data;  //串口接收数据寄存器，保存直至下一个数据来到
reg[7:0] rx_temp_data;  //当前接收数据寄存器

always @(posedge clk or negedge rst_n)
begin
     if(!rst_n)
	     begin
		    rx_temp_data <= 8'd0;
			 num <= 4'd0;
			 rx_data <= 8'd0;
		  end
	  else if(rx_int) begin  //接收数据处理
	     if(clk_bps) begin  //读取并保存数据,接收数据为一个起始位，8bit数据，1个结束位
		     num <= num+1'b1;
			  case(num)
			      4'd1: rx_temp_data[0] <= rs232_rx;	//锁存第0bit
					4'd2: rx_temp_data[1] <= rs232_rx;	//锁存第1bit
					4'd3: rx_temp_data[2] <= rs232_rx;	//锁存第2bit
					4'd4: rx_temp_data[3] <= rs232_rx;	//锁存第3bit
					4'd5: rx_temp_data[4] <= rs232_rx;	//锁存第4bit
					4'd6: rx_temp_data[5] <= rs232_rx;	//锁存第5bit
					4'd7: rx_temp_data[6] <= rs232_rx;	//锁存第6bit
					4'd8: rx_temp_data[7] <= rs232_rx;	//锁存第7bit
			      default: ;
				endcase
		  end
		  else if(num == 4'd12) //标准接收模式下只有1+8+1=10bit的有效数据
		     begin		
				 num <= 4'd0;			//接收到STOP位后结束,num清零
				 rx_data <= rx_temp_data;	//把数据锁存到数据寄存器rx_data中
			  end
      end
end
endmodule

		    
		    












