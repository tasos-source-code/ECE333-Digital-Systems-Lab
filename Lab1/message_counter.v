
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
    //reg [5:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            trigger <= 1'b0;
        end 
        else begin
            if (counter == 23'd8_388_607) begin
            //if (counter == 6'd63) begin // 0.01s at 50MHz
                counter <= 0;
                trigger <= 1'b1;
            end else begin
                counter <= counter + 1;
                trigger <= 1'b0;
            end
        end
    end
endmodule

module memory(input CLOCK1, input reset, input [3:0] message_index, output [15:0] display_num);

    reg [3:0] message [15:0];

    always@(posedge CLOCK1,posedge reset) begin
        if(reset) begin
            message[0]  <= 4'h0; 
            message[1]  <= 4'h1; 
            message[2]  <= 4'h2; 
            message[3]  <= 4'h3; 
            message[4]  <= 4'h4; 
            message[5]  <= 4'h5; 
            message[6]  <= 4'h6; 
            message[7]  <= 4'h7; 
            message[8]  <= 4'h8; 
            message[9]  <= 4'h9; 
            message[10] <= 4'hA; 
            message[11] <= 4'hB; 
            message[12] <= 4'hC; 
            message[13] <= 4'hD; 
            message[14] <= 4'hE; 
            message[15] <= 4'hF; 
        end
    end

    // always @(posedge CLOCK1) begin
    //     display_num <= {message[message_index], message[(message_index+4'h1)], message[(message_index+4'h2)], message[(message_index+4'h3)]};
    // end

    assign display_num = {message[message_index], message[(message_index+4'h1)], message[(message_index+4'h2)], message[(message_index+4'h3)]};

endmodule