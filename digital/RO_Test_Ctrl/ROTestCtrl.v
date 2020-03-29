//////////////////////////////////////////////////////////////////////////////////
// Author:      Hanhan Sun
// 
// Create Date:    8/13/2019 3:24 PM
// Design Name:    ETROC1 
// Module Name:    ROTestCtrl
// Project Name: 
// Description: Readout Test Pattern Generator
//
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 100ps/1ps

module ROTestCtrl(
	CLK,
//	RSTn,
	CFGROTest,
	TestRO,
	DataIn,
	DataOut
);

input CLK;       // input clock at 40 MHz
//input RSTn;      // Reset signal, active-low
input [3:0] CFGROTest; // 4 configuration bits used to distinguish pixel
input TestRO;    // Control of readout test mode, test pattern is sent for readout(TestRO == 1)
input [29:0] DataIn;    // 30 bits TDC output data
output [29:0] DataOut; 
//inout VDD,VSS;

//reg [29:0] In_reg;
//reg [29:0] DataRO;
reg [15:0] counter;
//reg rst_int;	//added by quan

/*
always@(negedge RSTn or posedge CLK) begin
if(!RSTn)		
	rst_int <= 1'b0;
else begin
	rst_int <= 1'b1;
end
end
*/

/*
always@(negedge RSTn or posedge CLK) begin
if(!RSTn)		
	In_reg <= 30'b0;
else begin
	In_reg <= DataIn;
end
end
*/

always@(posedge CLK) begin
if (!TestRO)
	counter <= 16'b0;
else
	counter <= counter + 16'b0000_0000_0000_0001;
end

/*
always@(negedge RSTn or posedge CLK) begin
if(!RSTn)		
	counter <= 16'b0;
else begin
	counter <= counter + 16'b0000_0000_0000_0001;
end
end
*/



/*
always@(negedge RSTn or posedge CLK) begin
if(!RSTn)		
	DataRO <= 30'b0;
else begin
	DataRO <= {10'b1010101010,CFGROTest,counter};
end
end
*/


assign DataOut = (TestRO==1'b1)?{10'b1010101010,CFGROTest,counter}:DataIn;

endmodule
