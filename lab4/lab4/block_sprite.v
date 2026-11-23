module block_sprite(input [9:0] hcount_in, input [9:0] vcount_in, input [9:0] sprite_x, input [9:0] sprite_y, output reg in_sprite);

    parameter SPRITE_WIDTH = 10'd32;
    parameter SPRITE_HEIGHT = 10'd32;
    // parameter red   8'hff
    // parameter green 8'hff
    // parameter blue  8'hff

    always@(*)begin
        // red_out     = 8'h0; // maybe backround color later
        // green_out   = 8'h0;
        // blue_out    = 8'h0;
        in_sprite   = 1'b0;
        if(hcount_in >= sprite_x && hcount_in <= (sprite_x + SPRITE_WIDTH)) begin
            if(vcount_in >= sprite_y && vcount_in <= (sprite_y + SPRITE_HEIGHT))begin
                // red_out     = red;
                // green_out   = green;
                // blue_out    = blue;
                in_sprite   = 1'b1;
            end
        end
    end

endmodule