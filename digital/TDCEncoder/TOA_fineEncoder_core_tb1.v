`timescale 1ns/1ps

//******Module Declaration******
module TOA_fineEncoder_core_tb1;

//******Signal Declaration******
reg [62:0] encode_In;
reg [2:0] level;//proper values of level ={1,2,3}
wire[5:0] Binary_Out;

reg clk;

//******Instantiation of Top-level Design******
TOA_fineEncoder_core encoder63
(
	.encode_In(encode_In),
	.level(level),
	.Binary_Out(Binary_Out) 
);

//******Provide Stimulus******
	initial begin //this process block specifies the stimulus.
		level = 3'd1;
		clk = 0;
		encode_In = 63'h0000_0000_0000_0000;//63

		/*************************************/
		#1 level = 3'd1;
		#1 encode_In = 63'h0000_0000_0000_0001;

		#124//128
		#1 level = 3'd2;
		#1 encode_In = 63'h0000_0000_0000_0003;	

		#124//128
		#1 level = 3'd3;
		#1 encode_In = 63'h4000_0000_0000_0002;	
   	
		#124//128
		#1 level = 3'd3;
		#1 encode_In = 63'h4000_0000_0000_0003;	
		
		#124//128
		#1 level = 3'd1;


	#124 $stop;//#128 $stop;
	end

	initial begin// this process block pipes the ASCII results to the terminal or text editor	
		$timeformat(-9,1,"ns",12);
		$display("        Time level encode_In                                                        Binary_Out");
	end
    	always
		#1 clk = !clk;
	
	always @(posedge clk)begin
		encode_In[62:1] <= encode_In[61:0];
	    	encode_In[0] <= encode_In[62];
		$monitor("%t  %d    %b  %d",$realtime,level,encode_In,Binary_Out);		
	end
	
	
	endmodule
