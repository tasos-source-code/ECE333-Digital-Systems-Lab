// module debouncer #(
//     parameter CLK_FREQ_HZ = 5_000_000,  // Clock frequency in Hertz
//     parameter DEBOUNCE_MS = 0.5 // milliseconds
// )(
//     input  wire clk,
//     input  wire rst,
//     input  wire btn_sync,    // already synchronized input
//     output reg  btn_stable
// );

//     localparam integer COUNT_MAX = (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;
//     localparam integer COUNT_WIDTH = $clog2(COUNT_MAX + 1);

//     reg [COUNT_WIDTH-1:0] counter = 0;
//     reg btn_last;

//     always @(posedge clk or posedge rst) begin
//         if (rst) begin
//             btn_stable <= 0;
//             btn_last   <= 0;
//             counter    <= 0;
//         end else begin
//             if (btn_sync != btn_last) begin
//                 // input changed -> reset counter
//                 btn_last <= btn_sync;
//                 counter  <= 0;
//             end else if (counter < COUNT_MAX) begin
//                 // still counting stable time
//                 counter <= counter + 1;
//             end else begin
//                 // input stable long enough -> update output
//                 btn_stable <= btn_last;
//             end
//         end
//     end

// endmodule
module debouncer #(
    parameter CLK_FREQ_HZ = 5_000_000,  // Clock frequency in Hertz
    parameter DEBOUNCE_MS = 0.5         // Debounce time in milliseconds
)(
    input  wire clk,
    input  wire rst,
    input  wire btn_sync,    // already synchronized input
    output reg  btn_pulse    // 1-clock pulse on debounced rising edge
);

    localparam integer COUNT_MAX   = (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;
    localparam integer COUNT_WIDTH = $clog2(COUNT_MAX + 1);

    reg [COUNT_WIDTH-1:0] counter = 0;
    reg btn_last;
    reg btn_stable;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            btn_stable <= 0;
            btn_last   <= 0;
            counter    <= 0;
            btn_pulse  <= 0;
        end else begin
            btn_pulse <= 0;  // default

            if (btn_sync != btn_last) begin
                // input changed -> reset counter
                btn_last <= btn_sync;
                counter  <= 0;
            end else if (counter < COUNT_MAX) begin
                // still counting stable time
                counter <= counter + 1;
            end else if (btn_stable != btn_last) begin
                // input stable long enough and changed
                btn_stable <= btn_last;

                // generate pulse only on rising edge (0 -> 1)
                if (btn_last == 1'b1)
                    btn_pulse <= 1'b1;
            end
        end
    end

endmodule
