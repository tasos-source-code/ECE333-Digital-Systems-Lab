
module debouncer (input  wire clk_slw, input  wire button_synced, output reg  debounced);
    localparam integer STABLE_COUNT_MAX = 25000; // 5ms / 5MHz

    // reg button_sync_0, button_synced;
    reg [14:0] counter; // 2^15 > 25000
    reg stable_state=0;

    always @(posedge clk_slw) begin
        if (button_synced != stable_state) begin
            counter <= counter + 1;
            if (counter >= STABLE_COUNT_MAX) begin
                stable_state <= button_synced;
                counter <= 0;
            end
        end else begin
            counter <= 0;
        end
    end

    always @(posedge clk_slw)
        debounced <= stable_state;
endmodule