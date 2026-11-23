`timescale 1ns/1ps
module receiver_tb;

    reg clk=1'b0, reset, enable, Tx_WR;
    reg [2:0] baud_select;
    wire ERROR;

    demo dut(reset, clk, baud_select, Tx_WR, enable, an3, an2, an1, an0, a, b, c, d, e, f, g, dp, ERROR);

    initial  
        begin 
            clk = 1'b0;  
            reset = 1'b1;
            baud_select = 3'b011;
            enable = 1'b1;
            Tx_WR = 1'b0;

            #5000
            reset = 1'b0;
            // #80000
            // Tx_WR = 1'b1;
            // #80000
            // Tx_WR = 1'b0;
            // #200000
            // Tx_WR = 1'b1;
            // #15004000
            // Tx_WR = 1'b0;
            // #50000000
            // Tx_WR = 1'b1;
            // #1500400
            // Tx_WR = 1'b0;
            for(integer i=0; i<32; i=i+1)begin
                #700000
                Tx_WR=~Tx_WR;
            end
            $finish;
        end

  // Clock is here
    always begin
        #5 clk = ~clk;  // Clock generation 
    end

    endmodule