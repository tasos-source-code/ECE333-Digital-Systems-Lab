module uart_transmitter(reset, clk, Tx_DATA, baud_select, Tx_WR, Tx_EN, TxD, Tx_BUSY);
    input reset, clk;
    input [7:0] Tx_DATA;
    input [2:0] baud_select;
    input Tx_EN;
    input Tx_WR;
    output Tx_BUSY, TxD;
    wire Tx_sample_ENABLE,ENABLE,Tx_WR_synced,Tx_WR_debounced;

    baud_controller baud_controller_tx_inst(reset, clk, baud_select, Tx_sample_ENABLE);

    delay delay_inst(clk, reset, Tx_sample_ENABLE, ENABLE);

    //synchronizer synchronized(clk, Tx_WR, Tx_WR_synced);

    //debouncer debouncer(clk, reset, Tx_WR_synced, Tx_WR_debounced);

    fsm_t fsm_tx_inst(clk, reset, ENABLE ,Tx_EN, Tx_WR, Tx_DATA, Tx_BUSY, TxD);

endmodule