/******************************************************************************
pixel.vhd
-- digital pixel logic consists of a RAM block and tri-state output bus ONLY
-- generic single port RAM is inferred here. Sync write, async read. keep it simple.
-- jamieson olsen <jamieson@fnal.gov>

*******************************************************************************/
`define wordwidth 30
`define memdepth 256
module ram(
	clock,
	we,
	addr,
	din,
	oe,
	dout
);

input clock;
input we;
input [7:0] addr;
input [`wordwidth-1:0] din;
input oe;
output [`wordwidth-1:0] dout;

reg [`wordwidth-1:0] memory_pix [`memdepth-1:0];
wire [`wordwidth-1:0] dout_i;


always@(posedge clock) begin
if(we)
	memory_pix[addr] <= din;
end

assign dout_i = memory_pix[addr];
assign dout = (oe==1)?dout_i:30'bZ;

endmodule
