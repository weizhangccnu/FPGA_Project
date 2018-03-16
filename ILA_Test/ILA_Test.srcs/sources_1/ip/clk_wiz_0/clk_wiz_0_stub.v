// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.2 (lin64) Build 1577090 Thu Jun  2 16:32:35 MDT 2016
// Date        : Tue Jan  9 22:31:20 2018
// Host        : localhost.localdomain running 64-bit CentOS Linux release 7.3.1611 (Core)
// Command     : write_verilog -force -mode synth_stub
//               /home/xinghuang/Desktop/ILA_Test/ILA_Test.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_in1_p, clk_in1_n, clk_out1, clk_out2, clk_out3, clk_out4, reset, locked)
/* synthesis syn_black_box black_box_pad_pin="clk_in1_p,clk_in1_n,clk_out1,clk_out2,clk_out3,clk_out4,reset,locked" */;
  input clk_in1_p;
  input clk_in1_n;
  output clk_out1;
  output clk_out2;
  output clk_out3;
  output clk_out4;
  input reset;
  output locked;
endmodule
