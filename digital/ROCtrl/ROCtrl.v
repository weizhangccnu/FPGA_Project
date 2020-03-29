//////////////////////////////////////////////////////////////////////////////////
// Org:        	FNAL/SMU
// Author:      Quan Sun
// 
// Create Date:    Mon Jul 8th 17:18 CST 2019
// Design Name:    ETROC1 
// Module Name:    ROCtrl
// Project Name: 
// Description: readout control of ETROC1
//		RO_Sel selects either SRO or DMRO data to output, 1 for SRO, 0 for DMRO
//		when RO_Sel = 1, DMRO_COL selects data from one out of four columns to output.
//	   		     3    2    1    0
// 			3   15   11    7    3
// 			2   14   10    6    2
// 			1   13    9    5    1
// 			0   12    8    4    0
//		Output of this module will be sent to DMRO module.
// Dependencies: 
//
// Revision: 
//
//
//////////////////////////////////////////////////////////////////////////////////

module ROCtrl(
	RO_SEL,
	DMRO_COL,
	DataDMRO0,
	DataDMRO1,
	DataDMRO2,
	DataDMRO3,
	DataSRO,
	DataOut
);
input RO_SEL;
input [1:0] DMRO_COL;	//Column index of DMRO. Row index goes to OE_DMRO directly.
input [29:0] DataDMRO0, DataDMRO1, DataDMRO2, DataDMRO3, DataSRO;
output [29:0] DataOut;
reg [29:0] DMRO_Out;

assign DataOut = RO_SEL?DataSRO:DMRO_Out;

always@(DMRO_COL or DataDMRO0 or DataDMRO1 or DataDMRO2 or DataDMRO3) begin
	case(DMRO_COL)
		2'b00:DMRO_Out = DataDMRO0;		// column 0
		2'b01:DMRO_Out = DataDMRO1;		// column 1
		2'b10:DMRO_Out = DataDMRO2;		// column 2
		2'b11:DMRO_Out = DataDMRO3;		// column 3
		default:DMRO_Out = DataDMRO0;
	endcase
end


endmodule
