module speed_select(clk,rst_n,clk_bps,bps_start);
input clk,rst_n;
input bps_start;
output clk_bps;

//define bps_para 4166;  //波特率为9600时的分频计数值
//define bps_para_2 2083;  //波特率为9600时的分频计数值的一半，用于数据采样

reg[12:0]cnt;  //分频计数
reg clk_bps_r;  //波特率时钟寄存器
reg[2:0] uart_ctrl;	// uart波特率选择寄存器

always @ (posedge clk or negedge rst_n)
begin
     if(!rst_n) 
	     cnt <= 13'd0;
	  else if((cnt == 13'd4166)||!bps_start)  //波特率计数清零
	     cnt <= 13'd0;
	  else  //波特率时钟计数启动
	     cnt <= cnt+1'b1;    
end
always @ (posedge clk or negedge rst_n)
begin
     if(!rst_n) 
	     clk_bps_r <= 1'b0;
     else if(cnt == 13'd2083)
	     clk_bps_r <= 1'b1;  //clk_bps_r高电平为接收数据位的中间采样点,同时也作为发送数据的数据改变点
	 else
	     clk_bps_r <= 1'b0;
end
assign clk_bps = clk_bps_r;

endmodule
