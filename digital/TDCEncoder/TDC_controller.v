/**
 *
 *  file: TDC_controller.v
 *
 *  TDC_delayLine
 *  ideal delayline controller for test
 *
 *  History:
 *  2019/03/15 Datao Gong    : Created
 *  2019/03/15 Hanhan Sun    : updated and verified
 *  2019/03/23 Hanhan Sun    : updated and verified
 **/
`timescale 1ps/100fs


/************Delay pulse generator*************/
module Delay_pulse_generator(input DummyEn,input SW,input IN,output OUT);
	wire Ain,NANDin;
	assign #400 Ain = !IN;
	assign #25 NANDin = !(Ain&(DummyEn|IN));
	assign #25 OUT = SW? NANDin: IN; 
endmodule


module TDC_controller
(
	input pulse,
	input clk40,
	input clk320,
	input enable,
	input testMode,
	input polaritySel,
	
	input resetn,
	input auotoReset,
	
	output wire  start,
	output wire  TOA_clk,
	output wire  TOA_Latch,	
	output wire  TOT_clk,
	output wire  TOTReset,
	output wire  TOAReset,	

	output wire RawdataWrtClk,
	output wire EncdataWrtClk,
	output wire ResetFlag
);



/********measurent Window Generator********/
	wire clk40dly25p;
	assign #25 clk40dly25p = !clk40;
	
	wire window;
	reg regWindow; //QC6
	
	always @(posedge clk320 or negedge clk40dly25p)
	begin
		if(!clk40dly25p)begin
			regWindow <= 1'b0;
		end
		else begin
			regWindow <= 1'b1;			
		end		
	end
	
	assign #50 window = enable&(!(regWindow|clk40));  

	
/********Synchronous reset generator********/		
	wire clk40dly200p;       
	wire rstn_clk40;
	
	assign #200 clk40dly200p = !(clk40 & auotoReset);
	assign #25 rstn_clk40 = (clk40 & auotoReset)|clk40dly200p;
	
	reg rstn_ext; //QC5 
	wire synReset;
	
	always @(negedge clk40)
	begin
		rstn_ext <= resetn;				
	end
	
	assign #25 synReset = auotoReset? rstn_clk40: rstn_ext; 

/*************************************/	
/********Pulse generator core********/
/*************************************/			
	wire window_buf;
	wire CPIN;
	
	assign #70 window_buf = window; 	
	assign #25 CPIN = testMode? window_buf: pulse; //testmode 
		
	
	reg QC0,QC1,QC2,QC3,QC4;
	wire RESETN1,RESETN2;

/********QC0********/			
	always @(posedge CPIN or negedge RESETN1)
	begin
		if(!RESETN1)begin
			QC0 <= 1'b0;
		end
		else begin
			QC0 <= QC0|window;
		end		
	end
		
	
/********QC1********/		
	always @(negedge CPIN or negedge RESETN2)
	begin
		if(!RESETN2)begin
			QC1 <= 1'b0;
		end
		else begin
			QC1 <= QC0;
		end		
	end	
	
	
/********QC2 and QC4********/		
	always @(negedge clk320 or negedge RESETN2)
	begin
		if(!RESETN2)begin
			QC2 <= 1'b0;
			QC4 <= 1'b0;
		end
		else begin
			QC2 <= QC0;
			QC4 <= QC2;
		end		
	end
	
	
/********QC3********/		
	always @(posedge clk320 or negedge RESETN2)
	begin
		if(!RESETN2)begin
			QC3 <= 1'b0;
		end
		else begin
			QC3 <= QC2;
		end		
	end
	
	
/********RESETN1********/	
	wire netDTin1,netDTout1;

	assign #325 netDTin1 = !(QC1&QC3);	
	Delay_pulse_generator DPGen1(.DummyEn(1'b1),.SW(polaritySel),.IN(netDTin1),.OUT(netDTout1));
	assign #25 RESETN1 = netDTout1&synReset;

	
/********RESETN2********/
	wire netDTin2,netDTout2;

	assign #325 netDTin2 = !(QC1&QC4);	
	Delay_pulse_generator DPGen2(.DummyEn(1'b1),.SW(polaritySel),.IN(netDTin2),.OUT(netDTout2));
	assign #25 RESETN2 = netDTout2&synReset;

	
/********start generator********/
	Delay_pulse_generator DPGen_start(.DummyEn(1'b1),.SW(polaritySel),.IN(QC0),.OUT(start));	
	
	
/********TOT_clk generator********/
	Delay_pulse_generator DPGen_TOTCK(.DummyEn(1'b0),.SW(polaritySel),.IN(QC1),.OUT(TOT_clk));		
	
	
/********TOA_clk generator********/
	wire  TOA_clkin;
	assign #50 TOA_clkin = clk320&(QC0|QC2);

	Delay_pulse_generator DPGen_TOACK(.DummyEn(1'b0),.SW(polaritySel),.IN(TOA_clkin),.OUT(TOA_clk));		
	
	
/**************************************/	
/********Readout Controller***********/
/*************************************/
	reg RC_QC0,RC_QC1,RC_QC2,RC_QC3;

	always @(posedge clk40)
	begin
	RC_QC1 <= QC0;	//start as data
	end

	always @(negedge clk40)
	begin
	RC_QC2 <= RC_QC1;
	RC_QC3 <= RC_QC2;
	end

	assign #100 RawdataWrtClk  = (!clk40) & RC_QC1;
	assign #75 EncdataWrtClk  = clk40 & RC_QC2;
	assign #50 ResetFlag = !(clk40 & RC_QC3);
	
	
	always @(posedge TOA_clk or negedge TOTReset)
	begin
		if(!TOTReset)begin
			RC_QC0 <= 1'b0;
		end
		else begin
			RC_QC0 <= 1'b1;
		end		
	end

	Delay_pulse_generator DPGen_TOALatch(.DummyEn(1'b0),.SW(1'b1),.IN(RC_QC0),.OUT(TOA_Latch));	
	
	Delay_pulse_generator DPGen_TOTReset(.DummyEn(1'b0),.SW(1'b1),.IN(RawdataWrtClk),.OUT(TOTReset));	
	

	wire TOAReset1;
	//Delay_pulse_generator DPGen_TOAReset(.DummyEn(1'b0),.SW(1'b1),.IN(TOA_Latch),.OUT(TOAReset1)); 	
		
	reg RC_QC4;
	always @(posedge TOA_Latch or negedge TOTReset)
	begin
		if(!TOTReset)begin
			RC_QC4 <= 1'b0;
		end
		else begin
			RC_QC4 <= 1'b1;
		end		
	end

	Delay_pulse_generator DPGen_TOAReset(.DummyEn(1'b0),.SW(1'b1),.IN(RC_QC4),.OUT(TOAReset1));

	assign #50 TOAReset = TOAReset1 & TOTReset;
	
		
endmodule

