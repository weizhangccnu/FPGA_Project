/**
 *
 *  file: TOT_Encoder_tb.v
 *
 *  TOT_Encoder_tb.v
 *  Encode the fine phase from 21 bits therometer code to 7 bits binary code and Encode the coarse phase from two ripple counter to 
 *
 *  History:
 * 	2020/04/30 Wei Zhang	 : revised and verified for ETROC2 TDC
 **/
`timescale 1ns/1ps

module TOT_Encoder_tb(
);

reg [20:0] encode_In;
reg [2:0] TOT_CntA;
reg [2:0] TOT_CntB;
reg clk;
reg [1:0] level;
reg [6:0] offset;

wire [2:0] outputCoarsePhase;
wire [5:0] outputFinePhase;
wire errorFlag;


integer fp_r, fp_w;
integer count = 0;
integer cnt;

//===============================================================================//
initial begin
	$dumpfile("myfile.vcd");
	clk = 1'b0;
	level = 2'b01;
	offset = 6'b00_0000;
	encode_In = 21'b1_0101_0101_0101_0110_1010;
	TOT_CntA = 0;
	TOT_CntB = 0;
	#1000;
	fp_r = $fopen("ETROC2_TDC_TOT_Raw_Data.dat", "r");
	fp_w = $fopen("TDC_TOT_Encoder_Output.dat", "w");
	//$dumpvars("0, TOT_Encoder_tb");
	#250000 $stop;
end
 
//===============================================================================//
always @(posedge clk)
begin
	if(count < 7790)
	begin
		cnt = $fscanf(fp_r, "%d %d %d", TOT_CntA, TOT_CntB, encode_In);
		$display("%b %b %b", encode_In, TOT_CntA, TOT_CntB);
		$fwrite(fp_w, "%3f %d\n", (0.7+0.001*count), (outputCoarsePhase*64+outputFinePhase));
		count <= count + 1'b1;
	end
	else
	begin
		count <= 0;
		$fclose(fp_r);
		$fclose(fp_w);
	end
end

//===============================================================================//
always begin
	#12.5 clk = ~clk;	
end


TOT_Encoder TOT_Encoder_tt(
	.A(encode_In),					//input fine time DFFs
	.level(level), 					//user defined error tolerance.
	.counterA(TOT_CntA), 			//ripple Counter A at tap 31 with positive input
	.counterB(TOT_CntB), 			//ripple Counter B at tap 31 with negative input
	.offset(offset),  				//user defined offset, default is 0
	.outputCoarsePhase(outputCoarsePhase), 	//coarse phase
	.outputFinePhase(outputFinePhase), 	//output fine phase code
	.errorFlag(errorFlag)
);

endmodule
