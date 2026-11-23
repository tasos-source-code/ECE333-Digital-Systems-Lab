module tmds_encoder (
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  data_in,
    input  wire [1:0]  control_in,
    input  wire        ve_in,         // video enable (DE)
    output reg  [9:0]  tmds_out,
    output reg  signed [4:0] tally   // running disparity
);
    wire [8:0] q_m;
    integer i;
    reg [3:0] ones;       // 0..8, no need to be signed
    reg [3:0] zeros;      // 0..8
    reg signed [4:0] diff;   // ones - zeros

    tm_choice tm_choice_inst(.data_in(data_in),.q_m(q_m));

    always @(*) begin
        ones  = 4'd0;
        for (i = 0; i < 8; i = i + 1)
            ones = ones + q_m[i];

        zeros = 4'd8 - ones;

        diff = ({1'b0, ones}) - ({1'b0, zeros});
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tmds_out <= 10'd0;
            tally    <= 5'd0;
        end else if (ve_in) begin
            if (tally == 0 || diff == 0) begin
                tmds_out[9] <= !q_m[8];
                tmds_out[8] <= q_m[8];
                tmds_out[7:0] <= (q_m[8]? q_m[7:0]: ~q_m[7:0]);

                if(q_m[8]) begin
                    tally <= tally + diff; // = tally + (ones - zeros)
                end else begin
                    tally <= tally - diff; // = tally + (zeros - ones)
                end

            end else if ( (tally > 0 && diff > 0) || (tally < 0 && diff < 0) ) begin
                tmds_out[9] <= 1'b1;
                tmds_out[8] <= q_m[8];
                tmds_out[7:0] <= ~q_m[7:0];
                tally <= tally - diff + 2*({4'b0, q_m[8]}); // = tally + (zeros - ones)
            end else begin
                tmds_out[9] <= 1'b0;
                tmds_out[8] <= q_m[8];
                tmds_out[7:0] <= q_m[7:0];
                tally <= tally + diff - 2*({4'b0, ~q_m[8]}); // = tally + (ones - zeros)
            end

        end else begin
            case (control_in)
                2'b00: tmds_out <= 10'b1101010100;
                2'b01: tmds_out <= 10'b0010101011;
                2'b10: tmds_out <= 10'b0101010100;
                2'b11: tmds_out <= 10'b1010101011;
            endcase
            tally <= 5'd0;
        end
    end
endmodule
