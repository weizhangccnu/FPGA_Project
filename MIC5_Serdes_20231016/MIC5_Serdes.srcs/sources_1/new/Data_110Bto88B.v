`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/17 22:35:19
// Design Name: 
// Module Name: Data_110Bto88B
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


module Data_110Bto88B(
    input clk,                              // input clock, clock_div3
    input reset,                            // reset, high active
    input [109:0] data_110b,                // 110bit input data
    output [87:0] data_88b                  // 88bit output data
);
// decoder_8b10b inst0
decoder_8b10b decoder_8b10b_inst0(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.din(data_110b[109:100]),
	.dout(data_88b[87:80]),
	.kout("open"),
	.code_err("open"),
	.disp("open"),
	.disp_err("open")
);

// decoder_8b10b inst1
decoder_8b10b decoder_8b10b_inst1(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.din(data_110b[99:90]),
	.dout(data_88b[79:72]),
	.kout("open"),
	.code_err("open"),
	.disp("open"),
	.disp_err("open")
);

// decoder_8b10b inst2
decoder_8b10b decoder_8b10b_inst2(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.din(data_110b[89:80]),
	.dout(data_88b[71:64]),
	.kout("open"),
	.code_err("open"),
	.disp("open"),
	.disp_err("open")
);

// decoder_8b10b inst3
decoder_8b10b decoder_8b10b_inst3(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.din(data_110b[79:70]),
	.dout(data_88b[63:56]),
	.kout("open"),
	.code_err("open"),
	.disp("open"),
	.disp_err("open")
);

// decoder_8b10b inst4
decoder_8b10b decoder_8b10b_inst4(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.din(data_110b[69:60]),
	.dout(data_88b[55:48]),
	.kout("open"),
	.code_err("open"),
	.disp("open"),
	.disp_err("open")
);

// decoder_8b10b inst5
decoder_8b10b decoder_8b10b_inst5(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.din(data_110b[59:50]),
	.dout(data_88b[47:40]),
	.kout("open"),
	.code_err("open"),
	.disp("open"),
	.disp_err("open")
);

// decoder_8b10b inst6
decoder_8b10b decoder_8b10b_inst6(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.din(data_110b[49:40]),
	.dout(data_88b[39:32]),
	.kout("open"),
	.code_err("open"),
	.disp("open"),
	.disp_err("open")
);

// decoder_8b10b inst7
decoder_8b10b decoder_8b10b_inst7(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.din(data_110b[39:30]),
	.dout(data_88b[31:24]),
	.kout("open"),
	.code_err("open"),
	.disp("open"),
	.disp_err("open")
);

// decoder_8b10b inst8
decoder_8b10b decoder_8b10b_inst8(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.din(data_110b[29:20]),
	.dout(data_88b[23:16]),
	.kout("open"),
	.code_err("open"),
	.disp("open"),
	.disp_err("open")
);

// decoder_8b10b inst9
decoder_8b10b decoder_8b10b_inst9(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.din(data_110b[19:10]),
	.dout(data_88b[15:8]),
	.kout("open"),
	.code_err("open"),
	.disp("open"),
	.disp_err("open")
);

// decoder_8b10b inst10
decoder_8b10b decoder_8b10b_inst10(
	.clk(clk),
	.rst(reset),
	.en(1'b1),
	.din(data_110b[9:0]),
	.dout(data_88b[7:0]),
	.kout("open"),
	.code_err("open"),
	.disp("open"),
	.disp_err("open")
);
endmodule
