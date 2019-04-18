/**
 *
 *  file: TDC_controller_tb.v
 *
 *  TDC_delayLine
 *  ideal delayline controller for test
 *
 *  History:
 *	2019/03/15 Hanhan Sun    : Created
 **/

`timescale 1ps/100fs

//******Module Declaration******
module TDC_controller_tb;

//******Signal Declaration******
reg pulse;
reg clk40;
reg clk320;
reg enable;
reg testMode;
reg polaritySel;
reg resetn;
reg auotoReset;

wire  start;
wire  TOA_clk;
wire  TOA_Latch;	
wire  TOT_clk;
wire  TOTReset;
wire  TOAReset;	
wire RawdataWrtClk;
wire EncdataWrtClk;
wire ResetFlag;

parameter TOA = 3000; //typical : 3000
parameter TOT = 6000; //typical : 6000


//******Instantiation of Top-level Design******
TDC_controller UT0
(
	.pulse(pulse),
	.clk40(clk40),
	.clk320(clk320),
	.enable(enable),
	.testMode(testMode),
	.polaritySel(polaritySel),
	.resetn(resetn),
	.auotoReset(auotoReset),
	.start(start),
	.TOA_clk(TOA_clk),
	.TOA_Latch(TOA_Latch),	
	.TOT_clk(TOT_clk),
	.TOTReset(TOTReset),
	.TOAReset(TOAReset),	
	.RawdataWrtClk(RawdataWrtClk),
	.EncdataWrtClk(EncdataWrtClk),
	.ResetFlag(ResetFlag)
);

//******Provide Stimulus******
	initial begin //this process block specifies the stimulus.
		pulse=0;
		clk40=0;
		clk320=0;
		enable=1'b1;
		testMode=0;
		polaritySel=1'b1;
		resetn=0;
		auotoReset=0;

		#50 resetn=1'b1;
		#200000 $stop;
	end
	
always
		#12500 clk40 = !clk40;
		
			
always 
		begin
		#12500 clk320=1'b1;
		#1562.5 clk320=0;
		#1562.5 clk320=1'b1;
		#1562.5 clk320=0;
		#7812.5 clk320=0;
		end

always 
		begin
		#(37500-TOA) pulse=1'b1; //#(12500-TOA) pulse=1'b1; 
		#TOT pulse=0;
		#(12500-TOT+TOA) pulse=0; //#(37500-TOT+TOA) pulse=0;
		end
	
endmodule
