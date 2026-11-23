module hdmi_tb;
    reg clk;
    reg rst;
    wire [2:0] hdmi_tx_p;
    wire [2:0] hdmi_tx_n;
    wire hdmi_clk_p;
    wire hdmi_clk_n;

    hdmi_controller hdmi_controller_inst(
        .clk(clk),
        .rst(rst),
        .hdmi_tx_p(hdmi_tx_p),
        .hdmi_tx_n(hdmi_tx_n),
        .hdmi_clk_p(hdmi_clk_p),
        .hdmi_clk_n(hdmi_clk_n)
    );

    initial begin
        clk = 0;
        rst = 1;
        #100;
        rst = 0;
    end

    always #5 clk = ~clk;

endmodule