//`include "4dLedDriver.v"
`timescale 1ns/1ps
// `define clock_period 10
module ledDriver_tb;

    reg clk=1'b0, reset;
    wire an3, an2, an1, an0;
    wire a, b, c, d, e, f, g, dp;
    reg [15:0] display_num;

    FourDigitLEDdriver dut(reset, clk, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);

    initial  
        begin 
            clk = 1'b0;       
            reset = 1'b1;  // Start with reset asserted
            #500 reset = 1'b0; // De-assert reset after 5 cycles

            //display_num = 16'h4321; 

            #1000 reset = 1'b1;  // Start with reset asserted
            #15 reset = 1'b0;
            //#10000 display_num = 16'h5678; 
        end

  // Clock is here
    always 
        #5 clk = ~clk;  // Clock generation 

    initial begin
        #50000 $finish;
    end

    always@(posedge clk) begin
        $display("Test Start: display_num = %h", display_num);
        $display("ANodes: %b", {an3, an2, an1, an0});
        $display("Segments: %b", {a, b, c, d, e, f, g, dp});
    end
endmodule