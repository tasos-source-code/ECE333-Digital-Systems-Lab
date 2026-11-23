`timescale 1ns/1ps
module uart_tb
  #(
    parameter integer MSG_BYTES = 22,
    parameter [8*MSG_BYTES-1:0] MSG = "POU EINAI O DELIVERAS?"
  );

    // Compute address width from number of bytes (minimum 1)
    function integer clog2; input integer value; integer n; begin
        clog2 = 0;
        value = value - 1;
        for (n = 0; value > 0; n = n + 1)
            value = value >> 1;
        clog2 = n;
    end endfunction

    localparam integer ADDR_WIDTH = (clog2(MSG_BYTES) > 0) ? clog2(MSG_BYTES) : 1;

    reg clk=1'b0, reset, Rx_EN;
    reg [2:0] baud_select;
    wire [7:0] Rx_DATA;
    reg Tx_WR, Tx_EN;
    wire Tx_BUSY;
    wire Rx_FERROR;
    wire Rx_PERROR;
    wire connect, Rx_VALID;
    reg [7:0] Tx_DATA;
    reg [ADDR_WIDTH-1:0] address = MSG_BYTES-1;

    reg [7:0] message [MSG_BYTES-1:0];
    reg [7:0] outputMessage [MSG_BYTES-1:0];

    integer i, k;
    initial begin
        // unpack the packed string MSG into the byte array message[]
        for (k = 0; k < MSG_BYTES; k = k + 1) begin
            message[k] = (MSG >> (8*k)) & 8'hFF;
            outputMessage[k] = 8'd32;
        end
    end

    uart_receiver dut(reset, clk, Rx_DATA, baud_select, Rx_EN, connect, Rx_FERROR, Rx_PERROR, Rx_VALID);
    uart_transmitter dut2(reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, connect, Tx_BUSY);

    initial  
        begin 

            clk = 1'b0;  
            reset = 1'b1; 
            baud_select = 3'b011;
            Tx_EN = 1'b0;
            Rx_EN = 1'b0;

            #5000
            reset = 1'b0;
            #5000
            Tx_EN = 1'b1; Rx_EN = 1'b1;
            #10000000
            for (i = MSG_BYTES-1; i >= 0; i = i-1) begin
                if(!Tx_BUSY)begin
                    Tx_DATA = message[i];
                    #1000;
                    Tx_WR=1'b1;
                    #2000000
                    Tx_WR=1'b0;
                    #2000000;
                end
            end
            $finish;
        end

    always@(Rx_VALID)begin
        
        if(Rx_VALID==1) begin
            outputMessage[address] = Rx_DATA;
            address = address - 1;
        end
    end

  // Clock is here
    always 
        #5 clk = ~clk;  // Clock generation 

    endmodule