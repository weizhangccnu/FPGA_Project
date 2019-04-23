/**
 *
 *  file: TOT_Encoder_tb.v
 *
 *  TOT_Encoder_tb
 *  Encode the phase information based on two counters and fine phase.
 *
 *  History:
 *  2019/04/23 Wei Zhang    : Created
 *
 **/
`timescale 1ns/1ps

module TOT_Encoder_tb(

);
reg clk;
reg [31:0]TOTRaw;
reg [2:0]TOTCntA;
reg [2:0]TOTCntB;

wire [2:0]outputCoarsePhase;
wire [5:0]outputFinePhase;
wire errorFlag;

integer fp_r, fp_w;					// define a file pointer
integer count = 0;					// define a counter
integer cnt;
integer level = 3'b011;				// bubble error tolerance 
integer offset = 6'b00_0000;		// matestable windown offset
integer selRawCode = 1'b0;			// selected combination code
//===================================================================//
initial begin
	clk = 1'b1;
	TOTCntA = 3'b011;
	TOTCntB = 3'b010;
	TOTRaw = 32'b1100_0000_0000_0000_0000_0000_0000_0000;
	#1000;
	fp_r = $fopen("TOTRaw_data.dat", "r");				//open a data file
	fp_w = $fopen("TOT_Encoder_output.dat", "w");		//TOT encoder output file
	#2000000 $stop;
end
//===================================================================//
always @(posedge clk)
begin
	if(count < 3960)
	begin 
		cnt = $fscanf(fp_r, "%d %d %d", TOTCntA, TOTCntB, TOTRaw);		//read TOTRaw data file row by row
		$fwrite(fp_w,"%3f %d\n", (0.4+0.001*count), (outputCoarsePhase*64+outputFinePhase));
		$display("%b %b %b", TOTCntA, TOTCntB, TOTRaw);
		count <= count + 1'b1;
	end
	else
	begin
		count <= 0;
		$fclose(fp_r);
		$fclose(fp_w);
	end
end
//===================================================================//
always begin	
	#200 clk <= ~clk;
end
//===================================================================//
TOT_Encoder TOT_Encoder_tt(
.A(TOTRaw),							//input DFFs
.level(level), 						//user defined error tolerance.
.counterA(TOTCntA), 				//ripple Counter A at tap 31 with positive input
.counterB(TOTCntB), 				//ripple Counter B at tap 31 with negative input
.offset(offset),  					//user defined offset, default is 0
.selRawCode(selRawCode),			//output corrected code or raw code, defined by user
.outputCoarsePhase(outputCoarsePhase), //coarse phase
.outputFinePhase(outputFinePhase), 	//output fine phase code
.errorFlag(errorFlag)
);
endmodule


