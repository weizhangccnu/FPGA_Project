`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Wuhan Textile University
// Engineer: WeiZhang
// 
// Create Date: 2023/10/16 19:28:17
// Design Name: Data 96bit to 120bit
// Module Name: Data_96Bto120B
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Data_96Bto120B(
    input clk,                      // input clock, clock_div3
    input reset,                    // reset, high active
    input [95:0] data_96b,          // 96bit input data
    output [119:0] data_120b        // 120bit output data
    );
 // inst0
 encoder_8b10b encoder_8b10b_inst0(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.kin(1'b0),
	.din(data_96b[7:0]),
	.dout(data_120b[9:0]),
	.disp("open"),
	.kin_err("open")
);

 // inst1
 encoder_8b10b encoder_8b10b_inst1(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.kin(1'b0),
	.din(data_96b[15:8]),
	.dout(data_120b[19:10]),
	.disp("open"),
	.kin_err("open")
);

 // inst2
 encoder_8b10b encoder_8b10b_inst2(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.kin(1'b0),
	.din(data_96b[23:16]),
	.dout(data_120b[29:20]),
	.disp("open"),
	.kin_err("open")
);

 // inst3
 encoder_8b10b encoder_8b10b_inst3(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.kin(1'b0),
	.din(data_96b[31:24]),
	.dout(data_120b[39:30]),
	.disp("open"),
	.kin_err("open")
);

 // inst4
 encoder_8b10b encoder_8b10b_inst4(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.kin(1'b0),
	.din(data_96b[39:32]),
	.dout(data_120b[49:40]),
	.disp("open"),
	.kin_err("open")
);

 // inst5
 encoder_8b10b encoder_8b10b_inst5(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.kin(1'b0),
	.din(data_96b[47:40]),
	.dout(data_120b[59:50]),
	.disp("open"),
	.kin_err("open")
);

 // inst6
 encoder_8b10b encoder_8b10b_inst6(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.kin(1'b0),
	.din(data_96b[56:48]),
	.dout(data_120b[69:60]),
	.disp("open"),
	.kin_err("open")
);

 // inst7
 encoder_8b10b encoder_8b10b_inst7(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.kin(1'b0),
	.din(data_96b[63:57]),
	.dout(data_120b[79:70]),
	.disp("open"),
	.kin_err("open")
);

 // inst8
 encoder_8b10b encoder_8b10b_inst8(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.kin(1'b0),
	.din(data_96b[71:64]),
	.dout(data_120b[89:80]),
	.disp("open"),
	.kin_err("open")
);

 // inst9
 encoder_8b10b encoder_8b10b_inst9(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.kin(1'b0),
	.din(data_96b[79:72]),
	.dout(data_120b[99:90]),
	.disp("open"),
	.kin_err("open")
);

 // inst10
 encoder_8b10b encoder_8b10b_inst10(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.kin(1'b0),
	.din(data_96b[87:80]),
	.dout(data_120b[109:100]),
	.disp("open"),
	.kin_err("open")
);

 // inst11
 encoder_8b10b encoder_8b10b_inst11(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.kin(1'b0),
	.din(data_96b[95:88]),
	.dout(data_120b[119:110]),
	.disp("open"),
	.kin_err("open")
);
endmodule
