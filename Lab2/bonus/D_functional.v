module demo(reset, clk, baud_select, Tx_WR, enable, an3, an2, an1, an0, a, b, c, d, e, f, g, dp, ERROR);
    input reset,clk,enable,Tx_WR;
    input [2:0]baud_select;
    wire connection,send_sync,send;
    wire Tx_BUSY,Rx_FERROR,Rx_PERROR,Rx_VALID;
    output an3, an2, an1, an0, a, b, c, d, e, f, g, dp;
    output ERROR;
    wire [7:0] Tx_DATA,Rx_DATA;
    wire [3:0] Rx_address;
    wire [3:0] Tx_address;
    wire vld;

    synchronizer synchronizer_inst(clk,Tx_WR,send_sync);
    debouncer debouncer_inst(clk,reset,send_sync,send);
    debouncer debouncer_inst2(clk,reset,Rx_VALID,vld);

    uart_transmitter trans_inst(reset, clk, Tx_DATA, baud_select, send, enable, connection, Tx_BUSY);

    ROM rom_inst(clk, reset, 1'b1, Tx_address,Tx_DATA);

    uart_receiver rcvr_inst(reset, clk, Rx_DATA, baud_select, enable, connection, Rx_FERROR, Rx_PERROR, Rx_VALID);

    FourDigitLEDdriver led_inst(reset, clk, vld, Rx_DATA, Rx_address, an3, an2, an1, an0, a, b, c, d, e, f, g);

    uart_handler uart_handler_inst(clk,reset,Tx_address,send,Tx_BUSY,Rx_address,vld,ERROR,Rx_FERROR,Rx_PERROR,dp);


endmodule