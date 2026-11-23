`timescale 1ns/1ps
module ledDriver_tb;

    reg clk=1'b0, reset;
    reg [2:0] baud_select; // 9600*16 baud
    wire sample_en;


    baud_controller dut(
        .reset(reset),
        .clk(clk),
        .baud_select(baud_select), // Set baud rate to 9600*16
        .sample_ENABLE(sample_en)
    );

    initial  
        begin 
            clk = 1'b0;  
            reset = 1'b1;  // Start with reset asserted
            #500 reset = 1'b0; // De-assert reset after 5 cycles

            #500
            baud_select = 3'b000; // 300*16 baud
            #500000
            baud_select = 3'b001; // 1200*16 baud   
            #50000
            baud_select = 3'b010; // 4800*16 baud
            #50000
            baud_select = 3'b011; // 9600*16 baud
            #50000
            baud_select = 3'b100; // 19200*16 baud
            #50000
            baud_select = 3'b101; // 38400*16 baud
            #50000
            baud_select = 3'b110; // 57600*16 baud
            #50000
            baud_select = 3'b111; // 115200*16 baud

            #50000 $finish; // End simulation after some time
        end

  // Clock is here
    always 
        #5 clk = ~clk;  // Clock generation 

    endmodule