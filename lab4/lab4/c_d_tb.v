`timescale 1ns/100ps

module tb_top_hdmi_pong;

    // -----------------------------
    // Clock / Reset
    // -----------------------------
    reg clk = 1'b0;
    reg rst = 1'b1;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;    // 10ns period -> 100 MHz
    end

    // -----------------------------
    // Inputs
    // -----------------------------
    reg        up, down;
    reg [3:0]  paddle_speed, puck_speed;

    // -----------------------------
    // Outputs (waveform visibility)
    // -----------------------------
    wire [2:0] hdmi_tx_p;
    wire [2:0] hdmi_tx_n;
    wire       hdmi_clk_p;
    wire       hdmi_clk_n;
    wire       new_frame_LED;

    // -----------------------------
    // DUT
    // -----------------------------
    hdmi_controller uut (
        .clk           (clk),
        .rst           (rst),
        .up            (up),
        .down          (down),
        .paddle_speed  (paddle_speed),
        .puck_speed    (puck_speed),
        .intencity     (8'd255),
        .hdmi_tx_p     (hdmi_tx_p),
        .hdmi_tx_n     (hdmi_tx_n),
        .hdmi_clk_p    (hdmi_clk_p),
        .hdmi_clk_n    (hdmi_clk_n),
        .new_frame_LED (new_frame_LED)
    );

    // -----------------------------
    // Frame counter (rising edge)
    // -----------------------------
    reg new_frame_d;
    integer frame_count;

    always @(posedge clk) begin
        new_frame_d <= new_frame_LED;
        if (!rst && (new_frame_LED && !new_frame_d)) begin
        frame_count <= frame_count + 1;
        end
    end

    // -----------------------------
    // Helpers: drive buttons in *frames*
    // -----------------------------
    task automatic wait_frames(input integer n);
        integer i;
        begin
        for (i = 0; i < n; i = i + 1) begin
            // wait for rising edge of new_frame_LED
            @(posedge clk);
            while (!(new_frame_LED && !new_frame_d)) @(posedge clk);
        end
        end
    endtask

    task automatic press_up_frames(input integer n);
        begin
        up   = 1'b1;
        down = 1'b0;
        wait_frames(n);
        up   = 1'b0;
        end
    endtask

    task automatic press_down_frames(input integer n);
        begin
        up   = 1'b0;
        down = 1'b1;
        wait_frames(n);
        down = 1'b0;
        end
    endtask

    task automatic neutral_frames(input integer n);
        begin
        up   = 1'b0;
        down = 1'b0;
        wait_frames(n);
        end
    endtask

    // “AI-ish” jitter: sometimes tap up/down for a few frames
    task automatic random_taps(input integer tap_events, input integer max_len);
        integer k, len, dir;
        begin
        for (k = 0; k < tap_events; k = k + 1) begin
            len = 1 + ($urandom_range(0, max_len-1));
            dir = $urandom_range(0, 2); // 0:neutral 1:up 2:down
            case (dir)
            1: press_up_frames(len);
            2: press_down_frames(len);
            default: neutral_frames(len);
            endcase
        end
        end
    endtask

    // -----------------------------
    // Basic sanity checks
    // -----------------------------
    task automatic assert_no_x;
        begin
        if (^hdmi_tx_p === 1'bX || ^hdmi_tx_n === 1'bX ||
            hdmi_clk_p === 1'bX || hdmi_clk_n === 1'bX) begin
            $display("[%0t] ERROR: X detected on HDMI outputs", $time);
            $stop;
        end
        end
    endtask

    // -----------------------------
    // Main stimulus
    // -----------------------------
    integer STOP_AFTER_FRAMES;

    initial begin
        // Defaults (avoid X-propagation)
        up = 1'b0;
        down = 1'b0;
        paddle_speed = 4'd3;
        puck_speed   = 4'd3;

        frame_count = 0;
        new_frame_d = 0;

        // Waves
        $dumpfile("pong_tb.vcd");
        $dumpvars(0, tb_top_hdmi_pong);

        // Reset
        rst = 1'b1;
        repeat (50) @(posedge clk);   // 50 cycles
        rst = 1'b0;

        // Wait a bit for things to settle
        neutral_frames(5);

        // Scenario 1: simple up/down sweeps (good to see motion clearly)
        press_up_frames(20);
        neutral_frames(5);
        press_down_frames(30);
        neutral_frames(10);

        // Scenario 2: change speeds mid-game (see if logic glitches)
        paddle_speed = 4'd6;
        puck_speed   = 4'd4;
        random_taps(25, 6);

        // Scenario 3: faster puck, slower paddle (stress test)
        paddle_speed = 4'd2;
        puck_speed   = 4'd8;
        random_taps(40, 4);

        // Scenario 4: “panic mode” (hold buttons longer)
        press_up_frames(60);
        press_down_frames(60);

        // Run a bit more, then finish
        STOP_AFTER_FRAMES = 400; // total frames after reset (approx)
        while (frame_count < STOP_AFTER_FRAMES) begin
        @(posedge clk);
        assert_no_x();
        end

        $display("Done. Simulated %0d frames.", frame_count);
        $finish;
    end

endmodule
