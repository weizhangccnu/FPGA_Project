/* 
 * filename: ETROC2_TDC_tb.v 
 * 
 * ETROC2 TDC Behavior model testbench to verify the Delay Line and Encoder function.
 * 
 * History:
 *   2020/06/17	: Create: Datao, Wei Zhang		
 *
 */

`timescale 1ps/100fs

//--------------------------------------------------------------->
module ETROC2_TDC_tb();
reg pulse;
reg clk40;
reg clk320;
reg enable;
reg testMode;
reg polaritySel;
reg resetn;
reg autoReset;

reg [1:0] level;					// bubble tolerance level
reg [6:0] offset;					// ripple window offset
reg timeStampMode;					// Cal data time stamp mode, 1: Cal, 0: Cal - TOA

wire [9:0] TOA_codeReg;				// TOA encoded data
wire [8:0] TOT_codeReg; 			// TOT encoded data
wire [9:0] Cal_codeReg;				// Cal encoded data
wire hitFlag;						// hitFlag
wire TOAerrorFlagReg;				// TOA encoded data error flag
wire TOTerrorFlagReg;				// TOT encoded data error flag
wire CalerrorFlagReg;				// TOA encoded data error flag

parameter TOA = 3000;
parameter TOT = 6000;
integer i = 0;
integer fp_w;						// file name for TDC output
//-------------- initial ----------------//
initial begin
	fp_w = $fopen("ETROC2_TDC_testMode=0_polaritySel=1_TOA_Scan_20200618.dat", "w");
	clk40 = 1'b0;
	clk320 = 1'b0;
	pulse = 1'b0;
	enable = 1'b1;
	testMode = 1'b0;
	polaritySel = 1'b1;
	resetn = 1'b0;
	autoReset = 1'b0;

	level = 2'b01;
	offset = 6'b000000;
	timeStampMode = 1'b0;		
	
	#100 resetn = 1'b1;
	#400000000 $stop;
end

// pulse_config define
task pulse_config;
	input [15:0] TOA_Input;
	input [15:0] TOT_Input;
begin
	#(12500-TOA_Input) pulse=1'b1; //#(12500-TOA) pulse=1'b1
	#TOT_Input pulse=0;
	#(12500-TOT_Input+TOA_Input) pulse=0; //#(37500-TOT+TOA) pulse=0
end
endtask


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
	for(i=10;i<12500;i=i+1) begin
		pulse_config(i, TOT);
		$fwrite(fp_w, "%5d %3d %3d %3d %1d\n", i, TOA_codeReg, TOT_codeReg, Cal_codeReg, hitFlag);
		$display("%5d %3d %3d %3d %1d", i, TOA_codeReg, TOT_codeReg, Cal_codeReg, hitFlag);
	end

end

ETROC2_TDC ETROC2_TDC_tt(
	//----- interface for Controller -----//
	.pulse(pulse),						// TDC measurement signal input
	.clk40(clk40),						// 40M reference clock input
	.clk320(clk320),					// 320M clock strobe 
	.enable(enable), 					// TDC Enable
	.testMode(testMode),				// TDC work on test mode
	.polaritySel(polaritySel),			// clock pulse polarity select
	.resetn(resetn),					// external reset signal
	.autoReset(autoReset),				// autoReset signal, high active

 	//----- interface for Encoder -----//
	.level(level),						// bubble tolerance level
	.offset(offset),					// ripple window offset
	.timeStampMode(timeStampMode),		// Cal data time stamp mode, 1: Cal, 0: Cal - TOA

	.TOA_codeReg(TOA_codeReg),			// TOA encoded data
	.TOT_codeReg(TOT_codeReg), 			// TOT encoded data
	.Cal_codeReg(Cal_codeReg),			// Cal encoded data
	.hitFlag(hitFlag),					// hitFlag
	.TOAerrorFlagReg(TOAerrorFlagReg),	// TOA encoded data error flag
	.TOTerrorFlagReg(TOTerrorFlagReg),	// TOT encoded data error flag
	.CalerrorFlagReg(CalerrorFlagReg)	// TOA encoded data error flag
);
endmodule

//--------------------------------------------------------------->
