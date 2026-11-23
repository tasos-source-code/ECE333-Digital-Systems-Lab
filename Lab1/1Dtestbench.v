//`include "4dLedDriver_btn.v"
`timescale 1ns/1ps
// `define clock_period 10
module ledDriver_tb;

    reg clk=1'b0, reset;
    wire an3, an2, an1, an0;
    wire a, b, c, d, e, f, g, dp;

    FourDigitLEDdriver dut(reset, clk, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);

    initial  
        begin 
            clk = 1'b0;       
            reset = 1'b1;  // Start with reset asserted
            #500 reset = 1'b0; // De-assert reset after 5 cycles            

            #1000 reset = 1'b1;  // Start with reset asserted
            #15 reset = 1'b0;
            
        end

  // Clock is here
    always 
        #5 clk = ~clk;  // Clock generation 

    initial begin
        #5000000 $finish;
    end
endmodule