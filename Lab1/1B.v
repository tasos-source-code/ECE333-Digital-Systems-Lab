`timescale 1ns/1ps

module counter(clk,reset,LOCKED,state);
    input clk,reset, LOCKED;
    output reg [3:0]state;

    always @(posedge clk or posedge reset) begin
        if (reset || !LOCKED) state <= 4'b0000;
        else if (LOCKED) begin
            if (state == 4'b0000) state <= 4'b1111;
            else state <= state - 1'b1;
        end
    end
endmodule

module anode_cntrl(state,reset, an3,an2,an1,an0);
    output reg an3,an2,an1,an0;
    input [3:0] state;
    input reset;

    //anode setter
    always@(state) begin
        if(reset) begin
            {an3,an2,an1,an0} = 4'b1111;
        end

        else if(state == 4'b1110) begin
            {an3,an2,an1,an0} = 4'b0111;
        end
        else if(state == 4'b1010) begin
            {an3,an2,an1,an0} = 4'b1011;
        end
        else if(state == 4'b0110) begin
            {an3,an2,an1,an0} = 4'b1101;
        end
        else if(state == 4'b0010) begin
            {an3,an2,an1,an0} = 4'b1110;
        end
        else begin
            {an3,an2,an1,an0} = 4'b1111;
        end
    end
endmodule

module output_cntrl(state,display_num,char);
    //input clk,reset;
    input [3:0] state;
    input [15:0] display_num; 
    output reg [3:0] char;

    always @(state) begin
        case (state)
            4'b0000, 4'b1111, 4'b1110, 4'b1101: char = display_num[15:12];
            4'b1100, 4'b1011, 4'b1010, 4'b1001: char = display_num[11:8];
            4'b1000, 4'b0111, 4'b0110, 4'b0101: char = display_num[7:4];
            4'b0100, 4'b0011, 4'b0010, 4'b0001: char = display_num[3:0];
            default: char = 4'h0;
        endcase
    end


endmodule

