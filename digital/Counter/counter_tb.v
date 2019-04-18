//testbench for 4Bit counter
//Auther: Wei Zhang
//Date: April 16, 2019
//Address: SMU Dallas TX.

`timescale 1ns / 1ps

module counter_tb(

);
reg clk1;
reg resetn1;
wire [3:0]cnt1;
wire cout1;

integer fp_r;
integer count=0;
integer cnt;
reg [15:0] reg1;
//***************************provide stimulus*****************************//
initial begin
	resetn1 = 1'b0;
	clk1 = 1'b0;
	#1000 resetn1 = 1'b1;
	#2000 resetn1 = 1'b0;
	#1000 resetn1 = 1'b1;
	fp_r = $fopen("data_file.dat", "r");
	#2000000 $stop;
end

//======================================================================//
always @(posedge clk1)
begin
	if(count < 100)
	begin
		cnt = $fscanf(fp_r, "%d", reg1);
		count <= count + 1;
	end
	else
	begin
		count <= 0;
		$fclose(fp_r);
	end
end

//======================================================================//
always begin
	#200 clk1 <= ~clk1;
end

counter counter_tt(
.clk(clk1), 
.resetn(resetn1), 
.cnt(cnt1), 
.cout(cout1)
);

endmodule

