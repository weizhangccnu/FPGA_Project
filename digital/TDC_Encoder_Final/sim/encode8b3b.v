/**
 *
  *  file: encode8b3b.v
 *
 *  encode8b3b
 *  Encode 8 bits therometer code to 6 bits binary code
 *
 *  History:
 *  2019/02/25 Hanhan Sun    : Created
 *  2019/02/26 Datao Gong    : Revised
 *  2019/03/06 Hanhan Sun    : Revised and verified
 **/
`timescale 1ns/1ps

module encode8b3b
(
	input [7:0] encode_In, //therometer code in
	input [2:0] level,  //proper values of level ={1,2,3}
	output[2:0] Binary_Out,
	output bubbleError,
    	output error   //error flag
);
	wire[2:0] right,left,diff;

	assign right= (encode_In[7]==1)? 3'd7:(  
			(encode_In[6]==1)? 3'd6:(  		
				(encode_In[5]==1)? 3'd5:(  		
					(encode_In[4]==1)? 3'd4:(  		
						(encode_In[3]==1)? 3'd3:(  							
							(encode_In[2]==1)? 3'd2:(  		
								(encode_In[1]==1)? 3'd1:3'd0))))));

	assign left= (encode_In[0]==1)? 3'd0:(  
			(encode_In[1]==1)? 3'd1:(  		
				(encode_In[2]==1)? 3'd2:(  		
					(encode_In[3]==1)? 3'd3:(  		
						(encode_In[4]==1)? 3'd4:(  							
							(encode_In[5]==1)? 3'd5:(  		
								(encode_In[6]==1)? 3'd6:3'd7))))));
	assign diff = right - left;
	assign error = diff >= level; 
	assign bubbleError = (diff != 2'b00);
	assign Binary_Out = error ? 3'b000:(       //if error, the output code is zero
						(diff == 3'b000)?left:(   //right = left, level == 1 
							(diff == 3'b001)?left:left+1));       
	 
endmodule
