`timescale 1ns/1ps
`include "debouncer2.v"

`define ms 100000

module SyncDebounce_TB;
    reg clock;
    reg button;
    wire debounced;
    wire button_synced;

    button_synchronizer Sync_Inst
    (
        .clk(clock),
        .btn_async(button),
        .btn_sync(button_synced)
    );

    debouncer Debounce_Inst
    (
        .clk_slw(clock),
        .button_synced(button_synced),
        .debounced(debounced)
    );

    initial
    begin
        clock = 0;
    end

    always #10 clock = ~clock;

    initial begin
        
        button = 0;
        #(`ms*8);
        button=1;
        #(`ms*0.1);
        button = 0;
        #(`ms*0.1);
        button=1;
        #(`ms*0.3);
        button = 0;
        #(`ms*0.1);
        button=1;
        #(`ms*0.4);
        button = 0;
        #(`ms*0.1);
        button=1;
        #(`ms*0.3);
        button = 0;
        #(`ms*0.1);
        button=1; 
        #(`ms*5.1);
        
        button=0;
        #(`ms*0.1);
        button = 1;
        #(`ms*0.5);
        button=0;
        #(`ms*10);

        
        #100000 $finish;
    end 

    initial begin
        $dumpfile("tb_dumpfile.vcd");
        $dumpvars(0, SyncDebounce_TB);
    end

endmodule