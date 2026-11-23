module timing_and_color_driver(
    input clk,
    input rst,
    input up,
    input down,
    input [3:0] paddle_speed,
    input [3:0] puck_speed,
    input new_game,
    output reg new_frame_LED,
    output activedraw,
    output hsync,
    output vsync,
    output [2:0][7:0] rgb,
    output pixel_clock,
    output fast_pixel_clock
);

    wire clk_fb;
    wire LOCKED;
    wire [13:0] address;
    wire [7:0] hcount_slow;
    wire [6:0] vcount_slow;
    wire new_frame;
    reg [5:0] frame_counter;
    wire [9:0] h_counter, v_counter;
    


    parameter PUCK_WIDTH =32;
    parameter PUCK_HIGHT =32;
    parameter PADDLE_WIDTH =10;
    parameter PADDLE_HIGHT =100;


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

    fsm fsm_inst (pixel_clock, rst, hsync, vsync, activedraw, hcount_slow, h_counter, vcount_slow, v_counter, new_frame);

    //assign address = activedraw ? {vcount_slow, hcount_slow[6:0]} : 14'b0;

    //vram16k vram_inst (clk, 1'b0,14'b0,3'b0, address, rgb);

    pong pong_inst(pixel_clock, rst, up, down, puck_speed, paddle_speed, new_game, new_frame, h_counter, v_counter, rgb[0], rgb[1], rgb[2]);

    //count 60 new frames
    always @(posedge pixel_clock or posedge rst) begin
        if (rst) begin
            frame_counter <= 0;
            new_frame_LED <=0;
        end else begin
            if(frame_counter == 6'd59) begin
                frame_counter <= 0;
                new_frame_LED <= 1'b1;
            end else if (new_frame) begin
                frame_counter <= frame_counter + 1;
                new_frame_LED <= 1'b0;
            end
        end
    end
endmodule