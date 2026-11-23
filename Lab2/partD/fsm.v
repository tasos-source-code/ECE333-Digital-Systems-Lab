module fsm_t(clk, reset, Tx_sample_ENABLE,Tx_EN, Tx_WR, Tx_DATA, Tx_BUSY,TxD);
    input clk, reset, Tx_EN, Tx_WR, Tx_sample_ENABLE;
    input [7:0] Tx_DATA;
    output reg Tx_BUSY;
    output reg TxD;
    reg addressEn, addressReset;
    reg [3:0] address;
    reg [2:0]state, next_state;

    parameter OFF = 3'd0; // READY state
    parameter READY = 3'd1; // READY state
    parameter START = 3'd2; // START state
    parameter DATA = 3'd3; // DATA state
    parameter PARITY = 3'd4; // PARITY state
    parameter ENDING = 3'd5; // ENDING state

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= OFF;
        end else 
            state <= next_state;
    end

    always@(*)begin
        Tx_BUSY = 1'b0;
        TxD = 1'b1;
        addressEn= 1'b0;
        addressReset = 1'b0;
        case(state)
           OFF: begin
                Tx_BUSY = 1'b0;
                if (Tx_EN && Tx_WR)
                    next_state = READY;
                else
                    next_state = OFF;
            end
            READY: begin
                Tx_BUSY      = 1'b0;
                addressReset = 1'b1;   // keep address at 0 in READY

                if (!Tx_EN)
                    next_state = OFF;
                else if (Tx_sample_ENABLE)       
                    next_state = START;
                else
                    next_state = READY;
            end
            START: begin // START state
                Tx_BUSY = 1'b1;
                TxD = 1'b0;
                addressReset = 1'b1;
                if (Tx_sample_ENABLE)
                    next_state = DATA;
                else
                    next_state = START;
            end
            DATA: begin
                Tx_BUSY = 1'b1;
                TxD     = Tx_DATA[address];
                if (Tx_sample_ENABLE) begin
                    addressEn = 1'b1;
                    if (address == 4'd7)
                        next_state = PARITY;
                    else
                        next_state = DATA;
                end else
                    next_state = DATA;
            end
            PARITY: begin
                Tx_BUSY = 1'b1;
                TxD     = ^Tx_DATA;
                if (Tx_sample_ENABLE) 
                    next_state = ENDING;
                else
                    next_state = PARITY;
            end
            ENDING: begin // ENDING state
                Tx_BUSY = 1'b1;
                TxD = 1'b1; // Stop bit
                if (Tx_sample_ENABLE)
                    next_state = OFF; // Move to READY state
                else
                    next_state = ENDING;
            end
            default: begin
                next_state = OFF; // Default to READY state
                Tx_BUSY = 1'b0;
            end
        endcase
    end

always @(posedge clk or posedge reset) begin
    if (reset)
        address <= 4'd0;
    else if (addressReset)
        address <= 4'd0;
    else if (Tx_sample_ENABLE && addressEn)
        address <= address + 4'd1;
    end
endmodule