`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2017 11:23:39 PM
// Design Name: 
// Module Name: Two_Dual_Ram_Simulation
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


module Two_Dual_Ram_Simulation(

    );
reg rst = 1'b0;             //system reset
reg [7:0]ain = 8'h0;        //input address
reg [7:0]aout = 8'h0;       //output address
reg [7:0]din = 8'h0;        //input data
reg wr_clk = 1'b0;          //write clock
reg wr_en = 1'b0;           //write enable, active is high
reg rd_clk = 1'b0;          //read clock
reg rd_en = 1'b0;           //read enable, active is high
wire [7:0]dout;             //read output data

reg [7:0]counter = 8'h00;        //define a counter

always begin
#5 wr_clk <= ~wr_clk;          //write clock, period = 20ns
end

always begin
#5 rd_clk <= ~rd_clk;          //read clock, period = 20ns 
end

initial begin                   //generate write in data
ain = 8'h00;
counter = 8'h00;
forever begin
#10 if (counter < 8'hff) begin
        counter <= counter + 1'b1;
    end
    else begin
        counter <= 8'h00;
    end
din = counter;
end
end

initial begin                   //generate system reset
rst = 1'b0;
#149 rst = 1'b1;
#50 rst = 1'b0;
end

initial begin                   //write enable signal
wr_en = 1'b0;
#100 wr_en = 1'b1;
end 

initial begin                   //read enable signal
rd_en = 1'b0;
#1000 rd_en = 1'b1;
end

initial  begin
ain = 8'h00;
forever begin
#10 if(ain < 8'hff)
        ain <= ain +1'b1;
    else
        ain <= 8'h00;    
end
end

initial  begin
#1000 aout = 8'h00;
forever begin
#10 if(aout < 8'hff)
        aout <= aout +1'b1;
    else
        aout <= 8'h00;    
end
end

Two_Dual_Ram my_test(
rst,            //system reset
ain,            //input address
aout,           //output address
din,            //input data
wr_clk,         //write clock
wr_en,          //write enable, active is high
rd_clk,         //read clock
rd_en,          //read enable, active is high
dout            //read output data
    );
endmodule
