`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Wuhan Textile University
// Engineer: Wei Zhang  
// 
// Create Date: 2023/10/14 21:26:15
// Design Name: header alignment
// Module Name: header_alignment
// Project Name: mic5_serdes
// Target Devices: KC705 Board
// Tool Versions: vivado 2019.2
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module header_alignment(
    input clk,                          // input clock 50 MHz
    input rstn,                         // system reset, low active
    input [39:0] frame_data,            // input data 40-bit
    output reg [9:0] header,                // header 10'h0ea
    output reg [109:0] received_data    // received data 110-bit
);

reg [239:0] data;
reg [6:0] shift_counter;
reg [1:0] cnt;
wire [9:0] header0;
always @(posedge clk or negedge rstn)
begin
    if(!rstn)
    begin
        cnt <= 2'b00;
        shift_counter <= 7'b000_0000;
        data <= 240'd0;
    end
    else
    begin
        cnt <= cnt + 1'b1;
        data <= {frame_data, data[239:40]};
        if(cnt == 2'b10)                                        // wait 3 period then check the header
        begin
            cnt <= 2'b00;
            header <= header0;
            if(header0 == 10'h0ea)
            begin
                shift_counter <= shift_counter;
            end
            else
            begin
                shift_counter <= shift_counter + 1'b1;
            end
            received_data <= data[(shift_counter+109)-:110]; 
        end
    end
end

assign header0 = data[(119+shift_counter)-:10];

//------------------------------------------------------< data extracter
endmodule
