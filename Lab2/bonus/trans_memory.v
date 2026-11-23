module ROM(input clk, input reset, input RD_EN, input [3:0] ADDR, output reg [7:0] DATA);
    reg [7:0] message [15:0];

    parameter MSG0  = 8'h69; // 'i'
    parameter MSG1  = 8'h20; // ' '
    parameter MSG2  = 8'h6C; // 'l'
    parameter MSG3  = 8'h6F; // 'o'
    parameter MSG4  = 8'h76; // 'v'
    parameter MSG5  = 8'h65; // 'e'
    parameter MSG6  = 8'h20; // ' '
    parameter MSG7  = 8'h65; // 'e'
    parameter MSG8  = 8'h63; // 'c'
    parameter MSG9  = 8'h65; // 'e'
    parameter MSG10 = 8'h33; // '3'
    parameter MSG11 = 8'h33; // '3'
    parameter MSG12 = 8'h33; // '3'
    parameter MSG13 = 8'h5f; // '_'
    parameter MSG14 = 8'h5f; // '_'
    parameter MSG15 = 8'h5f;  // '_'

    always@(posedge clk,posedge reset) begin
        if(reset) begin
            message[0]  <= MSG0;
            message[1]  <= MSG1;
            message[2]  <= MSG2;
            message[3]  <= MSG3;
            message[4]  <= MSG4;
            message[5]  <= MSG5;
            message[6]  <= MSG6;
            message[7]  <= MSG7;
            message[8]  <= MSG8;
            message[9]  <= MSG9;
            message[10] <= MSG10;
            message[11] <= MSG11;
            message[12] <= MSG12;
            message[13] <= MSG13;
            message[14] <= MSG14;
            message[15] <= MSG15;
            DATA <= 8'h20;
        end
        else if(RD_EN) begin
            DATA <= message[ADDR];
        end
    end


endmodule