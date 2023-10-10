/* 
 * filename: fine_data_encoder
 * description: Encode 35-bit fine data to 6-bit binary data
 * author: Wei Zhang
 * date: Sept 25th, 2023
 * version: v0
 *
 */
`timescale 1ps/10fs

module fine_data_encoder(
	input [54:0] fine_raw_code,			// fine data input, 55-bit
	output [6:0] fine_bin_code			// fine data encoded output, 7-bit 
);
wire [4:0] grp [10:0];					// fine date was divided into 11 groups
wire [10:0] and_res0;					// group and operation results0
wire [10:0] or_res0;					// group or operation results0
wire [10:0] xor_res1;					// group xor operation results1
wire [10:0] and_res1;					// group and operation results1
wire [10:0] xor_res2;					// and_res1 operation results2

//------------------------------------------------------> fine data group
parameter grp_num = 11;
genvar i;
generate
for(i=0; i<grp_num; i=i+1)
begin
	assign grp[i] = {fine_raw_code[i*5+4], fine_raw_code[i*5+3], fine_raw_code[i*5+2], fine_raw_code[i*5+1], fine_raw_code[i*5+0]};
end
endgenerate
//------------------------------------------------------< fine data group

//------------------------------------------------------> group data and/or operation
genvar j;
generate
for(j=0; j<grp_num; j=j+1)
begin 
	assign and_res0[j] = grp[j][0] & grp[j][1] & grp[j][2] & grp[j][3] & grp[j][4];
	assign or_res0[j] = grp[j][0] | grp[j][1] | grp[j][2] | grp[j][3] | grp[j][4];
end
endgenerate
//------------------------------------------------------< group data and/or operation

//------------------------------------------------------> group data xor/and operation
genvar k;
generate
for(k=0; k<grp_num; k=k+1)
begin 
	assign xor_res1[k] = and_res0[k] ^ or_res0[k];
	assign and_res1[k] = and_res0[k] & or_res0[k];
end
endgenerate
//------------------------------------------------------< group data xor/and operation
//------------------------------------------------------> xor_res1 data xor operation
genvar l;
generate
for(l=0; l<grp_num; l=l+1)
	if(l == grp_num - 1)
		assign xor_res2[l] = !(and_res1[l] ^ and_res1[0]);
	else
		assign xor_res2[l] = !(and_res1[l] ^ and_res1[l+1]);
endgenerate
//------------------------------------------------------> xor_res1 data xor operation
//------------------------------------------------------> sum of xor_res1 
wire [3:0] sum_xor_res1;				// sum of xor_res1
assign sum_xor_res1 = (|xor_res1[10:0]);
//------------------------------------------------------> sum of xor_res1

//------------------------------------------------------> find one inst 
wire [3:0] index;
find_one find_one_inst(
	.din(xor_res1),
	.index(index)
);
//------------------------------------------------------> find one inst 
//------------------------------------------------------> find one inst 
wire [3:0] index1;
find_one find_one_inst1(
	.din(xor_res2),
	.index(index1)
);
//------------------------------------------------------> find one inst 

wire [3:0] fine_grp;
assign fine_grp = {fine_raw_code[index*5+4]^fine_raw_code[index*5+3], fine_raw_code[index*5+3]^fine_raw_code[index*5+2], fine_raw_code[index*5+2]^fine_raw_code[index*5+1], fine_raw_code[index*5+1]^fine_raw_code[index*5+0]};

//------------------------------------------------------> find one inst 
wire [3:0] index2;
find_one find_one_inst2(
	.din({7'b0000000, fine_grp}),
	.index(index2)
);
//------------------------------------------------------> find one inst 
assign fine_bin_code = ((sum_xor_res1 == 1'b1) ? (index*5 + index2) : ((index1+1)*5 - 1'b1)) + fine_raw_code[0]*55; 
endmodule
