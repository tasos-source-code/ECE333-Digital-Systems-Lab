
module debounce_trigger(input pb_1,slow_clk,output pb_out);
    wire slow_clk;//5MHz
    wire Q1,Q2,Q2_bar,Q0;

    my_dff d0(slow_clk, pb_1,Q0 );

    my_dff d1(slow_clk, Q0,Q1 );
    my_dff d2(slow_clk, Q1,Q2 );
    assign Q2_bar = ~Q2;
    assign pb_out = Q1 & Q2_bar;
endmodule

// D-flip-flop for debouncing module 
module my_dff(DFF_CLOCK, D, Q);
    input DFF_CLOCK, D;
    output reg Q;

    always @ (posedge DFF_CLOCK) begin
        Q <= D;
    end

endmodule 