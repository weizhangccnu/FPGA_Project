/* 
 * filename: ETROC2_TDC.v 
 * 
 * ETROC2 TDC Behavior model to verify the Delay Line and Encoder function.
 * 
 * History:
 *   2020/06/17	Datao, Wei Zhang 	: Created 		
 *
 */

//--------------------------------------------------------------->

`timescale 1ps/100fs 

module ETROC2_TDC(
	//----- interface for Controller -----//
	input pulse,						// TDC measurement signal input
	input clk40,						// 40M reference clock input
	input clk320, 						// 320M clock strobe 
	input enable, 						// TDC Enable
	input testMode,						// TDC work on test mode
	input polaritySel,					// clock pulse polarity select
	input resetn,						// external reset signal
	input autoReset,					// autoReset signal, high active

 	//----- interface for Encoder -----//
	input [1:0] level,					// bubble tolerance level
	input [6:0] offset,					// ripple window offset
	input timeStampMode,				// Cal data time stamp mode, 1: Cal, 0: Cal - TOA

	output [9:0] TOA_codeReg,			// TOA encoded data
	output [8:0] TOT_codeReg, 			// TOT encoded data
	output [9:0] Cal_codeReg,			// Cal encoded data
	output hitFlag,						// hitFlag
	output TOAerrorFlagReg,				// TOA encoded data error flag
	output TOTerrorFlagReg,				// TOT encoded data error flag
	output CalerrorFlagReg				// TOA encoded data error flag
);


//----------------------- Controller -----------------------//
wire Start;
wire TOA_Clk;
wire TOT_Clk;
wire TOA_Latch;
wire Counter_RSTN;

wire RawdataWrtClk;
wire EncdataWrtClk;
wire ResetFlag;

wire [62:0] TOARawData;
wire [20:0] TOTRawData;
wire Counter_Clk;						// ripple counter driver clock


TDC_Controller TDC_Controller_tt(
	.pulse(pulse),						// pulse input
	.clk40(clk40),						// 40M reference clock
	.clk320(clk320), 					// 320M reference strobe
	.enable(enable),					// TDC Controller enable
	.testMode(testMode), 				// Test Mode, high active
	.polaritySel(polaritySel),			// output clock polarity select
	
	.resetn(resetn),					// Controller external reset, low level active
	.autoReset(autoReset),				// Controller auto reset, low level active 
	
	.start(Start),						// Delay Line Oscillate Start signal
	.TOA_Clk(TOA_Clk),					// TOA Data capture clock
	.TOA_Latch(TOA_Latch),				// TOA Data latch clock
	.TOT_Clk(TOT_Clk),					// TOT Data capture clock
	.Counter_RSTN(Counter_RSTN),		// Ripple Counter reset signal, low active

	.RawdataWrtClk(RawdataWrtClk),		// Raw data latch to Encoder
	.EncdataWrtClk(EncdataWrtClk),		// Encoded data latch out
	.ResetFlag(ResetFlag));				// Reset Flag

//----------------------- Delay Line -----------------------//

TDC_Delay_Line TDC_Delay_Line_tt(
	.Start(Start),						// Start signal
	.TOA_Clk(TOA_Clk),					// TOA fine time data capture clock
	.TOT_Clk(TOT_Clk),					// TOT fine time data capture clock
	.TOARawData(TOARawData),			// TOARawData[62:0]
	.TOTRawData(TOTRawData),			// TOTRawData[20:0]
	.Counter_Clk(Counter_Clk));			// Ripple Counter driver clock

//----------------------- Encoder -----------------------//
TDC_Encoder TDC_Encoder_tt(
	.Counter_Clk(Counter_Clk),			// Ripple Counter Driver clock
	.Counter_RSTN(Counter_RSTN),		// Ripple counter reset, low active
	.TOA_Clk(TOA_Clk),					// TOA coarse time capture clock
	.TOT_Clk(TOT_Clk), 					// TOT coarse time capture clock
	.TOA_Latch(TOA_Latch),				// TOA Coarse time latch clock

	.TOTRawData(TOTRawData),			// TOTRawData[31:0] alter to TOTRawData[20:0]
	.CalRawData(TOARawData),			// TOARawData[62:0] 
	
	.RawdataWrtClk(RawdataWrtClk),		// TDC Raw data capture
	.EncdataWrtClk(EncdataWrtClk),		// TDC Encoded data latch out
	.ResetFlag(ResetFlag),				// Resetflag

	.level(level), 						// user defined error tolerance.
	.offset(offset),  					// user defined offset, default is 0
    .timeStampMode(timeStampMode), 		// if it is true, output calibration code as timestamp
	
	.TOT_codeReg(TOT_codeReg),			// TOT Encoded data
	.TOA_codeReg(TOA_codeReg),			// TOA Encoded data
	.Cal_codeReg(Cal_codeReg),			// Cal Encoded data
    .hitFlag(hitFlag),					// Hit flag 
	.TOTerrorFlagReg(TOTerrorFlagReg),	// TOT data error flag
	.TOAerrorFlagReg(TOAerrorFlagReg),	// TOA data error flag
	.CalerrorFlagReg(CalerrorFlagReg));	// Cal data error flag

endmodule

//--------------------------------------------------------------->
