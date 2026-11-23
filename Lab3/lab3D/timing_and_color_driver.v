module timing_and_color_driver(
    input clk,
    input rst,
    output activedraw,
    output hsync,
    output vsync,
    output [2:0] rgb,
    output pixel_clock,
    output fast_pixel_clock
);

    wire clk_fb;
    wire LOCKED;
    wire [13:0] address;
    wire [7:0] hcount_slow;
    wire [6:0] vcount_slow;


    MMCME2_BASE #(
        .BANDWIDTH("OPTIMIZED"),
        .CLKFBOUT_MULT_F(17.625),
        .CLKFBOUT_PHASE(0.0),
        .CLKIN1_PERIOD(10.000),
        .CLKOUT1_DIVIDE(35.0),
        .CLKOUT2_DIVIDE(7),
        .CLKOUT1_DUTY_CYCLE(0.5),
        .CLKOUT2_DUTY_CYCLE(0.5),
        .CLKOUT1_PHASE(0.0),
        .CLKOUT2_PHASE(0.0),
        .DIVCLK_DIVIDE(2),
        .STARTUP_WAIT("FALSE")
    )
    MMCME2_BASE_inst (
        .CLKOUT1(pixel_clock),
        .CLKOUT2(fast_pixel_clock),

        .CLKFBOUT(clk_fb),
        .LOCKED(LOCKED),
        .CLKIN1(clk),
        .PWRDWN(1'b0),
        .RST(rst),
        .CLKFBIN(clk_fb)
    );

    assign address = activedraw ? {vcount_slow, hcount_slow[6:0]} : 14'b0;

    fsm fsm_inst (pixel_clock, rst, LOCKED, hsync, vsync, activedraw, hcount_slow, vcount_slow);

    vram16k vram_inst (pixel_clock, 1'b0,14'b0,3'b0, address, rgb);
endmodule