/*fine_data_encoder
 * deacription: Encode 35-bit fine data to 6-bit binary data
 * author: Wei Zhang
 * date: Sept 25th, 2023
 * version: v0
 *
 */
`timescale 1ps/10fs

module TDC_encoder(
	input [54:0] fine_raw_code,         // fine data input, 55-bit
	input [4:0]	counterA,				// ripple counter A, 5-bit
	input [4:0]	counterB,				// ripple counter B, 5-bit
    output [11:0] TDC_bin_code          // TDC encoded output, 12-bit 
);

wire [6:0] fine_bin_code;
wire [4:0] coarse_code;
assign coarse_code = (fine_raw_code[0] == 1'b1) ? counterA : counterB;
assign TDC_bin_code = coarse_code*110 + fine_bin_code;

//-----------------------------------------------> fine data encoder
fine_data_encoder fine_data_encoder_inst(
	.fine_raw_code(fine_raw_code),			// fine data input, 55-bit
	.fine_bin_code(fine_bin_code)			// fine data encoded output, 7-bit 
 );
//-----------------------------------------------> fine data encoder

endmodule
