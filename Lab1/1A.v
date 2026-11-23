`timescale 1ns/1ps

module LEDdecoder(char, LED);
    input [3:0] char;
    output reg [6:0] LED;

    always @(char) begin
        case (char)
            4'h0: LED = 7'b0000001; // 0
            4'h1: LED = 7'b1001111; // 1
            4'h2: LED = 7'b0010010; // 2
            4'h3: LED = 7'b0000110; // 3
            4'h4: LED = 7'b1001100; // 4
            4'h5: LED = 7'b0100100; // 5
            4'h6: LED = 7'b0100000; // 6
            4'h7: LED = 7'b0001111; // 7
            4'h8: LED = 7'b0000000; // 8
            4'h9: LED = 7'b0000100; // 9
            4'hA: LED = 7'b0001000; // A
            4'hB: LED = 7'b1100000; // B
            4'hC: LED = 7'b0110001; // C
            4'hD: LED = 7'b1000010; // D
            4'hE: LED = 7'b0110000; // E
            4'hF: LED = 7'b0111000; // F
            default: LED = 7'b1111111; // Off 
        endcase
    end
endmodule
