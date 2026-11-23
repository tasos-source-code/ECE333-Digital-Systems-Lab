module output_control(clk, reset, counterrst, valid_flag, ferror_flag, perror_flag, data, Rx_PERROR, Rx_FERROR, Rx_VALID, Rx_DATA);
    input clk, reset, counterrst, valid_flag, ferror_flag, perror_flag;
    output reg Rx_PERROR, Rx_FERROR, Rx_VALID;
    output [7:0] Rx_DATA;
    input [7:0] data;

    always@(posedge clk or posedge reset) begin
        if(reset) begin
            Rx_VALID   <= 1'b0; Rx_FERROR  <= 1'b0; Rx_PERROR  <= 1'b0;
        end
        else if(counterrst) begin
            Rx_VALID   <= 1'b0; Rx_FERROR  <= 1'b0; Rx_PERROR  <= 1'b0;
        end
        else if(valid_flag && !Rx_FERROR && !Rx_PERROR) begin
            Rx_VALID   <= 1'b1; Rx_FERROR  <= 1'b0; Rx_PERROR  <= 1'b0;
        end
        else if(ferror_flag ) begin
            Rx_VALID   <= 1'b0; Rx_FERROR  <= 1'b1;
 
        end
        else if(perror_flag) begin
            Rx_VALID   <= 1'b0; Rx_PERROR  <= 1'b1;
        end
    end

    //assign either 8'h20 ' ' or something special (upper -) 8h3f for error for my decoder
    assign Rx_DATA = Rx_VALID? data : 8'h3f;


endmodule