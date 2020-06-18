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

module TOA_Encoder_tb(
);

reg [62:0] encode_In;
reg [2:0] TOA_CntA;
reg [2:0] TOA_CntB;
reg clk;
reg [1:0] level;
reg [6:0] offset;

wire [2:0] outputCoarsePhase;
wire [6:0] outputFinePhase;
wire errorFlag;


integer fp_r, fp_w;
integer count = 0;
integer cnt;

//===============================================================================//
initial begin
	$dumpfile("myfile.vcd");
	clk = 1'b0;
	level = 2'b11;
	offset = 7'b000_0000;
	encode_In = 63'b1010101_01010101_01010101_01010101_01010101_01010101_10101010_10101010;
	TOA_CntA = 0;
	TOA_CntB = 0;
	#1000;
	fp_r = $fopen("TOARaw_data.dat", "r");
	//fp_r = $fopen("ETROC2_TDC_TOA_Raw_Data.dat", "r");

	fp_w = $fopen("TDC_TOA_Encoder_Output.dat", "w");

	//$dumpvars("0, TOT_Encoder_tb");
	#250000 $stop;
end
 
//===============================================================================//
always @(posedge clk)
begin
	if(count < 3960)

	//if(count < 7790)
	begin
		cnt = $fscanf(fp_r, "%d %d %d", TOA_CntA, TOA_CntB, encode_In);
		$display("%b %b %b", encode_In, TOA_CntA, TOA_CntB);
		$fwrite(fp_w, "%3f %d\n", (0.7+0.001*count), (outputCoarsePhase*128+outputFinePhase));
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


TOA_Encoder TOA_Encoder_tt(
	.A(encode_In),					//input fine time DFFs
	.level(level), 					//user defined error tolerance.
	.counterA(TOA_CntA), 			//ripple Counter A at tap 31 with positive input
	.counterB(TOA_CntB), 			//ripple Counter B at tap 31 with negative input
	.offset(offset),  				//user defined offset, default is 0
	.outputCoarsePhase(outputCoarsePhase), 	//coarse phase
	.outputFinePhase(outputFinePhase), 	//output fine phase code
	.errorFlag(errorFlag)
);

endmodule
