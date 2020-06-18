/**
 *
 *  file: TDC_Encoder.v
 *
 *  TDC_Encoder
 *  Top level module of the TDC encoder, include TOA/TOT encoder.
 *
 *  History:
 *  2019/03/13 Datao Gong    : Created
 *  2019/05/08 Datao Gong    : Add a control signal on the data path to slow control
 * 	2020/05/27 Wei Zhang	 : Add Ripple Counter, TOA Latch logic, revise TOT logic, remove selRawCode. 
 **/
`timescale 1ps/100fs

module TDC_Encoder(
	input Counter_Clk,				// Ripple Counter Driver clock
	input Counter_RSTN,				// Ripple counter reset, low active
	input TOA_Clk,					// TOA coarse time latch clock
	input TOT_Clk, 					// TOT coarse time latch clock
	input TOA_Latch,				// TOA Latch signal

	input [20:0] TOTRawData,		//TOTRawData[31:0] alter to TOTRawData[20:0]
	input [62:0] CalRawData,
	
	input RawdataWrtClk,
	input EncdataWrtClk,
	input ResetFlag,

	input [1:0] level, 			//user defined error tolerance.
	input [6:0] offset,  		//user defined offset, default is 0
    input timeStampMode, 		//if it is true, output calibration code as timestamp
	
	output reg [8:0] TOT_codeReg,
	output reg [9:0] TOA_codeReg,	
	output reg [9:0] Cal_codeReg,
    output reg hitFlag,	
	output reg TOTerrorFlagReg,
	output reg TOAerrorFlagReg,	
	output reg CalerrorFlagReg	
);
	wire [62:0] TOARawData;
	wire [2:0] TOACounterA;
	wire [2:0] TOACounterB;
	wire [2:0] TOTCounterA;
	wire [2:0] TOTCounterB;
	wire [2:0] CalCounterA;
	wire [2:0] CalCounterB;

	wire [8:0] TOTcode;			// TOT Encode output Data
	wire [9:0] TOAcode;			// TOA Encode output Data
	wire [9:0] Calcode;			// Calibration Encode output Data

	wire [1:0] bubbleErrorTOA;
	wire [1:0] bubbleErrorCal;
	wire [1:0] bubbleError;

	reg [20:0] TOTRawDataReg; 	//raw data registers
	reg [62:0] TOARawDataReg;
	reg [62:0] CalRawDataReg;
	reg [2:0] TOTCounterAReg;
	reg [2:0] TOTCounterBReg;	
	reg [2:0] TOACounterAReg;
	reg [2:0] TOACounterBReg;	
	reg [2:0] CalCounterAReg;
	reg [2:0] CalCounterBReg;	
	
	assign bubbleError = bubbleErrorTOA | bubbleErrorCal;
	
	
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


	Ripple_Counter U_Ripple_Count(.Clk_In(Counter_Clk),				
								  .RSTN(Counter_RSTN),					
					              .TOA_Clk(TOA_Clk),				
					              .TOT_Clk(TOT_Clk),				
					              .TOA_CntA(CalCounterA),		
					              .TOA_CntB(CalCounterB),		
					              .TOT_CntA(TOTCounterA),		
					              .TOT_CntB(TOTCounterB));

	TOA_Latch U_TOA_Latch(.TOA_Latch(TOA_Latch),					
						  .TOA_Fine_In(CalRawData),				
						  .TOA_CntA_In(CalCounterA),			
						  .TOA_CntB_In(CalCounterB),			
						  .TOA_Fine_Out(TOARawData),		
						  .TOA_CntA_Out(TOACounterA),		
						  .TOA_CntB_Out(TOACounterB));

	TOT_Encoder U_TOTEnc(.A(TOTRawDataReg),
						 .level(level),
						 .counterA(TOTCounterAReg),
						 .counterB(TOTCounterBReg),
						 .offset(offset[6:1]),
						 .outputCoarsePhase(TOTcode[8:6]),
						 .outputFinePhase(TOTcode[5:0]),
						 .errorFlag(TOTerrFlag));

	TOA_Encoder U_TOAEnc(.A(TOARawDataReg),
						 .level(level),
						 .counterA(TOACounterAReg),
						 .counterB(TOACounterBReg),
						 .offset(offset),
						 .outputCoarsePhase(TOAcode[9:7]),
						 .outputFinePhase(TOAcode[6:0]),
						 .bubbleError(bubbleErrorTOA),
						 .errorFlag(TOAerrFlag));	
						 
	TOA_Encoder U_CalEnc(.A(CalRawDataReg),
						 .level(level),
						 .counterA(CalCounterAReg),
						 .counterB(CalCounterBReg),
						 .offset(offset),
						 .outputCoarsePhase(Calcode[9:7]),
						 .outputFinePhase(Calcode[6:0]),
					     .bubbleError(bubbleErrorCal),
						 .errorFlag(CalerrFlag));	
	
	always @(posedge EncdataWrtClk or negedge ResetFlag)
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
			Cal_codeReg <= (timeStampMode == 1'b1)?Calcode:(Calcode-TOAcode)^{bubbleError,8'b00000000};
			TOTerrorFlagReg <= TOTerrFlag;
			TOAerrorFlagReg <= TOAerrFlag;
			CalerrorFlagReg <= CalerrFlag;			
		end
	end	
endmodule

