`timescale 1ns/1ps

module tb_vram16k;
    reg         clk;
    reg         we;
    reg  [13:0] wr_addr;
    reg  [13:0] rd_addr;
    reg  [2:0]  din;
    wire [2:0]  rgb;

    integer i;

    vram16k dut (
        .clk     (clk),
        .we      (we),
        .wr_addr (wr_addr),
        .din     (din),
        .rd_addr (rd_addr),
        .rgb     (rgb)
    );

    initial begin
        clk = 1'b0;
    end
    always #5 clk = ~clk;


    // write one pixel
    task write_pixel(input [13:0] addr, input [2:0] data);
    begin
        @(negedge clk);
        wr_addr <= addr;
        din     <= data;
        we      <= 1'b1;

        @(posedge clk);   // write happens here

        @(negedge clk);
        we      <= 1'b0;
    end
    endtask

    // read and check pixel value
    task read_and_check(input [13:0] addr, input [2:0] expected);
    begin
        @(negedge clk);
        rd_addr <= addr;

        @(posedge clk); 

        #1;
        if (rgb !== expected) begin
            $display("ERROR @ %0t ns: addr=%0d expected=%b got=%b",$time, addr, expected, rgb);
            $stop;
        end else begin
            $display("OK    @ %0t ns: addr=%0d value=%b",$time, addr, rgb);
        end
    end
    endtask

    initial begin
        we      = 1'b0;
        wr_addr = 14'd0;
        rd_addr = 14'd0;
        din     = 3'b000;

        // needs some time for the memory to start working
        repeat (40) @(posedge clk);

        $display("writing in differnt addesses and values");
        // write some test pixels
        for (i = 0; i < 8; i = i + 1) begin
            write_pixel(2*i, i[2:0]);
        end

        // read them back and check
        for (i = 0; i < 8; i = i + 1) begin
            read_and_check(2*i, i[2:0]);
        end
        // read_and_check(14'd10, 3'b001);
        // read_and_check(14'd11, 3'b010);
        // read_and_check(14'd12, 3'b100);
        // read_and_check(14'd13, 3'b111);

        $display("all tests passed");
        $finish;
    end

endmodule
