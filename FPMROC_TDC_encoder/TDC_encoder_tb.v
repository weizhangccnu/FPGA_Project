/* 
 * filename: TDC_encoder_tb
 * description: testbench of TDC encoder 
 * author: Wei Zhang
 * date: October 10th, 2023
 * version: v0
 *
 */
`timescale 1ps/10fs

module TDC_encoder_tb();
reg clk40M;					// 40 MHz clock

reg [54:0] fine_raw_data;	// fine data 55-bit
reg [4:0] counterA;			// coarse counter A, 5-bit
reg [4:0] counterB;			// coarse counter B, 5-bit

integer fp;					// file handler
integer count = 0;			// counter to record read data
integer cnt;				// file counter

wire [11:0] TDC_bin_code;	// TDC binary output code
//------------------------------------------------> initial 
initial 
begin
    $fsdbDumpfile("TDC_encoder.fsdb");
    $fsdbDumpvars(0);
end
//------------------------------------------------< initial 

//------------------------------------------------> initial 
initial begin
	$timeformat(-9, 1, "ns", 1);
	fp = $fopen("./rtl/stop_data_0930.dat", "r");		// open data file
	if(fp == 0)
	begin
		$display("$open file failed!");
		$stop;
	end
	$display("\n ============== file opened... ==============");
	clk40M = 1'b0;									// initial clk40M 
	#800000000 $finish;								// finish the simulation
end

//------------------------------------------------< initial 

//------------------------------------------------> read data 
always @(posedge clk40M)
begin 
	if(count < 30000)
	begin 
		cnt = $fscanf(fp, "%b %b %b", fine_raw_data, counterA, counterB);	// read stop_data_0930.dat file row by row
		count <= count + 1'b1;
		$monitor("%t %d %b %b %b %b", $realtime, count, fine_raw_data, counterA, counterB, TDC_bin_code);
	end
	else
	begin
		count <= 1'b0;	
		$fclose(fp);
	end
end
//------------------------------------------------> read data 

//------------------------------------------------> generate 40MHz clock 
always begin
	#12500 clk40M <= ~clk40M;
end
//------------------------------------------------< generate 40MHz clock 

//------------------------------------------------> TDC encoder instance 
TDC_encoder TDC_encoder_inst(
    .fine_raw_code(fine_raw_data),			// fine data input, 55-bit
    .counterA(counterA),					// ripple counter A, 5-bit
    .counterB(counterB),					// ripple counter B, 5-bit
    .TDC_bin_code(TDC_bin_code)				// TDC encoded output, 12-bit 
);
//------------------------------------------------< TDC encoder instance 
endmodule

