module enable_delay(clk,reset, Tx_sample_ENABLE, slow_enable);
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
