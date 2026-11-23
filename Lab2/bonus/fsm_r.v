//module fsm_r (clk, reset, Rx_sample_ENABLE, Rx_EN, RxD, Rx_DATA, Rx_FERROR, Rx_PERROR, Rx_VALID);
module fsm_r (clk, reset, Rx_sample_ENABLE, Rx_EN, RxD, counterrst, valid_flag, ferror_flag, perror_flag, Rx_DATA);

    input clk, reset, Rx_EN, Rx_sample_ENABLE, RxD;
    output reg [7:0] Rx_DATA;
    // output reg Rx_FERROR; // Framing Error //
    // output reg Rx_PERROR; // Parity Error //
    // output reg Rx_VALID; // Rx_DATA is Valid // 

    output reg valid_flag, ferror_flag, perror_flag, counterrst;
    reg addressReset, addressEn, out;
    reg [2:0] address;
    reg [3:0] counter;
    reg s0, s1, s2, s3;
    reg valid;

    // State encoding
    reg [2:0] state, next_state;    
    parameter OFF = 3'd0;
    parameter START = 3'd1;
    parameter DATA = 3'd2;  
    parameter PARITY = 3'd3;
    parameter STOP = 3'd4;    

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= OFF;
        else 
            state <= next_state;
    end

    wire bit_done = (counter == 4'd15) && Rx_sample_ENABLE;

    always @(*) begin
        // Default outputs
        valid_flag   = 1'b0;
        ferror_flag  = 1'b0;
        perror_flag  = 1'b0;

        addressEn    = 1'b0;
        addressReset = 1'b0;
        counterrst   = 1'b0;
        next_state   = state;

        case (state)
            OFF: begin
                addressReset = 1'b1;   // keep address at 0
                if (Rx_EN && RxD == 1'b0) begin
                    counterrst = 1'b1; // restart sampler
                    next_state = START;
                end 
            end

            START: begin
                addressReset = 1'b1;  
                if (bit_done) begin
                    if (!valid) begin
                        ferror_flag = 1'b1;
                        next_state = OFF;
                    end
                    else if(out == 1'b0)
                        next_state = DATA;
                    else
                        next_state = START;
                end 
            end

            DATA: begin
                addressEn = 1'b1;
                if (bit_done) begin
                    if(!valid) begin
                        ferror_flag = 1'b1;
                        next_state = OFF;
                    end
                    else if (address == 3'd7)
                        next_state = PARITY;
                    else
                        next_state = DATA;
                end 
            end

            PARITY: begin
                if (bit_done) begin
                    if (!valid || (out != ^Rx_DATA))
                        perror_flag = 1'b1;
                    next_state = STOP;
                end 
            end

            STOP: begin
                if (bit_done) begin
                    if (!valid || out != 1'b1)
                        ferror_flag = 1'b1;
                    else
                        valid_flag = 1'b1;
                    next_state = OFF;
                end
            end
            default: next_state = OFF;
        endcase
    end

    //counter for address 
    always @(posedge clk or posedge reset) begin
        if (reset)
            address <= 3'd0;
        else if (addressReset)
            address <= 3'd0;
        else if (Rx_sample_ENABLE && addressEn && counter==4'd15)
            address <= address + 3'd1;
    end

    //sampling 4 of 16 bits
    always @(posedge clk or posedge reset) begin
        if (reset || counterrst) begin
            counter   <= 4'd0;
            out   <= 1'b1;
            valid <= 1'b1;
            s0    <= 1'b1;
            s1    <= 1'b1;  
            s2    <= 1'b1;
            s3    <= 1'b1;
        end else if (Rx_sample_ENABLE) begin
            case (counter)
                4'd5: begin
                    s0  <= RxD;
                    counter <= 4'd6;
                end
                4'd7: begin
                    s1  <= RxD;
                    counter <= 4'd8;
                end
                4'd8: begin
                    s2  <= RxD;
                    counter <= 4'd9;
                end
                4'd10: begin
                    s3  <= RxD;
                    counter <= 4'd11;
                end
                4'd15: begin
                    if ( (s0 & s1 & s2 & s3) || (~s0 & ~s1 & ~s2 & ~s3) ) begin
                        out   <= s1;
                        valid <= 1'b1;
                    end else begin
                        valid <= 1'b0;
                    end
                    counter <= 4'd0;
                end
                default: begin
                    counter <= counter + 4'd1;
                end
            endcase
        end 
    end

    //counter for bits 
    always @(posedge clk or posedge reset) begin
        if (reset)
            Rx_DATA <= 8'd0;
        else if (counterrst)
            Rx_DATA <= 8'd0;    
        else if (bit_done && addressEn)
            Rx_DATA[address] <= out;
    end
    
endmodule

