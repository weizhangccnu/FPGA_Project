/* 
 * filename: fine_data_encoder_tb
 * description: testbench of fine data encoder 
 * author: Wei Zhang
 * date: October 6th, 2023
 * version: v0
 *
 */
`timescale 1ps/10fs

module fine_data_encoder_tb();
reg clk40M;					// 40 MHz clock

reg [54:0] fine_raw_data;	// fine data 55-bit
reg [4:0] counterA;			// coarse counter A, 5-bit
reg [4:0] counterB;			// coarse counter B, 5-bit

wire [10:0] xor_res1;
wire [10:0] and_res1;
wire [10:0] xor_res2;
wire [6:0] fine_bin_code;

integer fp;					// file handler
integer count = 0;			// counter to record read data
integer cnt;				// file counter

//------------------------------------------------> initial 
initial 
begin
    $fsdbDumpfile("fine_data_encoder.fsdb");
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
	#50000000 $finish;								// finish the simulation
end

//------------------------------------------------< initial 

//------------------------------------------------> read data 
always @(posedge clk40M)
begin 
	if(count < 2000)
	begin 
		cnt = $fscanf(fp, "%b %b %b", fine_raw_data, counterA, counterB);	// read stop_data_0930.dat file row by row
		count <= count + 1'b1;
		$monitor("%t %d %b %b %b %b", $realtime, count, fine_raw_data, counterA, counterB, fine_bin_code);
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

//------------------------------------------------> fine data encoder instance 
fine_data_encoder fine_data_encoder_inst(
.fine_raw_code(fine_raw_data),			// fine data input, 55-bit
.fine_bin_code(fine_bin_code)			// fine data encoded output, 7-bit 
);
//------------------------------------------------< fine data encoder instance 
endmodule

