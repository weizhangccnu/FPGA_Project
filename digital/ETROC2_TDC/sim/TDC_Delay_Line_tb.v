/**
 *
 *  file: TDC_Delay_Line_tb.v
 *
 *  TDC Delay Line Behavior test bench
 *
 *  History:
 *  2020/06/16 Wei Zhang    : Created
 **/
`timescale 1ps/100fs
//--------------------------------------------------------------->
module TDC_Delay_Line_tb();
reg Start;
reg TOA_Clk;
reg TOT_Clk;

wire [62:0] TOARawData;
wire [20:0] TOTRawData;
wire Counter_Clk;


initial	begin
	Start = 1'b0;
	TOA_Clk = 1'b0;
	TOT_Clk = 1'b0;	

	#100000 Start = 1'b1;
	#10000 TOA_Clk = 1'b1;
	#0 TOT_Clk = 1'b1;
	#200000 Start = 1'b0;

	#1000000 $stop;
end

TDC_Delay_Line TDC_Delay_Line_tt(
	.Start(Start),
	.TOA_Clk(TOA_Clk),
	.TOT_Clk(TOT_Clk),
	.TOARawData(TOARawData),
	.TOTRawData(TOTRawData),
	.Counter_Clk(Counter_Clk)
);

endmodule
//---------------------------------------------------------------<

