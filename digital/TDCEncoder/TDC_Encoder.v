/**
 *
 *  file: TDC_Encoder.v
 *
 *  TDC_Encoder
 *  Top level module of the TDC encoder, include TOA/TOT encoder.
 *
 *  History:
 *  2019/03/13 Datao Gong    : Created
 *
 **/
`timescale 1ns/1ps

module TDC_Encoder
(
	input [2:0] TOTCounterA,
	input [2:0] TOTCounterB,
	input [31:0] TOTRawData,

	input [2:0] TOACounterA,
	input [2:0] TOACounterB,
	input [62:0] TOARawData,

	input [2:0] CalCounterA,
	input [2:0] CalCounterB,
	input [62:0] CalRawData,
	
	input RawdataWrtClk,
	input EncdataWrtClk,
	input ResetFlag,
	
	input [2:0] level, //user defined error tolerance.
	input [6:0] offset,  //user defined offset, default is 0
	input selRawCode,//output corrected code or raw code, defined by user
    input timeStampMode, //if it is true, output calibration code as timestamp
	
	output reg [8:0] TOT_codeReg,
	output reg [9:0] TOA_codeReg,	
	output reg [9:0] Cal_codeReg,
    output reg hitFlag,	
	output reg TOTerrorFlagReg,
	output reg TOAerrorFlagReg,	
	output reg CalerrorFlagReg,	
	output reg [31:0] TOTRawDataReg, //output raw data for slow control
	output reg [62:0] TOARawDataReg,
	output reg [62:0] CalRawDataReg,
	output reg [2:0] TOTCounterAReg,
	output reg [2:0] TOTCounterBReg,	
	output reg [2:0] TOACounterAReg,
	output reg [2:0] TOACounterBReg,	
	output reg [2:0] CalCounterAReg,
	output reg [2:0] CalCounterBReg	
);

	wire [8:0] TOTcode;
	wire [9:0] TOAcode;
	wire [9:0] Calcode;

	always @(posedge RawdataWrtClk)
	begin
		TOTCounterAReg <= TOTCounterA;
		TOTCounterBReg <= TOTCounterB;		
		TOACounterAReg <= TOACounterA;
		TOACounterBReg <= TOACounterB;		
		CalCounterAReg <= CalCounterA;
		CalCounterBReg <= CalCounterB;				
		TOTRawDataReg <= TOTRawData;
		TOARawDataReg <= TOARawData;
		CalRawDataReg <= CalRawData;		
	end

	TOT_Encoder U_TOTEnc(.A(TOTRawDataReg),
						 .level(level),
						 .counterA(TOTCounterAReg),
						 .counterB(TOTCounterBReg),
						 .offset(offset[6:1]),
						 .selRawCode(selRawCode),
						 .outputCoarsePhase(TOTcode[8:6]),
						 .outputFinePhase(TOTcode[5:0]),
						 .errorFlag(TOTerrFlag));

	TOA_Encoder U_TOAEnc(.A(TOARawDataReg),
						 .level(level),
						 .counterA(TOACounterAReg),
						 .counterB(TOACounterBReg),
						 .offset(offset),
						 .selRawCode(selRawCode),
						 .outputCoarsePhase(TOAcode[9:7]),
						 .outputFinePhase(TOAcode[6:0]),
						 .errorFlag(TOAerrFlag));	
						 
	TOA_Encoder U_CalEnc(.A(CalRawDataReg),
						 .level(level),
						 .counterA(CalCounterAReg),
						 .counterB(CalCounterBReg),
						 .offset(offset),
						 .selRawCode(selRawCode),
						 .outputCoarsePhase(Calcode[9:7]),
						 .outputFinePhase(Calcode[6:0]),
						 .errorFlag(CalerrFlag));	
	
	always @(posedge EncdataWrtClk,negedge ResetFlag)
	begin    
		if(!ResetFlag) begin
			hitFlag <= 1'b0;
			TOTerrorFlagReg <= 1'b0;
			TOAerrorFlagReg <= 1'b0;
			CalerrorFlagReg <= 1'b0;
		end
		else begin
			hitFlag <= 1'b1;
			TOT_codeReg <= TOTcode;
			TOA_codeReg <= TOAcode;
			Cal_codeReg <= (timeStampMode == 1'b1)?Calcode:Calcode-TOAcode;
			TOTerrorFlagReg <= TOTerrFlag;
			TOAerrorFlagReg <= TOAerrFlag;
			CalerrorFlagReg <= CalerrFlag;			
		end
	end	
endmodule

