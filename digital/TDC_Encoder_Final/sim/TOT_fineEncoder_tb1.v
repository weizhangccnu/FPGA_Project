`timescale 1ns/1ps


//******Module Declaration******
module TOT_fineEncoder_tb1;

//******Signal Declaration******
reg [62:0] encode_In;
reg [2:0] level;//proper values of level ={1,2,3}
wire[31:0] TOT_encode_In;
wire[5:0] Binary_Out;
wire errorFlag;

reg clk;


//******Instantiation of Top-level Design******
TOT_fineEncoder Encoder1
(
	.encode_In(TOT_encode_In),
	.level(level),
	.Binary_Out(Binary_Out),
	.errorFlag(errorFlag)  
);


//******Provide Stimulus******
	initial begin //this process block specifies the stimulus.
		level = 3'd1;
		clk = 0;
		encode_In = 63'b000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
		
		#1 level = 3'd1;
		#1 encode_In = 63'b101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101_0101;
		#124

		#1 level = 3'd1;
		#1 encode_In = 63'b110_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1010_1011;
		#124 

		#1 level = 3'd1;
		
		#126 $stop;
	end

	initial begin// this process block pipes the ASCII results to the terminal or text editor	
		$timeformat(-9,1,"ns",12);
		$display("        Time level TOT_encode_In                    Binary_Out[5] Binary_Out[4:0] errorFlag");	
	end


//	always 
//	#1 begin TOT_encode_In[0] = encode_In[0];
//		for(gi = 1; gi < 32; gi=gi+1) 
//			TOT_encode_In[gi] = encode_In[(2*gi)];
//	end

	assign TOT_encode_In = {encode_In[62],encode_In[60],encode_In[58],encode_In[56],encode_In[54],encode_In[52],encode_In[50],encode_In[48],encode_In[46],encode_In[44],encode_In[42],encode_In[40],encode_In[38],encode_In[36],encode_In[34],encode_In[32],encode_In[30],encode_In[28],encode_In[26],encode_In[24],encode_In[22],encode_In[20],encode_In[18],encode_In[16],encode_In[14],encode_In[12],encode_In[10],encode_In[8],encode_In[6],encode_In[4],encode_In[2],encode_In[0]};

	always
		#1 clk = !clk;
	
	always @(posedge clk)begin
		encode_In[62:1] <= encode_In[61:0];
	    	encode_In[0] <= encode_In[62];
		$monitor("%t  %d    %b     %d             %d               %d",$realtime,level,TOT_encode_In,Binary_Out[5],Binary_Out[4:0],errorFlag);		
	end
	endmodule
