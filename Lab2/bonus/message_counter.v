
module msg_counter(input CLOCK1, input btn1, input reset, output reg [3:0] state);
    always @(posedge CLOCK1 or posedge reset) begin
        if (reset) begin
            state <= 4'b0000;
        end else if (btn1) begin
            state <= state + 1;
        end
    end
endmodule

module timer(input clk, input reset, output reg trigger);

    reg [22:0] counter = 0;
    //reg [12:0] counter = 0;
    //reg [5:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            trigger <= 1'b0;
        end 
        else begin
            if (counter == 23'd8_388_607) begin
            //if (counter == 6'd63) begin // 0.01s at 50MHz
            //if(counter == 12'd8191) begin
                counter <= 0;
                trigger <= 1'b1;
            end else begin
                counter <= counter + 1;
                trigger <= 1'b0;
            end
        end
    end
endmodule

module memory(input clk, input reset, input [3:0] message_index, input WR_EN, input [3:0] WR_ADDR, input [7:0] WR_DATA, output [31:0] display_num);
    reg [7:0] message [15:0];

    always@(posedge clk,posedge reset) begin
        if(reset) begin
            message[0]  <= 8'h5f;//' ' blank ascii or h5f '_' underscore
            message[1]  <= 8'h5f;
            message[2]  <= 8'h5f;
            message[3]  <= 8'h5f;
            message[4]  <= 8'h5f;
            message[5]  <= 8'h5f;
            message[6]  <= 8'h5f;
            message[7]  <= 8'h5f;
            message[8]  <= 8'h5f;
            message[9]  <= 8'h5f;
            message[10] <= 8'h5f;
            message[11] <= 8'h5f;
            message[12] <= 8'h5f;
            message[13] <= 8'h5f;
            message[14] <= 8'h5f;
            message[15] <= 8'h5f;
        end
        else if(WR_EN)begin
            message[WR_ADDR] <= WR_DATA;
        end
    end

    assign display_num = {message[message_index], message[(message_index+4'd1)], message[(message_index+4'd2)], message[(message_index+4'd3)]};

endmodule