//testbench TOA_Encoder
//Auther: Wei Zhang
//Date: April 16, 2019
//Address: SMU Dallas TX.

`timescale 1ns / 1ps

module TOA_Encoder_tb(

);
reg [62:0] TOARaw;
reg [2:0] TOACntA;
reg [2:0] TOACntB;
reg clk;

wire [2:0] outputCoarsePhase;
wire [6:0] outputFinePhase;
wire errorFlag;

integer fp_r, fp_w;
integer count = 0;
integer cnt;
integer level = 3'b011;
integer offset = 7'b000_0000;
integer selRawCode = 1'b0;
//====================================================================//
initial begin
	$dumpfile("myfile.vcd");					// define VCD filename
	clk = 1'b0;
	TOARaw = 63'b010_1010_1010_1111_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101;
	TOACntA = 3'b010;
	TOACntB = 3'b000;
	#1000;
	fp_r = $fopen("TOARaw_data.dat", "r");		// Open a data file
	fp_w = $fopen("TOA_Encoder_output.dat", "w");
	$dumpvars("0, TOA_Encoder_tb");				// record simulation waveform
	#2000000 $stop;
end


//====================================================================//
always @(posedge clk)
begin
	if(count<3960)
	begin
		cnt = $fscanf(fp_r, "%d %d %d", TOACntA, TOACntB, TOARaw);		//read TOARaw_data.dat file row by row.
		$fwrite(fp_w, "%3f %d\n", (0.4+0.001*count), (outputCoarsePhase*128+outputFinePhase));
		$display("%b %b %b", TOACntA, TOACntB, TOARaw);					//Display TOACntA, TOACntB and TOARaw data
		count <= count + 1;
	end
	else
	begin
		count <= 0;
		$fclose(fp_r);
	end
end
//====================================================================//
always begin
	#200 clk <= ~clk;
end
//====================================================================//
TOA_Encoder TOA_Encoder_tt(						//invoke TOA_Encoder module
.A(TOARaw),
.level(level),
.counterA(TOACntA),
.counterB(TOACntB),
.offset(offset),
.selRawCode(selRawCode),
.outputCoarsePhase(outputCoarsePhase),
.outputFinePhase(outputFinePhase),
.errorFlag(errorFlag)
);
endmodule
