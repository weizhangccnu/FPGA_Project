`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CCNU    
// Engineer: WeiZhang
// 
// Create Date: 01/09/2018 05:42:39 PM
// Design Name: 
// Module Name: ILA_Test
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
module ILA_Test(
input   sys_clk_p,
input   sys_clk_n,
input   sys_rst, 
output  reg [7:0]led
//output clk_out
);
wire clk_500M;
wire clk_100M;
wire clk_50M;
wire clk_10M;
//--------------------------------------------------//
 clk_wiz_0 clk_wiz_0_inst
   (
    // Clock in ports
    .clk_in1_p(sys_clk_p),      // input clk_in1_p
    .clk_in1_n(sys_clk_n),      // input clk_in1_n
    // Clock out ports
    .clk_out1(clk_500M),        // output clk_out1=200M
    .clk_out2(clk_100M),        // output clk_out2=100M
    .clk_out3(clk_50M),         // output clk_out3=50M
    .clk_out4(clk_10M),         // output clk_out4=10M
    // Status and control signals
    .reset(sys_rst),            // input reset
    .locked(1'b0)
);                              // output locked
//--------------------------------------------------//
(*mark_debug = "true"*) reg [23:0]counter;
(*mark_debug = "true"*) wire [7:0]led1;
assign led1 = led;

always @(posedge clk_50M)
begin
    if(sys_rst)
    begin
        counter <= 1'b0;
        led <= 8'b00000001;
    end
    else
    begin
        counter <= counter + 1'b1;
        if(counter == 24'h000fff)
        begin
            counter <= 24'h000000;
            led <= {led[0], led[7:1]};
        end
    end
end 
//assign clk_out = clk_300M;
//--------------------------------------------------< ial_0
//ila_0 debug core
ila_0 ila_0_inst (
	.clk(clk_100M),            // input wire clk
	.probe0(counter),          // input wire [23:0]  probe0  
	.probe1(led1)              // input wire [7:0]  probe1
);
//--------------------------------------------------> ila_0
//--------------------------------------------------< vio_0
wire [7:0]aout;
wire [7:0]bout;
wire [7:0]cin;
assign cin = aout | bout;
vio_0 vio_0_inst (
  .clk(clk_100M),               // input wire clk
  .probe_in0(cin),              // input wire [7 : 0] probe_in0
  .probe_out0(aout),            // output wire [7 : 0] probe_out0
  .probe_out1(bout)             // output wire [7 : 0] probe_out1
);
//--------------------------------------------------> vio_0

endmodule
