//`include "./export.v"

`timescale 1 ns/10 ps

`define T_200m_half 2.5

module SiPMROC_digital_tb();

parameter EVENT_PERIOD = 2000;
parameter GLOBAL_DELAY = 100; 
parameter DISCHARGE_PREWAITING= 50; 
//parameter integer event_width[17] = '{17{200}};
//parameter integer discharge_width[17] = '{17{200}};

parameter integer event_width[17] = '{10, 20, 30, 40, 50, 60, 70, 80, 90, -40, 110, 120, 130, 140, 150, 160, 170};
parameter integer discharge_width[17] = '{10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170};

reg EXT_CLK_200M;
initial // Clock generator
  begin
    EXT_CLK_200M = 0;
    forever #`T_200m_half EXT_CLK_200M = !EXT_CLK_200M;
  end

//initial sdf file for simulating Encoder logic after layout
/*
initial begin
	$sdf_annotate("./exportsdf.sdf", SiPMROC_digital_inst);			//standard delay format file
end
*/
reg rst;
initial
    begin
        rst = 0;
        #303 rst = 1;
		#206 rst = 0;
		#50000 $stop;
    end

reg [16:0] pulse;
reg [16:0] discharge;

genvar i;
generate
for(i=0;i<17;i=i+1) begin:gen_pulses
// Discharge signal
initial
begin
    discharge[i] = 1'b0;
    #(DISCHARGE_PREWAITING)
    forever begin
        #(DISCHARGE_PREWAITING +5) discharge[i] = 1'b1;
        #(discharge_width[i]+20) discharge[i] = 1'b0;
        #(EVENT_PERIOD - ((discharge_width[i])) - DISCHARGE_PREWAITING-5-20) ;
    end
end
// Energy signal
initial
begin
    pulse[i] = 1'b0;
    #(DISCHARGE_PREWAITING)
    forever begin
        #(DISCHARGE_PREWAITING) pulse[i] = 1'b1;
        #(event_width[i]) pulse[i] = 1'b0;
        #(EVENT_PERIOD - event_width[i] - (DISCHARGE_PREWAITING)) ;
    end
end



end
endgenerate

wire serial_data_en;
wire serial_data;
SiPMROC_digital SiPMROC_digital_inst(
    .clk_200m(EXT_CLK_200M),//input clk_200m,

    .rst(rst),                  //input rst,

    .channel_energy_pulses(pulse[16:0]),            //input [16:1] energy_pulse,
    .discharge(discharge),                      //input [17:1] discharge,

    .serial_data_en(serial_data_en),          //output serial_data_en,
    .serial_data(serial_data)              //output serial_data
);

endmodule
