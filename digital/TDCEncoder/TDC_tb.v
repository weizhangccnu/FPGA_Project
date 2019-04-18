/**
 *
 *  file: TDC_tb.v
 *
 *  TDC_tb
 *  ideal delayline, ideal controller and actual encoder test.
 *
 *  History:
 *	2019/03/15 Hanhan Sun    : Created
 **/

`timescale 1ps/100fs

//******Module Declaration******
module TDC_tb;

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
//integer TOA = 0;
integer i = 0;
integer fore_data = 0;
integer fore_data_i = 0;
integer TOT = 0; //typical : 6000


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

	wire [2:0] TOACounterA;
	wire [2:0] TOACounterB;
	wire [62:0] TOARawData;
	
	wire [2:0] CalCounterA;
	wire [2:0] CalCounterB;
	wire [62:0] CalRawData;
	
	wire [2:0] TOTCounterA;
	wire [2:0] TOTCounterB;
	wire [31:0] TOTRawData;
	
TDC_delayLine UT1
(
	.start(start),
	.TOA_clk(TOA_clk),
	.TOT_clk(TOT_clk),	
	.TOTReset(TOTReset),
	.TOAReset(TOAReset),	
	.TOA_Latch(TOA_Latch),
	.TOACounterA(TOACounterA),
	.TOACounterB(TOACounterB),	
	.TOARawData(TOARawData),
	.CalCounterA(CalCounterA),
	.CalCounterB(CalCounterB),
	.CalRawData(CalRawData),
	.TOTCounterA(TOTCounterA),
	.TOTCounterB(TOTCounterB),
	.TOTRawData(TOTRawData)
);

	wire [8:0] TOT_codeReg;
	wire [9:0] TOA_codeReg;	
	wire [9:0] Cal_codeReg;
    wire hitFlag;	
	wire TOTerrorFlagReg;
	wire TOAerrorFlagReg;	
	wire CalerrorFlagReg;	
	wire [31:0] TOTRawDataReg; //output raw data for slow control
	wire [62:0] TOARawDataReg;
	wire [62:0] CalRawDataReg;
	wire [2:0] TOTCounterAReg;
	wire [2:0] TOTCounterBReg;	
	wire [2:0] TOACounterAReg;
	wire [2:0] TOACounterBReg;	
	wire [2:0] CalCounterAReg;
	wire [2:0] CalCounterBReg;	

TDC_Encoder UT2
(
	.TOTCounterA(TOTCounterA),
	.TOTCounterB(TOTCounterB),
	.TOTRawData(TOTRawData),
	.TOACounterA(TOACounterA),
	.TOACounterB(TOACounterB),	
	.TOARawData(TOARawData),
	.CalCounterA(CalCounterA),
	.CalCounterB(CalCounterB),
	.CalRawData(CalRawData),
	.RawdataWrtClk(RawdataWrtClk),
	.EncdataWrtClk(EncdataWrtClk),
	.ResetFlag(ResetFlag),
	.level(3'b011),
	.offset(7'b0000000),
	.selRawCode(1'b0),
	.timeStampMode(1'b0),
	.TOT_codeReg(TOT_codeReg),
	.TOA_codeReg(TOA_codeReg),
	.Cal_codeReg(Cal_codeReg),
	.hitFlag(hitFlag),
	.TOTerrorFlagReg(TOTerrorFlagReg),
	.TOAerrorFlagReg(TOAerrorFlagReg),
	.CalerrorFlagReg(CalerrorFlagReg),
	.TOTRawDataReg(TOTRawDataReg),
	.TOARawDataReg(TOARawDataReg),
	.CalRawDataReg(CalRawDataReg),
	.TOTCounterAReg(TOTCounterAReg),
	.TOTCounterBReg(TOTCounterBReg),
	.TOACounterAReg(TOACounterAReg),
	.TOACounterBReg(TOACounterBReg),
	.CalCounterAReg(CalCounterAReg),
	.CalCounterBReg(CalCounterBReg)
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

	#500 resetn=1'b1;
	#2000000000 $stop;
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

task do_measure;
input [13:0] toa, tot;			//data width must be declared
begin
	#(37500-toa) pulse=1'b1; 	//#(12500-TOA) pulse=1'b1; 
	#tot pulse=0;
	#(12500-tot+toa) pulse=0; 	//#(37500-TOT+TOA) pulse=0;
end
endtask


initial begin
	for(i=0;i<100;i=i+1)
	begin
		#100000 do_measure(3000,6000);
	end
	//#100000 TOT = TOT+1;
	//do_measure(3000,6000);
	/*if (TOA_codeReg > fore_data)
	begin
		fore_data = TOA_codeReg;
		$display("i=%04d, interval_i=%4d",i,(i-fore_data_i));
		fore_data_i = i;		
	end*/
	//$display("i=%04d, TOA=%05d, TOA_Digital_Code=%04d",i,TOA,TOA_codeReg);
end		
endmodule
