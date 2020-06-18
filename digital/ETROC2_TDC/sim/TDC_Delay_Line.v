/**
 *
 *  file: TDC_Delay_Line.v
 *
 *  TDC_Delay behavior describe
 *
 *  History:
 *  2020/06/16 Wei Zhang    : Created
 **/
`timescale 1ps/100fs
//--------------------------------------------------------------->
module NANDCell(
	input A,
	input B,
	output Z
);
wire temp;
assign temp = (A==1'b0)?1'b1:(!B);
buf #(18,18) (Z, temp);
endmodule
//---------------------------------------------------------------<

//--------------------------------------------------------------->
module TDC_Delay_Line(
	input 	Start,
	input 	TOA_Clk,
	input 	TOT_Clk,
	output	reg [62:0] TOARawData,
	output	reg [20:0] TOTRawData,
	output	Counter_Clk
);
initial begin
	TOARawData = {63{1'b0}};
	TOTRawData = {21{1'b0}};
end

wire [62:0] A;
wire [62:0] B;
wire [62:0] Z;

assign A[0] = Start;
assign A[62:1] = {62{1'b1}};
assign B[62:0] = {Z[61:0],Z[62]};

genvar i;
generate
	for(i = 0; i < 63; i=i+1) begin : NANDLOOP
		NANDCell UNANDCell(A[i], B[i], Z[i]);
	end
endgenerate

// TOARawData capture
always @(posedge TOA_Clk)
begin
	TOARawData <= Z[62:0];
end

// TOARawData capture
always @(posedge TOT_Clk)
begin
	TOTRawData <= {Z[60],Z[57],Z[54],Z[51],Z[48],Z[45],Z[42],Z[39],Z[36],Z[33],Z[30],Z[27],Z[24],Z[21],Z[18],Z[15],Z[12],Z[9],Z[6],Z[3],Z[0]};
end

assign Counter_Clk = Z[31];
//---------------------------------------------------------------<
endmodule
