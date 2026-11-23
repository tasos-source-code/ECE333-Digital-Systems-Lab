module tmg_clr_driver_tb;
    reg clk;
    reg rst;
    wire activedraw;
    wire hsync;
    wire vsync;
    wire [2:0] rgb;

    timing_and_color_driver dut (
        .clk(clk),
        .rst(rst),
        .activedraw(activedraw),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    initial begin
        rst = 1;
        #20;
        rst = 0;
        #10000; // Run simulation for some time
        $finish;
    end

endmodule