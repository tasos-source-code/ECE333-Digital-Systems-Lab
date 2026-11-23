module uart_receiver(reset, clk, Rx_DATA, baud_select, Rx_EN, RxD, Rx_FERROR, Rx_PERROR, Rx_VALID);
    input reset, clk;
    input [2:0] baud_select;
    input Rx_EN;
    input RxD;
    output [7:0] Rx_DATA;
    output Rx_FERROR; // Framing Error //
    output Rx_PERROR; // Parity Error //
    output Rx_VALID; // Rx_DATA is Valid //
    wire Rx_sample_ENABLE, RxD_synchronized, counterrst, valid_flag, ferror_flag, perror_flag;
    wire [7:0] data;

    baud_controller baud_controller_rx_inst(reset, clk, baud_select, Rx_sample_ENABLE);

    synchronizer synchronizer_rx_inst(clk, RxD, RxD_synchronized);
    
    fsm_r fsm_rx_inst(clk, reset, Rx_sample_ENABLE, Rx_EN, RxD, counterrst, valid_flag, ferror_flag, perror_flag, data);

    output_control output_control_inst(clk, reset, counterrst, valid_flag, ferror_flag, perror_flag, data, Rx_PERROR, Rx_FERROR, Rx_VALID, Rx_DATA);

endmodule 