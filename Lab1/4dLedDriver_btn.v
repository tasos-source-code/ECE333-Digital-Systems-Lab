// `include "1A.v"
// `include "1B.v"
// `include "message_counter.v"
`timescale 1ns/1ps

module FourDigitLEDdriver(reset, clk, btn1, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);
    input clk, reset, btn1;
    output wire an3, an2, an1, an0;
    output wire a, b, c, d, e, f, g, dp;
    wire [15:0] display_num; // 4 BCD digits to display
    wire [3:0] char,state;
    wire [6:0] LED;
    wire clk_fb,LOCKED;
    wire [3:0] message_index;
    wire CLOCK1, btn1_synced,debounced_btn1;

   // MMCME2_BASE: Base Mixed Mode Clock Manager
   //              Artix-7
   // Xilinx HDL Language Template, version 2018.3


    MMCME2_BASE #(
        .BANDWIDTH("OPTIMIZED"),
        .CLKFBOUT_MULT_F(12.0),  //vco=100Mhz*12=1200Mhz
        .CLKFBOUT_PHASE(0.0),
        .CLKIN1_PERIOD(10.000),
        .CLKOUT1_DIVIDE(120), //1200/120=10Mhz
        .CLKOUT1_DUTY_CYCLE(0.5),
        .CLKOUT1_PHASE(0.0),
        .DIVCLK_DIVIDE(2), //10/2=5Mhz
        .REF_JITTER1(0.0),
        .STARTUP_WAIT("FALSE")
    )
    MMCME2_BASE_inst (
        .CLKOUT1(CLOCK1),
        .CLKFBOUT(clk_fb),
        .LOCKED(LOCKED),
        .CLKIN1(clk),
        .PWRDWN(1'b0),//always enabled
        .RST(reset),
        .CLKFBIN(clk_fb)
    );

    button_synchronizer btn_sync_inst(CLOCK1,btn1, btn1_synced);
    debouncer debouncer_inst(CLOCK1, reset, btn1_synced, debounced_btn1);

   //LED
    LEDdecoder LEDdecoder_inst(char,LED);

    //counter
    counter counter_inst(CLOCK1,reset,LOCKED,state);
    //anode controller
    anode_cntrl anode_cntrl_inst(state,reset,an3,an2,an1,an0);

    //moving message
    msg_counter msg_counter_inst(CLOCK1, debounced_btn1, reset, message_index);
    //memory
    memory memory_inst(CLOCK1, reset, message_index, display_num);

    //cathode and output controller
    output_cntrl output_cntrl_inst(state,display_num,char);

    assign dp = 1'b1;
    assign {a,b,c,d,e,f,g} = LED;

    //initialize message
    



endmodule