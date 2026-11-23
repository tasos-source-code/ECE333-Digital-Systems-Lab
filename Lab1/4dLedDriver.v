//`include "1A.v"
//`include "1B.v"
`timescale 1ns/1ps

module FourDigitLEDdriver(reset, clk, an3, an2, an1, an0, a, b, c, d, e, f, g, dp);
    input clk, reset;
    output wire an3, an2, an1, an0;
    output wire a, b, c, d, e, f, g, dp;
    wire [15:0] display_num={4'h1,4'h2,4'h3,4'h4}; // 4 BCD digits to display
    wire [3:0] char,state;
    wire [6:0] LED;
    wire clk_fb,LOCKED;
    wire CLOCK1;//clock;

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

    //assign clock = LOCKED ? CLOCK1 : 1'b0;

   //LED
    LEDdecoder LEDdecoder_inst(char,LED);

    //counter
    counter counter_inst(CLOCK1,reset,LOCKED,state);
    //anode controller
    anode_cntrl anode_cntrl_inst(state,reset,an3,an2,an1,an0);

    //cathode and output controller
    output_cntrl output_cntrl_inst(state,display_num,char);

    assign dp = 1'b1;
    assign {a,b,c,d,e,f,g} = LED;



endmodule