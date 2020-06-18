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
module Delay_pulse_generator(
input DummyEn,
input SW,
input IN,
output OUT
);

wire Ain, NANDin;
assign #400 Ain = !IN;
assign #25 NANDin = !(Ain&(DummyEn|IN));
assign #25 OUT = SW?NANDin:IN;
endmodule

//---------------------------------------------------------------<

//--------------------------------------------------------------->
module TDC_Controller(
	input pulse,			// pulse input
	input clk40,			// 40M reference clock
	input clk320, 			// 320M reference strobe
	input enable,			// TDC Controller enable
	input testMode, 		// Test Mode, high active
	input polaritySel,		// output clock polarity select
	
	input resetn,			// Controller external reset, low level active
	input autoReset,		// Controller auto reset, low level active 
	
	output start,			// Delay Line Oscillate Start signal
	output TOA_Clk,			// TOA Data capture clock
	output TOA_Latch,		// TOA Data latch clock
	output TOT_Clk,			// TOT Data capture clock
	output Counter_RSTN,	// Ripple Counter reset signal, low active

	output RawdataWrtClk,	// Raw data latch to Encoder
	output EncdataWrtClk,	// Encoded data latch out
	output ResetFlag
);

//=============== measurement window generator ===============//
	wire clk40dly25p;
	assign #25 clk40dly25p = !clk40;

	wire window;
	reg regWindow;				//QC6

	always @(posedge clk320 or negedge clk40dly25p)
	begin
		if(!clk40dly25p) begin
			regWindow <= 1'b0;
		end
		else begin
			regWindow <= 1'b1;
		end
	end

	assign #50 window = enable&(!(regWindow|clk40));

//=============== Synchronous reset generator ===============//		
	wire clk40dly200p;       
	wire rstn_clk40;
	
	assign #200 clk40dly200p = !(clk40 & autoReset);
	assign #25 rstn_clk40 = (clk40 & autoReset)|clk40dly200p;
	
	reg rstn_ext; //QC5 
	wire synReset;
	
	always @(negedge clk40)
	begin
		rstn_ext <= resetn;				
	end
	
	assign #25 synReset = autoReset? rstn_clk40: rstn_ext;

//=============== Pulse Generator Core ===============//
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
	Delay_pulse_generator DPGen_TOTCK(.DummyEn(1'b0),.SW(polaritySel),.IN(QC1),.OUT(TOT_Clk));		
	
	
/********TOA_Clk generator********/
	wire  TOA_clkin;
	assign #50 TOA_clkin = clk320&(QC0|QC2);

	Delay_pulse_generator DPGen_TOACK(.DummyEn(1'b0),.SW(polaritySel),.IN(TOA_clkin),.OUT(TOA_Clk));		
	
	
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
	//assign #50 ResetFlag = !(clk40 & RC_QC3);			//previous design 
	assign #50 ResetFlag = (!(((!RC_QC2)&RC_QC3)&clk40))&resetn;	// 
	
	always @(posedge TOA_Clk or negedge Counter_RSTN)
	begin
		if(!Counter_RSTN)begin
			RC_QC0 <= 1'b0;
		end
		else begin
			RC_QC0 <= 1'b1;
		end		
	end

	Delay_pulse_generator DPGen_TOALatch(.DummyEn(1'b0),.SW(1'b1),.IN(RC_QC0),.OUT(TOA_Latch));	
	
	Delay_pulse_generator DPGen_Counter_RSTN(.DummyEn(1'b0),.SW(1'b1),.IN(RawdataWrtClk),.OUT(Counter_RSTN));	
	 	
/*		
	reg RC_QC4;
	always @(posedge TOA_Latch or negedge Counter_RSTN)
	begin
		if(!Counter_RSTN)begin
			RC_QC4 <= 1'b0;
		end
		else begin
			RC_QC4 <= 1'b1;
		end		
	end
*/
endmodule
//---------------------------------------------------------------<
