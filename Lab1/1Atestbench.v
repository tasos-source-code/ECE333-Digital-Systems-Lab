`include "1A.v"
//`timescale 1ms/1ps

module LEDdecoder_tb;
    reg [3:0] char;
    wire [6:0] LED;

    LEDdecoder dut(char,LED);

    initial begin
        // // Test all inputs
        for (char = 4'h0; char < 4'hF; char = char + 1) begin
            #1; // Wait for 1 ms
            $display("input char: %h -> output LED: %b", char, LED);
            // for (integer i=0; i < 7; i = i+1) begin
            //     if(LED[6-i] == 1)
            //         $display("C%c is ON", "A"+i);
            //     else
            //         $display("C%c is OFF", "A"+i);
            // end
        end
        $display("input char: %h -> output LED: %b", 4'hF, LED);
        #1 $finish;
    end

    
endmodule
`include "1B.v"