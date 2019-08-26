//Verilog HDL for "testSimpleRO", "testbench0" "functional"
/*
-- ETROC1 readout testbench2
-- jamieson olsen
-- 
-- this testbench does not use an external vector file, all test vectors are generated 
-- within this file.
*/

`timescale 1ps/100fs
module testbench0 (
	clock,
	reset,
	l1acc,
	bc0,
	roi,
	dout_sch
 );
output clock;
output reset;
output l1acc;
output bc0;
output roi;
//output din;
input [29:0] dout_sch;

reg clock;
reg reset;
reg l1acc;
reg bc0;
reg [15:0] roi;
reg [29:0] din [0:3] [0:3];
reg [11:0] bc0_counter;
reg [3:0] R_reg, C_reg;
reg [23:0] bcid;
reg [14:0] l1acc_counter;
wire [29:0] dout_rtl;

initial begin
	$sdf_annotate("SRO_RAM.sdf", etroc1_inst, "TYPICAL", "FROM_MTM");			//standard delay format file
	$sdf_annotate("SRO_Ctrl.sdf", etroc1_inst, "TYPICAL", "FROM_MTM");			//standard delay format file
end

initial begin
clock = 0;
reset = 1;
#10_000 
reset = 0;
#37_000
reset = 1;

#500_000_000
$finish();
end

always #12500 clock = ~clock;		//-- 40MHz BX

always@(negedge reset or negedge clock) begin		//make the periodic BC0 marker
	if(!reset) begin
		bc0_counter <= 0;
		bc0 <= 0;
	end
	else if(bc0_counter == 4) begin
		bc0_counter <= bc0_counter + 1;
		bc0 <= 1;
	end
	else if(bc0_counter == 5) begin
		bc0_counter <= bc0_counter + 1;
		bc0 <= 0;
	end
	else if(bc0_counter == 3556)
		bc0_counter <= 0;
	else
		bc0_counter <= bc0_counter + 1;	
end


always@(negedge clock) begin
	if(bc0)
		bcid <= 0;
	else
		bcid <= bcid + 1;
end

integer R_int, C_int;
always@(bcid) begin
	for (R_int = 0; R_int < 4; R_int = R_int + 1) begin
		for (C_int = 0; C_int < 4; C_int = C_int + 1) begin
			R_reg = R_int;
			C_reg = C_int;
			din[R_int][C_int] <={2'b00,R_reg,C_reg,bcid[19:0]};
		end
	end
end


always@(negedge reset or negedge clock) begin
	if(!reset) begin
		l1acc_counter <= 0;
		l1acc <= 0;
		roi <= 0;
	end
	else if(l1acc_counter == 400) begin	// 10us
		l1acc_counter <= l1acc_counter + 1;
		roi <= 16'h0040;					// all pixels enabled
		l1acc <= 1;
	end
	else if(l1acc_counter == 401) begin	
		l1acc_counter <= l1acc_counter + 1;
	//	roi <= 16'hffff;					
		l1acc <= 0;
	end
	
	else if(l1acc_counter == 1000) begin	// 10us + 120 us
		l1acc_counter <= l1acc_counter + 1;
		roi <= 16'h0080;					// 3 pixels enabled: R3C3, R0C1, R0C0
		l1acc <= 1;
	end
	else if(l1acc_counter == 1001) begin	
		l1acc_counter <= l1acc_counter + 1;
	//	roi <= 16'hffff;					
		l1acc <= 0;
	end

	else if(l1acc_counter == 2000) begin	// 10us + 120 us + 72 us
		l1acc_counter <= l1acc_counter + 1;
		roi <= 16'h0100;					// 3 pixels enabled: R3C3, R0C1, R0C0
		l1acc <= 1;
	end
	else if(l1acc_counter == 2001) begin	
		l1acc_counter <= l1acc_counter + 1;
	//	roi <= 16'hffff;					
		l1acc <= 0;
	end

	else if(l1acc_counter == 3000) begin	// 10us + 120 us + 72 us + 83us
		l1acc_counter <= l1acc_counter + 1;
		roi <= 16'h0200;					// 3 pixels enabled: R3C3, R0C1, R0C0
		l1acc <= 1;
	end
	else if(l1acc_counter == 3001) begin	
		l1acc_counter <= l1acc_counter + 1;
	//	roi <= 16'hffff;					
		l1acc <= 0;
	end
	else if(l1acc_counter == 4000) begin	// 10us + 120 us + 72 us + 83us
		l1acc_counter <= l1acc_counter + 1;
		roi <= 16'h0400;					// 3 pixels enabled: R3C3, R0C1, R0C0
		l1acc <= 1;
	end

	else if(l1acc_counter == 4001) begin	
		l1acc_counter <= l1acc_counter + 1;
	//	roi <= 16'hffff;					
		l1acc <= 0;
	end
	else if(l1acc_counter == 5000) begin	// 10us + 120 us + 72 us + 83us
		l1acc_counter <= l1acc_counter + 1;
		roi <= 16'h0800;					// 3 pixels enabled: R3C3, R0C1, R0C0
		l1acc <= 1;
	end

	else if(l1acc_counter == 5001) begin	
		l1acc_counter <= l1acc_counter + 1;
	//	roi <= 16'hffff;					
		l1acc <= 0;
	end
	else if(l1acc_counter == 6000) begin	// 10us + 120 us + 72 us + 83us
		l1acc_counter <= l1acc_counter + 1;
		roi <= 16'h1000;					// 3 pixels enabled: R3C3, R0C1, R0C0
		l1acc <= 1;
	end

	else if(l1acc_counter == 6001) begin	
		l1acc_counter <= l1acc_counter + 1;
	//	roi <= 16'hffff;					
		l1acc <= 0;
	end
	else if(l1acc_counter == 7000) begin	// 10us + 120 us + 72 us + 83us
		l1acc_counter <= l1acc_counter + 1;
		roi <= 16'h2000;					// 3 pixels enabled: R3C3, R0C1, R0C0
		l1acc <= 1;
	end

	else if(l1acc_counter == 7001) begin	
		l1acc_counter <= l1acc_counter + 1;
	//	roi <= 16'hffff;					
		l1acc <= 0;
	end
	else if(l1acc_counter == 8000) begin	// 10us + 120 us + 72 us + 83us
		l1acc_counter <= l1acc_counter + 1;
		roi <= 16'h4000;					// 3 pixels enabled: R3C3, R0C1, R0C0
		l1acc <= 1;
	end

	else if(l1acc_counter == 8001) begin	
		l1acc_counter <= l1acc_counter + 1;
	//	roi <= 16'hffff;					
		l1acc <= 0;
	end
	else if(l1acc_counter == 9000) begin	// 10us + 120 us + 72 us + 83us
		l1acc_counter <= l1acc_counter + 1;
		roi <= 16'h8000;					// 3 pixels enabled: R3C3, R0C1, R0C0
		l1acc <= 1;
	end

	else if(l1acc_counter == 9001) begin	
		l1acc_counter <= l1acc_counter + 1;
	//	roi <= 16'hffff;					
		l1acc <= 0;
	end
	else if(l1acc_counter == 10000) begin	// 10us + 120 us + 72 us + 83us
		l1acc_counter <= l1acc_counter + 1;
		roi <= 16'h2222;					// 3 pixels enabled: R3C3, R0C1, R0C0
		l1acc <= 1;
	end

	else if(l1acc_counter == 10001) begin	
		l1acc_counter <= l1acc_counter + 1;
	//	roi <= 16'hffff;					
		l1acc <= 0;
	end
	else if(l1acc_counter == 12000) begin	// 10us + 120 us + 72 us + 83us
		l1acc_counter <= l1acc_counter + 1;
		roi <= 16'h00f0;					// 3 pixels enabled: R3C3, R0C1, R0C0
		l1acc <= 1;
	end

	else if(l1acc_counter == 12001) begin	
		l1acc_counter <= l1acc_counter + 1;
	//	roi <= 16'hffff;					
		l1acc <= 0;
	end
	else if(l1acc_counter == 14000) begin	// 10us + 120 us + 72 us + 83us
		l1acc_counter <= l1acc_counter + 1;
		roi <= 16'hffff;					// 3 pixels enabled: R3C3, R0C1, R0C0
		l1acc <= 1;
	end

	else if(l1acc_counter == 14001) begin	
		l1acc_counter <= l1acc_counter + 1;
	//	roi <= 16'hffff;					
		l1acc <= 0;
	end
	else
		l1acc_counter <= l1acc_counter + 1;

end

etroc1 etroc1_inst(
			.clock(clock),
			.reset(reset),
			.l1acc(l1acc),
			.bc0(bc0),
			.roi(roi),
			.din_0_0(din[0][0]),
			.din_1_0(din[1][0]),
			.din_2_0(din[2][0]),
			.din_3_0(din[3][0]),
			.din_0_1(din[0][1]),
			.din_1_1(din[1][1]),
			.din_2_1(din[2][1]),
			.din_3_1(din[3][1]),
			.din_0_2(din[0][2]),
			.din_1_2(din[1][2]),
			.din_2_2(din[2][2]),
			.din_3_2(din[3][2]),
			.din_0_3(din[0][3]),
			.din_1_3(din[1][3]),
			.din_2_3(din[2][3]),
			.din_3_3(din[3][3]),
			.dout(dout_rtl)
);


endmodule
