`timescale 1ns/1ps

//******Module Declaration******
module TOT_fineEncoder_core_tb1;

//******Signal Declaration******
reg [31:0] encode_In;
reg [2:0] level;//proper values of level ={1,2,3}
wire[4:0] Binary_Out;
wire errorFlag;

reg clk;


//******Instantiation of Top-level Design******
TOT_fineEncoder_core encoder31
(
	.encode_In(encode_In),
	.level(level),
	.Binary_Out(Binary_Out),
	.errorFlag(errorFlag)
);

//******Provide Stimulus******
	initial begin //this process block specifies the stimulus.
		level = 3'd1;
		clk = 0;
		encode_In = 32'h0000_0000;//errorFlag=1

		/*************************************/
		#1 level = 3'd1;
		#1 encode_In = 32'h0000_0001;

		#62
		#1 level = 3'd2;
		#1 encode_In = 32'h0000_0003;	

		#62
		#1 level = 3'd3;
		#1 encode_In = 32'h8000_0002;	
   	
		#62
		#1 level = 3'd3;
		#1 encode_In = 32'h8000_0003;	
		
		#62
		#1 level = 3'd1;


	#63 $stop;
	end

	initial begin// this process block pipes the ASCII results to the terminal or text editor	
		$timeformat(-9,1,"ns",12);
		$display("        Time level encode_In                         errorFlag  Binary_Out");
	end
    	always
		#1 clk = !clk;
	
	always @(posedge clk)begin
		encode_In[31:1] <= encode_In[30:0];
	    	encode_In[0] <= encode_In[31];
		$monitor("%t  %d    %b    %b               %d",$realtime,level,encode_In,errorFlag,Binary_Out);		
	end
	
	
	endmodule
