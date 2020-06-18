/**
 *
 *  file: TOT_fineEncoder_tb.v
 *
 *  TOT_fineEncoder_tb.v
 *  Encode the fine phase from 21 bits therometer code to 7 bits binary code
 *
 *  History:
 * 	2020/04/30 Wei Zhang	 : revised and verified for ETROC2 TDC
 **/
`timescale 1ns/1ps

module TOT_fineEncoder_tb(
);
reg [20:0] encode_In;
reg clk;

wire [5:0] Binary_Out;
wire [1:0] bubbleError;

integer fp_r;
integer count = 0;
integer cnt;
integer level = 2'b01;


//===============================================================================//
initial begin
	$dumpfile("myfile.vcd");
	clk = 1'b0;
	encode_In = 21'b1_0101_0101_0101_0101_0101;
	#1000;
	fp_r = $fopen("TOT_Raw_Data_Decimal.dat", "r");
	$dumpvars("0, TOT_fineEncoder_tb");
	#200000 $stop;
end
 
//===============================================================================//
always @(posedge clk)
begin
	if(count < 126)
	begin
		cnt = $fscanf(fp_r, "%d", encode_In);
		$display("%b", encode_In);
		count <= count + 1'b1;
	end
	else
	begin
		count <= 0;
		$fclose(fp_r);
	end
end

//===============================================================================//
always begin
	#200 clk = ~clk;	
end

TOT_fineEncoder TOT_fineEncoder_tt(
	.encode_In(encode_In),				// 21-bit thermometer code from TOA sample DFFs
	.level(level),						// Bubble tolerance, proper values of level = 1, 2, 3
	.Binary_Out(Binary_Out),			// 6-bit binary output code
	.bubbleError(bubbleError)			// bubble Error
);

endmodule
