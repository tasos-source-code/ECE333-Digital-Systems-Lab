`timescale 1ns/1ps
module ledDriver_tb;

    reg clk=1'b0, reset,Tx_EN, Tx_WR;
    reg [2:0] baud_select;
    reg [7:0] Tx_DATA;
    wire TxD;
    wire Tx_BUSY;


    uart_transmitter dut(reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY);

    initial  
        begin 
            clk = 1'b0;  
            reset = 1'b1; 
            baud_select = 3'b001;
            Tx_EN = 1'b0;
            Tx_WR = 1'b0;

            #5000
            reset = 1'b0;
            #5000
            Tx_EN = 1'b1;
            Tx_DATA = 8'd65;
            #80000
            Tx_WR = 1'b1;
            #80000
            Tx_WR = 1'b0;

            #1000
            #2000000
            Tx_DATA = 8'd66;
            #80000
            Tx_WR = 1'b1;
            #80000
            Tx_WR = 1'b0;
            #200000
            Tx_WR = 1'b1;
            #15004000
            Tx_WR = 1'b0;
            #50000000
            Tx_WR = 1'b1;
            #1500400
            Tx_WR = 1'b0;
            $finish;
        end

  // Clock is here
    always 
        #5 clk = ~clk;  // Clock generation 

    endmodule