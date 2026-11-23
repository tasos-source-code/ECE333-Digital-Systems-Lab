//`include "4dLedDriver_btn.v"
`timescale 1ns/1ps
// `define clock_period 10
module ledDriver_tb;

    reg clk=1'b0, reset;
    wire an3, an2, an1, an0;
    wire a, b, c, d, e, f, g, dp;
    reg btn1;

    FourDigitLEDdriver dut(reset, clk, btn1, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);

    initial  
        begin 
            clk = 1'b0;       
            reset = 1'b1;  // Start with reset asserted
            #500 reset = 1'b0; // De-assert reset after 5 cycles
            btn1 = 1'b0;
            

            #1000 reset = 1'b1;  // Start with reset asserted
            #15 reset = 1'b0;
            for(integer i=0;i<100;i=i+1) begin
                // --- Simulate button press with many bounces ---
                btn1 = 1; #100;    // initial press
                btn1 = 0; #50;     // bounce
                btn1 = 1; #80;     // bounce
                btn1 = 0; #60;     // bounce
                btn1 = 1; #120;    // bounce
                btn1 = 0; #90;     // bounce
                btn1 = 1; #150;    // bounce
                btn1 = 0; #70;     // bounce
                btn1 = 1; #100;    // bounce
                btn1 = 0; #50;     // bounce
                btn1 = 1; #100_0000; // stable press for 100 µs

                // --- Simulate button release with many bounces ---
                btn1 = 0; #100;
                btn1 = 1; #50;
                btn1 = 0; #80;
                btn1 = 1; #600;
                btn1 = 0; #1200;
                btn1 = 1; #900;
                btn1 = 0; #1500;
                btn1 = 1; #700;
                btn1 = 0; #1000;
                btn1 = 1; #50;
                btn1 = 0; #100_0000; // stable release
            end
        end

  // Clock is here
    always 
        #5 clk = ~clk;  // Clock generation 

    initial begin
        #5000000 $finish;
    end
endmodule