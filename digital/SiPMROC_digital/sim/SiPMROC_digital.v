`timescale 1ns/1ps
module SiPMROC_digital(
    input clk_200m,

    input rst,

    input [16:0] channel_energy_pulses,				//connect to trigger signal
    input [16:0] discharge,							//connect to discharge signal

    output serial_data_en,
    output serial_data
);

parameter ADC_WIDTH = 10;
parameter ADC_CHANNEL_NUM = 17;
parameter TOTAL_DATA_WIDTH = ADC_WIDTH * ADC_CHANNEL_NUM;

//=====================================//
//            Pulse Measurement
//=====================================//
reg [ADC_CHANNEL_NUM-1:0] channel_valid;
reg all_valid;
reg rst_event;
wire [ADC_WIDTH-1:0] data_array [ADC_CHANNEL_NUM-1:0];
wire data_en_array [ADC_CHANNEL_NUM-1:0];

wire [ADC_CHANNEL_NUM-1:0] input_pulses = {channel_energy_pulses};

genvar i;

generate
    for(i=0; i<ADC_CHANNEL_NUM; i=i+1) begin
    pulse_measurement pulse_measurement_inst(
        .clk(clk_200m),//input         clk,
        .rst(rst_event|rst),//input         rst,
        //              
        .discharge(discharge[i]),//input         trigger,
        //              
        .pulse_in(input_pulses[i]),//input         pulse,
        //  
        .data(data_array[i]), //output [9:0]  data,
        .data_val(data_en_array[i])//output        data_en
    );
    end
endgenerate

//=====================================//
//       Data Arrival Management
//=====================================//

wire event_data_en;

integer j;
reg all_valid_delay;
reg [ADC_WIDTH-1:0] reg_data_array [ADC_CHANNEL_NUM-1:0];
always@(posedge clk_200m or posedge rst) begin
    if(rst) begin
        channel_valid <= 1'b0;
        rst_event <= 1'b0;
		all_valid <= 1'b0;
		all_valid_delay <= 1'b0;
    end
    else begin
        if(all_valid) begin
            channel_valid <= 1'b0;
            all_valid <= 1'b0;
            rst_event <= 1'b1;
        end
        else begin
            rst_event <= 1'b0;
            all_valid <= &channel_valid;
            all_valid_delay <= all_valid;
            for(j=0;j<ADC_CHANNEL_NUM;j=j+1) begin				// need to double check
                if(data_en_array[j]) begin
                    channel_valid[j] <= 1'b1;
                    reg_data_array[j] <= data_array[j];
                end
            end
        end
    end
end 

assign event_data_en = all_valid & ~all_valid_delay;
wire [TOTAL_DATA_WIDTH-1:0] event_data;
genvar k;
generate
    for(k=0; k<ADC_CHANNEL_NUM; k=k+1) begin
        assign event_data[ADC_WIDTH*(k+1)-1:ADC_WIDTH*k] = reg_data_array[k];
    end
endgenerate



//=====================================//
//SERIAL OUTPUT (930ns can read out all the serial data)
//=====================================//
parameter HEADER_ENDER_WIDTH = 8;
parameter SERIAL_OUTPUTWIDTH = TOTAL_DATA_WIDTH+HEADER_ENDER_WIDTH*2;
reg [SERIAL_OUTPUTWIDTH-1:0] buffer_data;
reg p2s_begin;
reg [8:0] serial_shft_cnt;
always@(posedge clk_200m or posedge rst) begin
    if(rst) begin
        p2s_begin <= 1'b0;
        buffer_data[0] <= 1'b0;
		serial_shft_cnt <= 9'b1;
    end
    else begin
        if(~p2s_begin)begin
            buffer_data[0] <= 1'b0;
            if(event_data_en) begin
                buffer_data <= {{4{2'b10}},event_data,{4{2'b01}}};
                serial_shft_cnt <= 9'b1;
                p2s_begin <= 1'b1;
            end
        end
        else begin
            if(serial_shft_cnt<SERIAL_OUTPUTWIDTH) begin
                serial_shft_cnt <= serial_shft_cnt + 1'b1;
                buffer_data[SERIAL_OUTPUTWIDTH-2:0] <= buffer_data[SERIAL_OUTPUTWIDTH-1:1];
            end
            else begin
                p2s_begin <= 1'b0;
                serial_shft_cnt <= 1'b0;
                buffer_data[0] <= 1'b0;
            end
        end
    end
end

assign serial_data_en = p2s_begin;
assign serial_data = buffer_data[0];

endmodule
