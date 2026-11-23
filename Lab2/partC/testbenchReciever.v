`timescale 1ns/1ps
module receiver_tb;

    reg clk=1'b0, reset,Rx_EN;
    reg [2:0] baud_select;
    wire [7:0] Rx_DATA;
    reg RxD;
    wire Rx_FERROR;
    wire Rx_PERROR;
    wire Rx_VALID;
    reg [10:0] DATA;

    uart_receiver dut(reset, clk, Rx_DATA, baud_select, Rx_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);

    initial  
        begin 
            DATA={11'b00100000101}; // ASCII 'A'
            clk = 1'b0;  
            reset = 1'b1;
            RxD = 1'b1;
            baud_select = 3'b011;
            Rx_EN = 1'b0;

            #5000
            reset = 1'b0;
            #5000
            Rx_EN = 1'b1;
            #10000
            for(integer i=10; i>=0; i=i-1) begin
                #(6510*15);
                RxD = DATA[i];  
            end
            #(6510*16);

            RxD = 1'b1;
            #500000
            DATA={11'b00100001001}; // ASCII 'B'
            for(integer i=10; i>=0; i=i-1) begin
                #(6510*16);
                RxD = DATA[i];  
            end
            #(6510*16);
            RxD = 1'b1;
            
            $finish;
        end

  // Clock is here
    always 
        #5 clk = ~clk;  // Clock generation 

    endmodule