/**
 *
 *  file: TDC_delayLine.v
 *
 *  TDC_delayLine
 *  ideal delayline module for test
 *
 *  History:
 *  2019/03/13 Datao Gong    : Created
 *
 **/
`timescale 1ps/100fs

module NANDCell(input A,input B,output Out);
wire tmp;
assign tmp = (A==1'b0)?1'b1:(!B);
buf #(18,21) (Out, tmp);
endmodule

module TDC_delayLine
(
	input start,
	input TOA_clk,
	input TOT_clk,
	input TOTReset,
	input TOAReset,
	input TOA_Latch,

	output reg [2:0] TOACounterA,
	output reg [2:0] TOACounterB,
	output reg [62:0] TOARawData,

	output reg [2:0] CalCounterA,
	output reg [2:0] CalCounterB,
	output reg [62:0] CalRawData,
	
	output reg [2:0] TOTCounterA,
	output reg [2:0] TOTCounterB,
	output reg [31:0] TOTRawData

);

	wire [62:0] A;
	wire [62:0] B;
	wire [62:0] tap;

	reg [2:0] rippleCountA,rippleCountB;
	
    assign A[0] = start;
    assign A[62:1] = {62{1'b1}};	
	assign B[62:0] = {tap[61:0],tap[62]}; //oscillator

	genvar gi;
	generate
	for(gi = 0; gi < 63; gi=gi+1) begin : NANDLOOP
		NANDCell UNANDCell(A[gi], B[gi],tap[gi]);
	end
	endgenerate	
	
	always @(posedge tap[31],negedge TOTReset)
	begin
		if(!TOTReset)begin
			rippleCountA <= 3'b000;
		end
		else begin
			rippleCountA <= rippleCountA + 1;					
		end		
	end

	always @(negedge tap[31],negedge TOTReset)
	begin
		if(!TOTReset)begin
			rippleCountB <= 3'b000;
		end
		else begin
			rippleCountB <= rippleCountB + 1;					
		end		
	end
	
	
	always @(posedge TOA_clk,negedge TOAReset)
	begin
		if(!TOAReset)begin
			CalRawData <= {63{1'b0}};
		end
		else begin
			CalRawData <= tap[62:0];
			CalCounterA <= rippleCountA;
			CalCounterB <= rippleCountB;			
		end		
	end

	always @(posedge TOA_Latch)
	begin
		if(TOA_Latch)begin
			TOARawData <= CalRawData;
			TOACounterA <= CalCounterA;
			TOACounterB <= CalCounterB;			
		end
	end
	
	always @(posedge TOT_clk,negedge TOTReset)
	begin
		if(!TOTReset)begin
			TOTRawData <= {63{1'b0}};
		end
		else begin
			TOTRawData <= {tap[62],tap[60],tap[58],tap[56],tap[54],tap[52],tap[50],
										   tap[48],tap[46],tap[44],tap[42],tap[40],	
										   tap[38],tap[36],tap[34],tap[32],tap[30],											   
										   tap[28],tap[26],tap[24],tap[22],tap[20],											   
										   tap[18],tap[16],tap[14],tap[12],tap[10],											   
										   tap[8],tap[6],tap[4],tap[2],tap[0]};
			TOTCounterA <= rippleCountA;
			TOTCounterB <= rippleCountB;			
		end		
	end

	
endmodule

