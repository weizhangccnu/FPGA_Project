/********************************************************************************************************************
-- ctrl.vhd
-- ETROC1 readout seqencer 4x4 pixels with ROI
-- jamieson olsen <jamieson@fnal.gov>
--
-- Normal running: WE=1, addr increments, the pixel modules store TDC values into the RAM buffers.
-- When L1ACC occurs WE is dropped, mux selects first enabled pixeled, addr loops once reading out entire RAM buffer.
-- Move on to next enabled pixel, dumping out the RAM buffer. When the last word of the last enabled pixel is sent, 
-- then send the trailer word, then return to capture mode WE=1, no reset required.
--
-- Output format is 32 bit double words BUT is sent 32 bits at a time (1.28Gbps with 40MHz clock)
-- No gaps or pauses when switching between pixels to read out.
-- e.g. [pixel n, last sample, low word],[pixel n+1, first word, hi word]...
--
-- ROI = region of interest, 16-bit vector specifies which pixels are enabled for readout
-- Pixel array index:
--
--      0    1    2    3
-- 
-- 0   00   01   02   03
-- 1   04   05   06   07
-- 2   08   09   10   11
-- 3   12   13   14   15
--
-- the HIGHEST index pixels will reageddd out first.
-- e.g. ROI=X"9201" will cause pixels 15 (Row3Col3), 12 (Row3Col0), 9 (Row2Col1), and 0 (Row0Col0) readout in that order.
*********************************************************************************************************************/
module ctrl(
	clock,
	reset,
	l1acc,
	bc0,
	roi,
	we,
	addr,
	roe,
	din0,
	din1,
	din2,
	din3,
	dout
);

input clock;
input reset;
input l1acc;
input bc0;
input [15:0] roi;
output we;
output [7:0] addr;
output [3:0] roe;	//-- select the rows to enable for readout
input [29:0] din0;	//-- column buffers from pixels
input [29:0] din1;	//-- column buffers from pixels
input [29:0] din2;	//-- column buffers from pixels
input [29:0] din3;	//-- column buffers from pixels
output [29:0] dout;	//-- parallel output bus to serializer, 640Mbps


reg [11:0] bcid_reg, l1acc_id_reg;


wire [29:0] din0, din1, din2, din3;	//-- column buffers from pixels
wire [29:0] dout;			//-- parallel output bus to serializer, 640Mbps

reg [2:0] state;	
localparam rst = 3'h0;
localparam capture = 3'h1;
localparam sof = 3'h2;
localparam dump = 3'h3;
localparam eof = 3'h4;

reg [7:0] addr_reg, stop_reg;
reg [15:0] roi_reg, proi;

wire [29:0] dmux;

always@(posedge clock) begin
	if(bc0)
		bcid_reg <= 0;
	else
		bcid_reg <= bcid_reg + 1;
end

/******************************************************************************************
-- ONE HOT priority encoder will indicate which pixel is currently active for readout
-- drives the column MUX and row output enable signals. this one hot vector is XOR'ed with
-- roi_reg to clear highest set bit and expose the next highest set bit, aka fisher tree or
-- "peel away" priority encoder function
*******************************************************************************************/

always@(roi_reg) begin
	casez(roi_reg) 
		16'b1??????????????? : proi = 16'h8000;
		16'b01?????????????? : proi = 16'h4000;
		16'b001????????????? : proi = 16'h2000;
		16'b0001???????????? : proi = 16'h1000;
		16'b00001??????????? : proi = 16'h0800;
		16'b000001?????????? : proi = 16'h0400;
		16'b0000001????????? : proi = 16'h0200;
		16'b00000001???????? : proi = 16'h0100;
		16'b000000001??????? : proi = 16'h0080;
		16'b0000000001?????? : proi = 16'h0040;
		16'b00000000001????? : proi = 16'h0020;
		16'b000000000001???? : proi = 16'h0010;
		16'b0000000000001??? : proi = 16'h0008;
		16'b00000000000001?? : proi = 16'h0004;
		16'b000000000000001? : proi = 16'h0002;
		16'b0000000000000001 : proi = 16'h0001;
		default : proi = 16'h0000;
	endcase
end

always@(posedge clock) begin
	if(!reset)
		state <= rst;
	else begin
		case(state) 
			rst : 
				begin
					state <= capture;
					addr_reg <= 0;		// added by quan
				end
			
			capture :		//-- normal run mode, incrementing counter, WE=1
				begin
					if(l1acc) begin		//send SOF
						l1acc_id_reg <= bcid_reg;	//store the BCID of the BX that L1acc occurs in & use it for SOF
						state <= sof;
						roi_reg <= roi;		//store ROI bits which iden pixels to read out
						stop_reg <= addr_reg;	//store the STOP address, or end count
					end
					else begin
						state <= capture;
						addr_reg <= addr_reg +1;
					end
				end
			
			sof:		// start of frame
				begin
					if(proi == 16'h0000)		//if no pixels are enabled jump to send EOF...
						state <= eof;
					else begin
						state <= dump;
						addr_reg <= addr_reg +1;//increment addr_reg once, prep for dump state
					end
				end
			dump:		//read from selected RAM buffer, low word
				begin
					if(addr_reg == stop_reg) begin	//end of pixel buffer, is there another one ready?
						if(roi_reg == proi)	//this is the end of the last pixel buffer
							state <= eof;
						else begin		//more buffers to dump, select next buffer and loop again
							roi_reg <= (roi_reg ^ proi);
							addr_reg <= addr_reg + 1;
							state <= dump;
						end
					end
					else begin		//keep dumping current buffer
						state <= dump;
						addr_reg <= addr_reg +1;
					end
				end
			eof:		//EOF end of frame marker. after this, return to normal data taking mode
				begin
					state <= capture;				
				end

		endcase
	end
end

//-- enable the RAMs for writing only when in run/capture state...

assign we = (state == capture)?1:0;

//-- mux to select which pixel COLUMN to read out, PROI is ONE HOT

assign dmux = 	((proi[0] == 1) || (proi[4] == 1) || (proi[8] == 1) || (proi[12] == 1))?din0:
		((proi[1] == 1) || (proi[5] == 1) || (proi[9] == 1) || (proi[13] == 1))?din1:
		((proi[2] == 1) || (proi[6] == 1) || (proi[10] == 1) || (proi[14] == 1))?din2:
		((proi[3] == 1) || (proi[7] == 1) || (proi[11] == 1) || (proi[15] == 1))?din3:
		30'h0000000;

//-- select which ROW output enable to drive, PROI is ONE HOT

assign roe[0] = ((proi[0] == 1) || (proi[1] == 1) || (proi[2] == 1) || (proi[3] == 1))?1:0;
assign roe[1] = ((proi[4] == 1) || (proi[5] == 1) || (proi[6] == 1) || (proi[7] == 1))?1:0;
assign roe[2] = ((proi[8] == 1) || (proi[9] == 1) || (proi[10] == 1) || (proi[11] == 1))?1:0;
assign roe[3] = ((proi[12] == 1) || (proi[13] == 1) || (proi[14] == 1) || (proi[15] == 1))?1:0;

assign dout = 	(state == sof) ? {18'h25555,l1acc_id_reg}:
		(state == dump) ? dmux[29:0]:
		(state == eof) ? 30'h2EADBEEF:
		30'h0000000;

assign addr = addr_reg;

endmodule
