module pong (
    input clk, // pixel clock //
    input rst,
    input up,
    input down,
    input [3:0] puck_speed,
    input [3:0] paddle_speed,
    input new_game,
    input new_frame,
    input [9:0] hcount,
    input [9:0] vcount,
    output reg [7:0] red,
    output reg [7:0] green,
    output reg [7:0] blue
);

    wire in_puck,in_paddle;
    reg [9:0] paddle_x, paddle_y, puck_x, puck_y;
    reg vertical, horizontal, game_over;

    parameter PUCK_WIDTH =32;
    parameter PUCK_HIGHT =32;
    parameter PADDLE_WIDTH =10;
    parameter PADDLE_HIGHT =100;
    
    parameter active_drawing_h = 640;
    parameter active_drawing_v = 480;

    block_sprite #(.SPRITE_WIDTH(PUCK_WIDTH),.SPRITE_HEIGHT(PUCK_HIGHT)) puck(hcount, vcount, puck_x, puck_y, in_puck); 

    block_sprite #(.SPRITE_WIDTH(PADDLE_WIDTH),.SPRITE_HEIGHT(PADDLE_HIGHT)) paddle(hcount, vcount, paddle_x, paddle_y, in_paddle); 

    always@(*)begin
        red=8'h0; green=8'h0; blue=8'h0;
        if(in_puck) begin red=8'hff; green=8'hff; blue=8'hff;end
        if(in_paddle) begin red=8'hff; green=8'hff; blue=8'hff;end
    end


    // paddle position
    always@(posedge clk, posedge rst)begin
        if(rst || new_game)begin
            paddle_x <= 10'd5;
            paddle_y <= ((active_drawing_v - PADDLE_HIGHT)/2);
        end
        else begin
            if(new_frame && !game_over)begin
                if(up) begin
                    if(paddle_y > {6'b000000,{paddle_speed}})
                        paddle_y <= paddle_y - {6'b000000,{paddle_speed}};
                    else
                        paddle_y <= 0;
                end 
                else if (down) begin
                    if((active_drawing_v - (PADDLE_HIGHT + paddle_y)) > {6'b000000,{paddle_speed}})
                        paddle_y <= paddle_y + {6'b000000,{paddle_speed}};
                    else
                        paddle_y <= active_drawing_v - PADDLE_HIGHT;
                end
            end
        end
    end

    //puck position
    always@(posedge clk, posedge rst)begin
        if(rst || new_game)begin
            puck_x <= ((active_drawing_h - PUCK_WIDTH)/2);
            puck_y <= ((active_drawing_v - PUCK_HIGHT)/2);
            vertical <= 1'b1;
            horizontal <= 1'b1;
            game_over <= 1'b0;
        end
        else begin
            if(new_frame && !game_over)begin
                //vertical checks
                if (!vertical) begin //going up
                    if(puck_y > {6'b000000,{puck_speed}})
                        puck_y <= puck_y - {6'b000000,{puck_speed}};
                    else begin
                        vertical <= !vertical;
                        puck_y <= 0; 
                    end                   
                end 
                else begin // going down
                    if((active_drawing_v - (PUCK_HIGHT + puck_y)) > {6'b000000,{puck_speed}})
                        puck_y <= puck_y + {6'b000000,{puck_speed}};
                    else begin
                        vertical <= !vertical;
                        puck_y <= active_drawing_v- PUCK_HIGHT;
                    end
                end

                //horizontal checks
                if (!horizontal) begin //going left
                    if(paddle_y < (puck_y+PUCK_HIGHT) && (paddle_y+PADDLE_HIGHT) > puck_y) begin //in front of paddle
                        if(puck_x > ({6'b000000,{puck_speed}} + 5 + PADDLE_WIDTH)) //there is space to the left
                            puck_x <= puck_x - {6'b000000,{puck_speed}}; 
                        else begin // struck the puddle
                            horizontal <= !horizontal;
                            puck_x <= 5 + PADDLE_WIDTH; 
                        end
                    end
                    else begin //away from paddle
                        if(puck_x > {6'b000000,{puck_speed}} + 5 + PADDLE_WIDTH) //there is space to the left
                            puck_x <= puck_x - {6'b000000,{puck_speed}};
                        else begin  //game over
                            puck_x <= 5 + PADDLE_WIDTH; 
                            game_over <=1;
                        end
                    end                  
                end 
                else begin // going right
                    if((active_drawing_h - (PUCK_WIDTH + puck_x)) > {6'b000000,{puck_speed}})
                        puck_x <= puck_x + {6'b000000,{puck_speed}};
                    else begin
                        horizontal <= !horizontal;
                        puck_x <= active_drawing_h - PUCK_WIDTH;
                    end
                end
            end
        end
    end
endmodule
