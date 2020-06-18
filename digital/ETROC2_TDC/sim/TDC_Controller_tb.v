/**
 *
 *  file: TDC_Controller.v
 *
 *  TDC Controller behavior describe
 *
 *  History:
 *  2020/06/16 Datao, Wei Zhang    : Created
 **/
`timescale 1ps/100fs

//--------------------------------------------------------------->
module TDC_Controller_tb();
//------------ input ports ------------//
reg pulse;
reg clk40;
reg clk320;
reg enable;
reg testMode;
reg polaritySel;
reg resetn;
reg autoReset;

wire start;
wire TOA_Clk;
wire TOA_Latch;
wire TOT_Clk;
wire Counter_RSTN;
wire RawdataWrtClk;
wire EncdataWrtClk;
wire ResetFlag;


parameter TOA = 3000;
parameter TOT = 6000;
integer i = 0;
//-------------- initial ----------------//
initial begin
	clk40 = 1'b0;
	clk320 = 1'b0;
	pulse = 1'b0;
	enable = 1'b1;
	testMode = 1'b0;
	polaritySel = 1'b1;
	resetn = 1'b0;
	autoReset = 1'b0;
	
	#100 resetn = 1'b1;
	#1000000 $stop;
end



// 40M clock generate
always begin
	#12500 clk40 = ~clk40;
end

// 320M clock generate
always begin
	#12500 clk320 = 1'b1;
	#1562.5 clk320 = 1'b0;
	#1562.5 clk320 = 1'b1;
	#1562.5 clk320 = 1'b0;
	#7812.5 clk320 = 1'b0;
end

// pulse generate
initial begin
	for(i=0;i<10;i=i+1) begin
		#(12500-TOA) pulse=1'b1; //#(12500-TOA) pulse=1'b1
		#TOT pulse=0;
		#(12500-TOT+TOA) pulse=0; //#(37500-TOT+TOA) pulse=0
	end
	#400000 for(i=0;i<10;i=i+1) begin
		#(12500-TOA) pulse=1'b1; //#(12500-TOA) pulse=1'b1
		#TOT pulse=0;
		#(12500-TOT+TOA) pulse=0; //#(37500-TOT+TOA) pulse=0
	end
end
/*
always begin
	for(i=0;i<10;i=i+1) begin
		#(12500-TOA) pulse=1'b1; //#(12500-TOA) pulse=1'b1
		#TOT pulse=0;
		#(12500-TOT+TOA) pulse=0; //#(37500-TOT+TOA) pulse=0
	end
	end
*/
//===================== TDC Controller instantation =====================//
TDC_Controller TDC_Controller_tt(
	.pulse(pulse),						// pulse input
	.clk40(clk40),						// 40M reference clock
	.clk320(clk320), 					// 320M reference strobe
	.enable(enable),					// TDC Controller enable
	.testMode(testMode), 				// Test Mode, high active
	.polaritySel(polaritySel),			// output clock polarity select
	
	.resetn(resetn),					// Controller external reset, low level active
	.autoReset(autoReset),				// Controller auto reset, low level active 
	
	.start(start),						// Delay Line Oscillate Start signal
	.TOA_Clk(TOA_Clk),					// TOA Data capture clock
	.TOA_Latch(TOA_Latch),				// TOA Data latch clock
	.TOT_Clk(TOT_Clk),					// TOT Data capture clock
	.Counter_RSTN(Counter_RSTN),		// Ripple Counter reset signal, low active

	.RawdataWrtClk(RawdataWrtClk),		// Raw data latch to Encoder
	.EncdataWrtClk(EncdataWrtClk),		// Encoded data latch out
	.ResetFlag(ResetFlag)				// Reset Flag
);
endmodule
//---------------------------------------------------------------<
