`timescale 1ns / 1ps
`include "debouncer.v"
// testbench verilog code for debouncing button without creating another clock
module tb_button;
 // Inputs
    reg pb_1;
    reg clk;
    // Outputs
    wire pb_out;
    // Instantiate the debouncing Verilog code

    debounce_trigger uut (
        .pb_1(pb_1), 
        .slow_clk(clk), 
        .pb_out(pb_out)
    );
    initial begin
        clk = 0;
        forever #200 clk = ~clk;
    end
    initial begin
        
        pb_1 = 0;
        #500;
        #150
        #10;
        pb_1=1;
        #20;
        pb_1 = 0;
        #10;
        pb_1=1;
        #30; 
        pb_1 = 0;
        #10;
        pb_1=1;
        #40;
        pb_1 = 0;
        #10;
        pb_1=1;
        #30; 
        pb_1 = 0;
        #10;
        pb_1=1; 
        #500; 
        
        pb_1=0;
        #100;
        pb_1=1;
        #500;

        pb_1 = 0;
        #10;
        pb_1=1;
        #20;
        pb_1 = 0;
        #10;
        pb_1=1;
        #30; 
        pb_1 = 0;
        #10;
        pb_1=1;
        #40;
        pb_1 = 0; 

        #1000 $finish;
    end 
    
    initial begin
        $dumpfile("tb_dumpfile.vcd");
        $dumpvars(0, tb_button);
    end
endmodule