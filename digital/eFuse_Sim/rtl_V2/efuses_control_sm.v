/******************************************************************************
    Example of TSMC 65nm control State machine          
    (extracted from SSA ASIC - CMS OT PS-Module         
    
    This is just an example of control state machine and it is provided AS IS. 
    Developer makes no other warranties, express or implied, and hereby 
    disclaims all implied warranties, including any warranty of 
    merchantability and warranty of fitness for a particular purpose.
 ******************************************************************************/
 `timescale 1ns/1ps
module efuses_control_sm(
    input clk,							// 40 MHz 
    input rst,							// system reset
    input start,						// Progarmming start signal
    input [1:0] mode,					// program mode or read mode selection
	input [3:0] TCKHP,					// SCLK high period, default value is 4
    input [31:0] prog,					// 32-bit program data
	output reg sw_en,					// power switch EN signal
	output reg sw_rampena,				// power switch RAMPENA signal
	output reg sw_short,				// power switch SHORT signal
    output reg CSB,						// efuse chip select, low active
	output reg PGM,						// efuse program signal
	output reg SCLK						// efuse serial clock
    );

    // tmrg default do_not_triplicate

    localparam [4:0] IDLE      = 5'b00000;
	localparam [4:0] PWR_OPEN  = 5'b00001;
	localparam [4:0] PWR_EN    = 5'b00010;
	localparam [4:0] PWR_RPENA = 5'b00011;
    localparam [4:0] CHECK_WR  = 5'b00100;
    localparam [4:0] START_WR  = 5'b00101;
    localparam [4:0] PGM_ST    = 5'b00110;
    localparam [4:0] SCLK_WR   = 5'b00111;
    localparam [4:0] PGM_END   = 5'b01000;
	localparam [4:0] SCLK_DOWN = 5'b01001;
    localparam [4:0] CSB_UP    = 5'b01010;
	localparam [4:0] PWR_RPDIS = 5'b01011;
	localparam [4:0] PWR_DIS   = 5'b01100;
	localparam [4:0] PWR_SHORT = 5'b01101;
    localparam [4:0] CHECK_RD  = 5'b01110;
    localparam [4:0] SCLK_UP   = 5'b01111;
    localparam [4:0] READ      = 5'b10000;
    localparam [4:0] READ_END  = 5'b10001;

    reg [2:0] start_cnt;
    reg [3:0] pgm_cnt;
	reg [2:0] pwr_cnt;
    reg [5:0] bit_cnt;

    wire write;
    wire read;

    reg [4:0] state, next;

    assign write = ((mode == 2'b01) && start)?1'b1: 1'b0;
    assign read = ((mode == 2'b10))?1'b1: 1'b0;

    always @(posedge clk or negedge rst)
        if (!rst) state <= #2  IDLE;
        else state <= #2  next;

    always     @* begin
        case (state)
            IDLE:       if (write)                  next = PWR_OPEN;
                        else if (read)              next = CHECK_RD;
                        else                        next = IDLE;

			PWR_OPEN:	if(!write)					next = IDLE;
						else if(pwr_cnt <= 3'd2)	next = PWR_OPEN;
						else 						next = PWR_EN;

			PWR_EN:		if(pwr_cnt <= 3'd4)			next = PWR_EN;
						else						next = PWR_RPENA;

			PWR_RPENA:	if(pwr_cnt <= 3'd6)			next = PWR_RPENA;
						else						next = CHECK_WR;

            CHECK_WR:   if (start_cnt < 3'd7)  		next = CHECK_WR;
                        else if (start_cnt == 7)    next = START_WR;
                        else                        next = IDLE;

            START_WR:                               next = PGM_ST;

            PGM_ST:                                 next = SCLK_WR;

            SCLK_WR:    if (pgm_cnt == 4'd0)        next = PGM_END;
                        else                        next = SCLK_WR;

            PGM_END:    if (bit_cnt == 6'd32)       next = SCLK_DOWN;
                        else                        next = PGM_ST;
			
			SCLK_DOWN: 	if (pwr_cnt == 3'd7)		next = CSB_UP;
						else						next = SCLK_DOWN;			
	
			CSB_UP: 	if (pwr_cnt == 3'd0)		next = PWR_RPDIS;
						else						next = CSB_UP;

			PWR_RPDIS:	if (pwr_cnt <= 3'd2)		next = PWR_RPDIS;
						else						next = PWR_DIS;
			
			PWR_DIS:	if (pwr_cnt <= 3'd4)		next = PWR_DIS;
						else						next = PWR_SHORT;
			
			PWR_SHORT:	if (pwr_cnt <= 3'd6)		next = PWR_SHORT;
						else 						next = IDLE;

            CHECK_RD:   if (!read)                  next = IDLE;
                        else if (start_cnt < 3'd7)  next = CHECK_RD;
                        else if (start_cnt == 3'd7) next = SCLK_UP;
                        else                        next = IDLE;

			SCLK_UP:	if (pwr_cnt == 3'd0)		next = READ;
						else						next = SCLK_UP;		

            READ:       if (!read)                  next = READ_END;
                        else                        next = READ;

            READ_END:                               next = IDLE;

            default:                                next = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst)
        if (!rst) begin
            CSB <= #2  1'b1;
            SCLK <= #2  1'b0;
            PGM <= #2  1'b0;
			sw_en <= #2 1'b0;
			sw_rampena <= #2 1'b0;
			sw_short <= #2 1'b1;
            start_cnt <= #2 3'd0;
            pgm_cnt <= #2 (4'd5 + TCKHP);			// 3 us + 0.5 us * TCKHP
			pwr_cnt <= #2 3'd0;
            bit_cnt <= #2 6'd0;
        end else begin
            case(next)
                IDLE:   begin
                            CSB <= #2  1'b1;
                            SCLK <= #2  1'b0;
                            PGM <= #2  1'b1;
							pwr_cnt <= #2 3'd0;                            
							start_cnt <= #2  3'd0;
                        end
				PWR_OPEN: begin
							sw_short <= #2 1'b0;
							pwr_cnt <= #2 pwr_cnt + 1'b1;
						end
				PWR_EN:	begin
							sw_en <= #2 1'b1;
							pwr_cnt <= #2 pwr_cnt + 1'b1;
						end
				PWR_RPENA: begin
							sw_rampena <= #2 1'b1;
							pwr_cnt <= #2 pwr_cnt + 1'b1;
						end
                CHECK_WR: begin
                            CSB <= #2  1'b0;
                            bit_cnt <= #2  6'd0;
                            SCLK <= #2  1'b0;
                            PGM <= #2  1'b1;
							pwr_cnt <= #2 4'd0;		///??
                            start_cnt <= #2  start_cnt + 3'd1;
                        end
                START_WR: begin
                            CSB <= #2  1'b0;
                            SCLK <= #2  1'b0;
                            PGM <= #2  1'b0;
                        end
                PGM_ST: begin
                            PGM  <= #2  prog[bit_cnt];
                            SCLK <= #2  1'b0;
                            CSB <= #2  1'b0;
                            pgm_cnt <= #2  (4'd5 + TCKHP);
                        end
                SCLK_WR: begin
                            SCLK <= #2  1'b1;
                            pgm_cnt <= #2  pgm_cnt - 4'd1;
                        end
                PGM_END: begin
                            SCLK <= #2  1'b1;
                            pgm_cnt <= #2  4'd0;
                            PGM <= #2  1'b0;
                            bit_cnt <= #2  bit_cnt + 6'd1;
                        end
				SCLK_DOWN: begin
							SCLK <= #2  1'b0;
							pwr_cnt <= #2 pwr_cnt + 1'b1;
						end
				CSB_UP: begin
							CSB <= #2  1'b1;
							pwr_cnt <= #2 pwr_cnt - 1'b1;
						end
				PWR_RPDIS: begin
							sw_rampena <= #2 1'b0;
							pwr_cnt <= #2 pwr_cnt + 1'b1;
						end

				PWR_DIS: begin
							sw_en <= #2 1'b0;
							pwr_cnt <= #2 pwr_cnt + 1'b1;
						end

				PWR_SHORT: begin
							sw_short <= #2 1'b1;
							pwr_cnt <= #2 pwr_cnt + 1'b1;
						end
                CHECK_RD: begin
                            PGM <= #2  1'b0;
                            start_cnt <= #2  start_cnt + 3'd1;
                        end
				SCLK_UP: begin
							SCLK <= #2  1'b1;
							pwr_cnt <= #2 pwr_cnt - 1'b1;
						end
                READ: begin
                            //SCLK <= #2  1'b1;
                            CSB <= #2  1'b0;
                            PGM <= #2  1'b0;
                        end
                READ_END: begin
                            SCLK <= #2  1'b0;
                            CSB <= #2  1'b0;
                            PGM <= #2  1'b0;
                        end
            endcase
        end
endmodule
