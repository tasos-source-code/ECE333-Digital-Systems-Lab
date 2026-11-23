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


    localparam integer NUM_IMAGES      = 23;//23
    localparam integer FRAMES_PER_IMG  = 20;   // F 20
    localparam integer FRAME_COUNTER_W = $clog2(FRAMES_PER_IMG);
    localparam integer IMG_SEL_W       = $clog2(NUM_IMAGES);

    reg [FRAME_COUNTER_W-1:0] frame_cnt = 0;
    reg [IMG_SEL_W-1:0]       img_sel   = 0;
    reg prev_vsync;


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

    fsm fsm_inst (pixel_clock, rst, hsync, vsync, activedraw, hcount_slow, vcount_slow);

    vram16k vram_inst (pixel_clock, rst, 1'b0,14'b0,3'b0, address, img_sel, rgb);



//select which vram (image) to display
    // always @(posedge pixel_clock or posedge rst) begin
    //     if (rst)
    //         prev_vsync <= 1'b0;
    //     else
    //         prev_vsync <= vsync;
    // end

    // wire vsync_edge = (~prev_vsync) & vsync; 
    // always @(posedge clk or posedge rst) begin
    //     if (rst) begin
    //         frame_cnt <= 0;
    //         img_sel   <= 0;
    //     end else begin
    //         // Αν έχεις vsync:
    //         if (vsync_edge) begin
    //             if (frame_cnt == FRAMES_PER_IMG-1) begin
    //                 frame_cnt <= 0;
    //                 if (img_sel == NUM_IMAGES-1)
    //                     img_sel <= 0;
    //                 else
    //                     img_sel <= img_sel + 1'b1;
    //             end else begin
    //                 frame_cnt <= frame_cnt + 1'b1;
    //             end
    //         end
    //     end
    // end

    // 1) Register vsync twice (so edge detect is clean & time-safe)
    reg vsync_d1, vsync_d2;
    always @(posedge pixel_clock or posedge rst) begin
        if (rst) begin
            vsync_d1 <= 1'b0;
            vsync_d2 <= 1'b0;
        end else begin
            vsync_d1 <= vsync;
            vsync_d2 <= vsync_d1;
        end
    end
    wire vsync_edge = (~vsync_d2) & vsync_d1;

    // 2) Register the edge into a 1-cycle "advance" pulse
    reg advance;
    always @(posedge pixel_clock or posedge rst) begin
        if (rst) advance <= 1'b0;
        else     advance <= vsync_edge;
    end

    always @(posedge pixel_clock or posedge rst) begin
        if (rst) begin
            frame_cnt <= 0;
            img_sel   <= 0;
        end else begin
            if (advance) begin
                if (frame_cnt == FRAMES_PER_IMG-1) begin
                    frame_cnt <= 0;
                    img_sel   <= (img_sel == NUM_IMAGES-1) ? 0 : (img_sel + 1'b1);
                end else begin
                    frame_cnt <= frame_cnt + 1'b1;
                end
            end
        end
    end

endmodule