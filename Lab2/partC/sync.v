module synchronizer (input wire clk, input wire btn_async, output wire btn_sync);
    reg ff1, ff2;

    always @(posedge clk) begin
        ff1 <= btn_async;  // flip-flop
        ff2 <= ff1;        // flip-flop
    end

    assign btn_sync = ff2;
endmodule
