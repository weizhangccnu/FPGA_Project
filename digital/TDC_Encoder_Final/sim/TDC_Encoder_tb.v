//Encoder pre-layout simulation.
//@author: Wei Zhang
//@date: July 26th, 2019
//@address: SMU dallas, TX

`timescale 1ps / 10fs
module Encoder_Post_tb;
reg clk40M;
reg clk160M;
reg clk320M;
reg clk320;


// input interface
reg [2:0] TOTCounterA;					//TOT Counter A
reg [2:0] TOTCounterB;					//TOT Counter B
reg [31:0] TOTRawData;					//TOT Raw data input

reg [2:0] TOACounterA;					//TOA Counter A
reg [2:0] TOACounterB;					//TOA Counter B
reg [62:0] TOARawData;					//TOA Raw data input

reg [2:0] CalCounterA;					//Calibration Counter A
reg [2:0] CalCounterB;					//Calibration Counter B
reg [62:0] CalRawData;					//Calibration Raw data input

reg RawdataWrtClk;						//Raw data write clock
reg EncdataWrtClk;						//Encoder data write clock
reg ResetFlag;							//Reset all the error Flag for TOA, TOT, and Calibration
reg [2:0] level;						//Bubble tolerance level, range from 1 to 3
reg enableMon;							//enable Monitor
reg [6:0] offset;						//metastablity window offset, range from 0 to 127
reg selRawCode;							//select Raw Code for 1, selcet combinated code for 0
reg timeStampMode;						//1 for selecting Calcode, 0 for selecting Calcode-TOAcode

//output interface 
wire [8:0] TOT_codeReg;					//TOT encode data
wire [9:0] TOA_codeReg;					//TOA encode data
wire [9:0] Cal_codeReg;					//Calibration encode data

wire hitFlag;							//hitFlag
wire TOTerrorFlagReg;					//TOT error Flag Register
wire TOAerrorFlagReg;					//TOA error Flag Register
wire CalerrorFlagReg;					//Cal error Flag Register

wire [31:0] TOTRawDataMon;				//output TOT Raw data from Encoder logic
wire [62:0] TOARawDataMon;				//output TOA Raw data from Encoder logic
wire [62:0] CalRawDataMon;				//output Calibration Raw data from Encoder logic
wire [2:0] TOTCounterAMon;				//output TOT Counter A
wire [2:0] TOTCounterBMon;				//output TOT Counter B
wire [2:0] TOACounterAMon;				//output TOA Counter A
wire [2:0] TOACounterBMon;				//output TOA Counter B
wire [2:0] CalCounterAMon;				//output Calibration Counter A
wire [2:0] CalCounterBMon;				//output Calibration Counter B


integer fp_toa;
integer fp_tot;
integer fp_cal;
integer fp_toa_w;
integer fp_tot_w;
integer fp_cal_w;

integer count = 0;
integer cnt;
//initial sdf file for simulating Encoder logic after layout

initial begin
	$sdf_annotate("exportsdf.sdf");
end

//interface initial

initial begin
	fp_toa = $fopen("TOARaw_data.dat", "r");		//open a data file
	fp_tot = $fopen("TOTRaw_data.dat", "r");		//open a data file
	fp_cal = $fopen("CalRaw_data.dat", "r");		//open a data file
	fp_toa_w = $fopen("TOA_codeReg.dat", "w");		//TOA encoder output file
	fp_tot_w = $fopen("TOT_codeReg.dat", "w");		//TOT encoder output file
	fp_cal_w = $fopen("Cal_codeReg.dat", "w");		//Cal encoder output file
	clk40M = 1'b0;						//clock 40MHz initial
	clk160M = 1'b1;						//clock 160MHz initial
	clk320M = 1'b1;						//clock 320MHz initial
	RawdataWrtClk = 1'b1;				//initial RawdataWrtClk
	EncdataWrtClk = 1'b0;				//initial EncdataWrtClk
	level = 3'b011;						//set bubble tolerance level
	enableMon = 1'b0;					//0: disable Monitor, 1: enable Monitor
	ResetFlag = 1'b1;					//set ResetFlag = 1
	selRawCode = 1'b0;					//select combined data
	offset = 7'b0000000;				//metastability window offset, default value is 7'b0000000
	timeStampMode = 1'b1;				//1: Calcode, 0: Calcode-TOAcode
//	#100000 RawdataWrtClk = 1'b1;		//assert RawdataWrtClk 
	#200000000 $stop;					//stop simulation
end

always @(negedge RawdataWrtClk) 
begin
	if(count<3960)
	begin
		cnt = $fscanf(fp_toa, "%d %d %d", TOACounterA, TOACounterB, TOARawData);		//read TOARaw_data.dat file row by row.
		cnt = $fscanf(fp_tot, "%d %d %d", TOTCounterA, TOTCounterB, TOTRawData);		//read TOARaw_data.dat file row by row.
		cnt = $fscanf(fp_cal, "%d %d %d", CalCounterA, CalCounterB, CalRawData);		//read TOARaw_data.dat file row by row.
		$fwrite(fp_toa_w,"%d\n", TOA_codeReg);
		$fwrite(fp_tot_w,"%d\n", TOT_codeReg);
		$fwrite(fp_cal_w,"%d\n", Cal_codeReg);
		count <= count + 1'b1;
	end
	else
	begin
		count <= 1'b0;
		$fclose(fp_toa);
		$fclose(fp_tot);
		$fclose(fp_cal);
	end

end

//generate 40MHz clock
always begin
	#12500 clk40M <= ~clk40M;
end

//generate RawdataWrtClk clock
always begin
	#12500 RawdataWrtClk <= ~RawdataWrtClk;
end

//generate EncdataWrtClk clock
always begin
	#12500 EncdataWrtClk <= ~EncdataWrtClk;
end

//generate 320MHz clock
always begin
	#6250 clk160M <= ~clk160M;
end

//generate 320MHz clock
always begin
	#1562.5 clk320M <= ~clk320M;
end

always begin
	#10 clk320 = (clk40M & clk160M) & clk320M;
end

TDC_Encoder TDC_Encoder_tt(
.TOTCounterA(TOTCounterA), 				//input of TOT Counter A
.TOTCounterB(TOTCounterB), 				//input of TOT Counter B
.TOTRawData(TOTRawData), 				//input of TOT Raw Data
.TOACounterA(TOACounterA), 				//input of TOA Counter A
.TOACounterB(TOACounterB), 				//input of TOA Counter B
.TOARawData(TOARawData), 				//input of TOA Raw Data
.CalCounterA(CalCounterA), 				//input of Calibration Counter A
.CalCounterB(CalCounterB), 				//input of Calibration Counter B
.CalRawData(CalRawData), 				//input of Calibration Raw data
.RawdataWrtClk(RawdataWrtClk), 			//input of Raw data write clock
.EncdataWrtClk(EncdataWrtClk), 			//input of Encoder data write clock
.ResetFlag(ResetFlag),					//input from TDC Controller
.level(level), 							//input bubble tolerance level, range from 1 to 3
.enableMon(enableMon),					//enable Monitor
.offset(offset), 						//input metastablity windows offset
.selRawCode(selRawCode), 				//input select Raw data or combined code
.timeStampMode(timeStampMode), 			//input time stamp mode
.TOT_codeReg(TOT_codeReg), 				//output TOT encoder data [8:0]
.TOA_codeReg(TOA_codeReg), 				//output TOA encoder data [9:0]
.Cal_codeReg(Cal_codeReg), 				//output Calibration encoder data [9:0]
.hitFlag(hitFlag), 						//output Hit flag
.TOTerrorFlagReg(TOTerrorFlagReg), 		//output TOT error Flag
.TOAerrorFlagReg(TOAerrorFlagReg), 		//output TOA error Flag
.CalerrorFlagReg(CalerrorFlagReg), 		//output Cal error Flag

.TOTRawDataMon(TOTRawDataMon), 			//output TOT Raw data output [31:0]
.TOARawDataMon(TOARawDataMon), 			//output TOA Raw data output [62:0]
.CalRawDataMon(CalRawDataMon), 			//output Calibration Raw data output [62:0]
.TOTCounterAMon(TOTCounterAMon), 		//output of TOT Counter A
.TOTCounterBMon(TOTCounterBMon), 		//output of TOT Counter B
.TOACounterAMon(TOACounterAMon), 		//output of TOA Counter A
.TOACounterBMon(TOACounterBMon), 		//output of TOA Counter B
.CalCounterAMon(CalCounterAMon), 		//output of Calibration Counter A
.CalCounterBMon(CalCounterBMon)			//output of Calibration Counter B
);
endmodule
