`timescale 1ns/1ps
module pulse_measurement#(
    parameter RAW_DATA_WIDTH = 10
)
(
    input clk,
    input rst,

    input discharge,

    input pulse_in,

    output [RAW_DATA_WIDTH-1:0] data,
    output reg data_val
);

reg event_start;
reg event_stop;
reg event_came;

reg [RAW_DATA_WIDTH-1:0] data_reg;
assign data = data_reg;

reg pulse_in_delay;
reg discharge_delay;
reg stop_condition1;
reg stop_condition2;
reg counter_en;
always@(posedge clk or posedge rst) begin
	if(rst) begin
		event_start <= 0;
        event_came <= 0;
		event_stop <= 0;
        stop_condition1 <= 0;
        stop_condition2 <= 0;
		data_reg <= 0;
		data_val <= 0;
		discharge_delay <= 0;
        pulse_in_delay <= 0;
        counter_en<= 0;
	end
	else begin
        discharge_delay <= discharge;
        pulse_in_delay <= pulse_in;

        stop_condition1 <= discharge_delay==1 && discharge==0;
        stop_condition2 <= pulse_in_delay==1 && pulse_in==0;

        counter_en <= event_came?pulse_in:discharge;


        if(event_start) begin
            if(~event_stop)begin
                if(counter_en) begin
                    data_reg<=data_reg+1;
                end
                if(pulse_in) begin
                    event_came <= 1;
                end

                event_stop <= event_came?stop_condition2:stop_condition1;
            end
            else begin
                if(~event_came) begin
                    data_reg <= 0;
                end
                data_val <= 1;
            end
        end
        else begin//  if(~event_start)
            if(discharge_delay==0 && discharge == 1) begin
                event_start <= 1;
            end
        end
        
	end
end


endmodule
