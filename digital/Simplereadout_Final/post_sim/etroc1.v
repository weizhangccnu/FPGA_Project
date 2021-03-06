//Verilog HDL for "testSimpleRO", "etroc1" "functional"
/*
-- etroc1.vhd
-- ETROC1 readout seqencer 4x4 pixels
-- jamieson olsen <jamieson@fnal.gov>
--
-- ROI = region of interest. specify which pixels to enable for readout.
--       16 bit vector (MSb..LSb): Row3Col3, Row3Col2, Row3Col1, ... Row0Col0
-- 
-- 32-bit TDC bits should be applied to the DIN input, which is a 2D array of 32-bit unsigned vectors
-- DIN(ROW)(COL)(BIT)
--
-- DOUT is a 32-bit parallel output bus which should ultimately connect to a serializer
-- 
-- Depth of the memory buffer is controlled by the generic ADDR_BITS.
-- Default is = 8 = 256 BX per pixel
-- 
-- When L1acc occurs the 
*/
`timescale 1ps/100fs
module etroc1 ( 
	clock,
	reset,
	l1acc,
	bc0,
	roi,
	din_0_0,
	din_1_0,
	din_2_0,
	din_3_0,
	din_0_1,
	din_1_1,
	din_2_1,
	din_3_1,
	din_0_2,
	din_1_2,
	din_2_2,
	din_3_2,
	din_0_3,
	din_1_3,
	din_2_3,
	din_3_3,
	dout
);

input clock;
input reset;
input l1acc;
input bc0;
input [15:0] roi;
input [29:0] din_0_0;
input [29:0] din_1_0;
input [29:0] din_2_0;
input [29:0] din_3_0;
input [29:0] din_0_1;
input [29:0] din_1_1;
input [29:0] din_2_1;
input [29:0] din_3_1;
input [29:0] din_0_2;
input [29:0] din_1_2;
input [29:0] din_2_2;
input [29:0] din_3_2;
input [29:0] din_0_3;
input [29:0] din_1_3;
input [29:0] din_2_3;
input [29:0] din_3_3;
output [29:0] dout;

wire oe;
wire we;
wire [7:0] addr;
wire [3:0] roe;
wire [29:0] colbus [0:3];

wire [29:0] din [0:3] [0:3];

assign din[0][0] = din_0_0;
assign din[1][0] = din_1_0;
assign din[2][0] = din_2_0;
assign din[3][0] = din_3_0;
assign din[0][1] = din_0_1;
assign din[1][1] = din_1_1;
assign din[2][1] = din_2_1;
assign din[3][1] = din_3_1;
assign din[0][2] = din_0_2;
assign din[1][2] = din_1_2;
assign din[2][2] = din_2_2;
assign din[3][2] = din_3_2;
assign din[0][3] = din_0_3;
assign din[1][3] = din_1_3;
assign din[2][3] = din_2_3;
assign din[3][3] = din_3_3;

wire clk40M_In;
assign #37 clk40M_In = clock;

reg we_in;
reg [3:0] roe_in;
reg [7:0] addr_in;

always@(roe, addr, we) begin
	case(roe) 
		4'b0001: begin #1400 we_in = we; addr_in = addr; roe_in = roe; end
		4'b0010: begin #1300 we_in = we; addr_in = addr; roe_in = roe; end
		4'b0100: begin #1200 we_in = we; addr_in = addr; roe_in = roe; end
		4'b1000: begin #1100 we_in = we; addr_in = addr; roe_in = roe; end
		default: begin #1100 we_in = we; addr_in = addr; roe_in = roe; end
	endcase
end

genvar R_gen, C_gen;
generate
	for (R_gen = 0; R_gen < 4; R_gen = R_gen + 1) begin
		for (C_gen = 0; C_gen < 4; C_gen = C_gen + 1) begin
			SRO_RAM SRO_RAM_inst(
				.clock(clk40M_In),
				.we(we_in),
				.addr(addr_in),
				.din(din[R_gen][C_gen]),
				.oe(roe_in[R_gen]),
				.dout(colbus[C_gen])
			);
		end
	end
endgenerate

/*
ram ram_inst_test(
				.clock(clock),
				.we(we),
				.addr(addr),
				.din(din[1][1]),
				.oe(roe[2]),
				.dout(colbus[1])
			);
*/


reg [29:0] colbus_in [0:3];
always@(roe, colbus[0], colbus[1], colbus[2], colbus[3]) begin
	case(roe) 
		4'b0001: begin #161 colbus_in[3] = colbus[3]; colbus_in[2] = colbus[2]; colbus_in[1] = colbus[1]; colbus_in[0] = colbus[0]; end
		4'b0010: begin #93  colbus_in[3] = colbus[3]; colbus_in[2] = colbus[2]; colbus_in[1] = colbus[1]; colbus_in[0] = colbus[0]; end
		4'b0100: begin #38  colbus_in[3] = colbus[3]; colbus_in[2] = colbus[2]; colbus_in[1] = colbus[1]; colbus_in[0] = colbus[0]; end
		4'b1000: begin #8   colbus_in[3] = colbus[3]; colbus_in[2] = colbus[2]; colbus_in[1] = colbus[1]; colbus_in[0] = colbus[0]; end
		default: begin #8   colbus_in[3] = colbus[3]; colbus_in[2] = colbus[2]; colbus_in[1] = colbus[1]; colbus_in[0] = colbus[0]; end
	endcase
end
//--------------------------------------------------> Data out trace latency
SRO_CTRL SRO_CTRL_inst(
			.clock(clock),
			.reset(reset),
			.l1acc(l1acc),
			.bc0(bc0),
			.roi(roi),
			.we(we),
			.addr(addr),
			.roe(roe),
			.din0(colbus_in[0]),
			.din1(colbus_in[1]),
			.din2(colbus_in[2]),
			.din3(colbus_in[3]),
			.dout(dout)
		);

endmodule
