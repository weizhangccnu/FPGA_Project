//***********************************************************//
// module name: Program_mode.v 
// author: Wei Zhang
// Date: March 2rd, 2021
// Description: This module is used to program and read efuse.
//              
//***********************************************************//
`timescale 1ns/1ps
module Program_mode(
	input wire clk_1M,			// system clock
	input wire rst,					// system rst
	input wire [31:0] program_bit,	// 32-bit program data
	output reg CSB,					// chip select enable
	output reg PGM,					// Program mode
	output reg SCLK,				// serial clock
	output reg DIN,					// serial data input
	input wire DOUT					// serial data output
);

reg [7:0] cont; 
reg [5:0] prog_num;					// program number
reg [5:0] read_num;					// read number
reg [3:0] state;
localparam rst1 = 4'b0000;			// reset state
localparam sop = 4'b0001;			// start of program
localparam pro = 4'b0010;			// program
localparam pro1 = 4'b0011;			// program 1
localparam eop = 4'b0100;			// end of program
localparam sor = 4'b0101;			// start of read
localparam read = 4'b0110;			// state of read
localparam read1 = 4'b0111;			// state of read1
localparam eor = 4'b1000;			// end of read
			
//***********************************************************//
always @(posedge clk_1M)
begin
	if(rst)
	begin
		state = rst1;
	end
	else
	begin
		case(state)
			rst1:						// reset state
			begin
				CSB <= 1'b1;
				SCLK <= 1'b0;
				PGM <= 1'b1;
				DIN <= 1'b0;
				cont <= 8'd50;				
				state <= sop;			
			end

			sop:						// start of program
			begin
				if(cont == 8'd25)
				begin
					cont <= cont - 1'b1;
					CSB <= 1'b0;			// falling edge of the CSB	
					state <= sop;
				end
				else if(cont == 6'd0)
				begin
					prog_num <= 6'd0;				
					state <= pro;
				end
				else
				begin
					cont <= cont - 1'b1;
					state <= sop;			// jump to program 
				end			
			end

			pro: 						// programming state
			begin
				if(prog_num <= 6'd31)
				begin
					cont <= 8'd7;
					PGM <= (program_bit >> prog_num)&1'b1;
					prog_num <= prog_num + 1'b1;
					state <= pro1;
		 		end               
				else
				begin
					cont <= 8'd50;
					PGM <= 1'b0;
					state <= eop;
				end         
			end	
			
			pro1:							// jump to program 1 state
			begin
				if(cont == 8'd5)
				begin
					SCLK <= 1'b1;
					state <= pro1;
					cont <= cont - 1'b1;				
				end
				else if(cont == 8'd0)
				begin
					SCLK <= 1'b0;
					state <= pro;
				end
				else
				begin
					state <= pro1;
					cont <= cont - 1'b1;
				end				
			end			

			eop:							// jump to end of program state
			begin
				if(cont == 8'd25)
				begin
					CSB <= 1'b1;
					PGM <= 1'b0;
					cont <= cont - 1'b1;
					state <= eop;			// jump to start of read
				end	
				else if(cont == 8'd0)
				begin
					cont <= 8'd30;
					SCLK <= 1'b1;
					state <= sor;
				end	
				else
				begin
					cont <= cont - 1'b1;
					state <= eop;
				end
			end

			sor:
			begin
				cont <= cont - 1'b1;
				if(cont == 8'd0)
				begin
					CSB <= 1'b0;
					read_num <= 6'd0;
					state <= read;
				end
				else
				begin
					state <= sor;
				end
			end
		
			read:
			begin 
				if(read_num <= 6'd31)
				begin
					cont <= 8'd8;
					read_num <= read_num + 1'b1;
					state <= read1;
		 		end               
				else
				begin
					cont <= 8'd20;
					state <= eor;
				end 
			end

			read1:
			begin
				if(cont == 8'd5)
				begin
					SCLK <= 1'b0;
					state <= read1;
					cont <= cont - 1'b1;
				end
				else if(cont == 8'd0)
				begin
					SCLK <= 1'b1;
					state <= read;
				end
				else
				begin
					state <= read1;
					cont <= cont - 1'b1;
				end	
			end
			
			eor: 							// end of read
			begin
				if(cont == 6'd0)
				begin
					CSB <= 1'b1;
					SCLK <= 1'b0;
				end
				else
				begin
					cont <= cont - 1'b1;
					state <= eor;
				end
			end
		endcase
	end
end

endmodule



