module hdmi_controller(input clk, input rst, input [7:0] intencity, output [2:0] hdmi_tx_p, output [2:0] hdmi_tx_n, output hdmi_clk_p, output hdmi_clk_n);
    wire clk_pixel,clk_5x,activedraw,hsync,vsync;
    wire [7:0] red,green,blue;
    wire r,g,b;
    wire [9:0] tmds_10b [2:0];
    wire [2:0] tmds_signal;
    
    timing_and_color_driver timing_and_color_driver_inst(
        .clk(clk),
        .rst(rst),
        .activedraw(activedraw),
        .hsync(hsync),
        .vsync(vsync),
        .rgb({r, g, b}),
        .pixel_clock(clk_pixel),
        .fast_pixel_clock(clk_5x)
    );

    assign red   = r ? intencity : 8'd0;
    assign green = g ? intencity : 8'd0;
    assign blue  = b ? intencity : 8'd0;


    tmds_encoder tmds_red(
        .clk(clk_pixel), // your pixel clock
        .rst(rst), // system reset
        .data_in(red), // 8-bit value
        .control_in(2'b0),
        .ve_in(activedraw), // from part2
        .tmds_out(tmds_10b[2]));
    tmds_encoder tmds_green(
        .clk(clk_pixel), // your pixel clock
        .rst(rst), // system reset
        .data_in(green), // 8-bit value
        .control_in(2'b0),
        .ve_in(activedraw), // from part2
        .tmds_out(tmds_10b[1]));
    tmds_encoder tmds_blue(
        .clk(clk_pixel), // your pixel clock
        .rst(rst), // system reset
        .data_in(blue), // 8-bit value
        .control_in({vsync, hsync}), // from part2
        .ve_in(activedraw), // from part2
        .tmds_out(tmds_10b[0]));

    tmds_serializer red_ser(
        .clk_pixel_in(clk_pixel), // your pixel clock
        .clk_5x_in(clk_5x), // your x5 clock
        .rst_in(rst), // system reset
        .tmds_in(tmds_10b[2]),
        .tmds_out(tmds_signal[2]));
    tmds_serializer green_ser(
        .clk_pixel_in(clk_pixel), // your pixel clock
        .clk_5x_in(clk_5x), // your x5 clock
        .rst_in(rst), // system reset
        .tmds_in(tmds_10b[1]),
        .tmds_out(tmds_signal[1]));
    tmds_serializer blue_ser(
        .clk_pixel_in(clk_pixel), // your pixel clock
        .clk_5x_in(clk_5x), // your x5 clock
        .rst_in(rst), // system reset
        .tmds_in(tmds_10b[0]),
        .tmds_out(tmds_signal[0]));

    OBUFDS OBUFDS_blue (.I(tmds_signal[0]), .O(hdmi_tx_p[0]), .OB(hdmi_tx_n[0]));
    OBUFDS OBUFDS_green(.I(tmds_signal[1]), .O(hdmi_tx_p[1]), .OB(hdmi_tx_n[1]));
    OBUFDS OBUFDS_red (.I(tmds_signal[2]), .O(hdmi_tx_p[2]), .OB(hdmi_tx_n[2]));
    OBUFDS OBUFDS_clock(.I(clk_pixel), .O(hdmi_clk_p), .OB(hdmi_clk_n));
endmodule
