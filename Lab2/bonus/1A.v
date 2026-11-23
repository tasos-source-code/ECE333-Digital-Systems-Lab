
module LEDdecoder(ascii, LED);
    input  [7:0] ascii;     // ASCII character
    output reg [6:0] LED;   // {a,b,c,d,e,f,g}, active-low

    always @* begin
        case (ascii)
            // Digits '0'–'9'
            8'h30: LED = 7'b0000001; // '0'
            8'h31: LED = 7'b1001111; // '1'
            8'h32: LED = 7'b0010010; // '2'
            8'h33: LED = 7'b0000110; // '3'
            8'h34: LED = 7'b1001100; // '4'
            8'h35: LED = 7'b0100100; // '5'
            8'h36: LED = 7'b0100000; // '6'
            8'h37: LED = 7'b0001111; // '7'
            8'h38: LED = 7'b0000000; // '8'
            8'h39: LED = 7'b0000100; // '9'

            // Space & basic symbols
            8'h20: LED = 7'b1111111; // ' ' (blank)
            8'h2D: LED = 7'b1111110; // '-' (minus)
            8'h2E: LED = 7'b1110111; // '.' (approx: bottom segment)
            8'h5F: LED = 7'b1110111; // '_' (underscore)
            8'h3F: LED = 7'b0111111; // upper - (for ERROR)

            // Letters – uppercase & lowercase map to same pattern

            // A / a
            8'h41, 8'h61: LED = 7'b0001000; // 'A'/'a'
            // B / b  (7-seg style looks like lowercase b)
            8'h42, 8'h62: LED = 7'b1100000; // 'B'/'b'
            // C / c
            8'h43, 8'h63: LED = 7'b0110001; // 'C'/'c'
            // D / d
            8'h44, 8'h64: LED = 7'b1000010; // 'D'/'d'
            // E / e
            8'h45, 8'h65: LED = 7'b0110000; // 'E'/'e'
            // F / f
            8'h46, 8'h66: LED = 7'b0111000; // 'F'/'f'
            // G / g
            8'h47, 8'h67: LED = 7'b0100001; // 'G'/'g'
            // H / h
            8'h48, 8'h68: LED = 7'b1001000; // 'H'/'h'
            // I / i  (same as '1')
            8'h49, 8'h69: LED = 7'b1001111; // 'I'/'i'
            // J / j
            8'h4A, 8'h6A: LED = 7'b1000011; // 'J'/'j'
            // K / k (approximate as 'H')
            8'h4B, 8'h6B: LED = 7'b1001000; // 'K'/'k' ≈ 'H'
            // L / l
            8'h4C, 8'h6C: LED = 7'b1110001; // 'L'/'l'
            // M / m (approximate with 'n' style)
            8'h4D, 8'h6D: LED = 7'b1101010; // 'M'/'m' ≈ 'n'
            // N / n
            8'h4E, 8'h6E: LED = 7'b1101010; // 'N'/'n'
            // O / o  (same as '0' without middle segment)
            8'h4F, 8'h6F: LED = 7'b0000001; // 'O'/'o'
            // P / p
            8'h50, 8'h70: LED = 7'b0011000; // 'P'/'p'
            // Q / q
            8'h51, 8'h71: LED = 7'b0001100; // 'Q'/'q'
            // R / r
            8'h52, 8'h72: LED = 7'b1111010; // 'R'/'r'
            // S / s
            8'h53, 8'h73: LED = 7'b0100100; // 'S'/'s'
            // T / t
            8'h54, 8'h74: LED = 7'b1110000; // 'T'/'t'
            // U / u
            8'h55, 8'h75: LED = 7'b1000001; // 'U'/'u'
            // V / v (approximate as 'U')
            8'h56, 8'h76: LED = 7'b1000001; // 'V'/'v' ≈ 'U'
            // W / w (approximate as 'U')
            8'h57, 8'h77: LED = 7'b1000001; // 'W'/'w' ≈ 'U'
            // X / x (approximate as 'H')
            8'h58, 8'h78: LED = 7'b1001000; // 'X'/'x' ≈ 'H'
            // Y / y
            8'h59, 8'h79: LED = 7'b1000100; // 'Y'/'y'
            // Z / z (approximate as '2')
            8'h5A, 8'h7A: LED = 7'b0010010; // 'Z'/'z' ≈ '2'

            // Anything else: blank
            default: LED = 7'b1111111; // blank 
        endcase
    end
endmodule

// module LEDdecoder(char, LED);
//     input [3:0] char;
//     output reg [6:0] LED;

//     always @(char) begin
//         case (char)
//             4'h0: LED = 7'b0000001; // 0
//             4'h1: LED = 7'b1001111; // 1
//             4'h2: LED = 7'b0010010; // 2
//             4'h3: LED = 7'b0000110; // 3
//             4'h4: LED = 7'b1001100; // 4
//             4'h5: LED = 7'b0100100; // 5
//             4'h6: LED = 7'b0100000; // 6
//             4'h7: LED = 7'b0001111; // 7
//             4'h8: LED = 7'b0000000; // 8
//             4'h9: LED = 7'b0000100; // 9
//             4'hA: LED = 7'b0001000; // A
//             4'hB: LED = 7'b1100000; // B
//             4'hC: LED = 7'b0110001; // C
//             4'hD: LED = 7'b1000010; // D
//             4'hE: LED = 7'b0110000; // E
//             4'hF: LED = 7'b0111000; // F
//             default: LED = 7'b1111111; // Off 
//         endcase
//     end
// endmodule
