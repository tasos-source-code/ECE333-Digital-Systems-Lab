module delay(clk,reset, Tx_sample_ENABLE, slow_enable);
    input clk, reset;
    input Tx_sample_ENABLE;
    output reg slow_enable;
    reg [3:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'd0;
            slow_enable <= 1'b0;
        end else begin
            slow_enable <= 1'b0;
            if (Tx_sample_ENABLE) begin
                if (counter == 4'd15) begin
                    counter <= 4'd0;
                    slow_enable <= 1'b1;
                end else begin
                    counter <= counter + 4'd1;
                end
            end
        end 
    end
endmodule

module maintainer(input wire clk, input wire rst_n, input wire tx_wr, input wire sample_enable, output reg tx_wr_sync);
    reg pending_wr;     // latch that remembers tx_wr

    always @(posedge clk or posedge rst_n) begin
        if (rst_n) begin
            pending_wr <= 1'b0;
            tx_wr_sync  <= 1'b0;
        end
        else begin
            // default: no write
            tx_wr_sync <= 1'b0;

            // latch any incoming tx_wr pulse
            if (tx_wr)
                pending_wr <= 1'b1;

            // when sampling moment arrives, output a pulse
            if (sample_enable && pending_wr) begin
                tx_wr_sync  <= 1'b1;   // one-cycle sync pulse
                pending_wr  <= 1'b0;   // clear latch
            end
        end
    end

endmodule