`timescale 1ns/1ps

//******Module Declaration******
module TOA_fineEncoder_tb1;

//******Signal Declaration******
reg [62:0] encode_In;
reg [2:0] level;//proper values of level ={1,2,3}
wire[6:0] Binary_Out;

reg clk;

//******Instantiation of Top-level Design******
TOA_fineEncoder Encoder1
(
	.encode_In(encode_In),
	.level(level),
	.Binary_Out(Binary_Out) 
);

//******Provide Stimulus******
	initial begin //this process block specifies the stimulus.
		level = 3'd1;
		clk = 0;
		encode_In = 63'b000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;//63
		
		#1 level = 3'd1;
		#1 encode_In = 63'b101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101;//0-62
		#124

		#1 level = 3'd2;
		#1 encode_In = 63'b110_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1011;//63
		#124 //63

		#1 level = 3'd3;//0-62
		
		#126 $stop;
	end

	initial begin// this process block pipes the ASCII results to the terminal or text editor	
		$timeformat(-9,1,"ns",12);
		$display("        Time level encode_In                                                       Binary_Out[6] Binary_Out[5:0]");
		
	end

	always
		#1 clk = !clk;
	
	always @(posedge clk)begin
		encode_In[62:1] <= encode_In[61:0];
	    	encode_In[0] <= encode_In[62];
		$monitor("%t  %d    %b     %d               %d",$realtime,level,encode_In,Binary_Out[6],Binary_Out[5:0]);		
	end
	endmodule
