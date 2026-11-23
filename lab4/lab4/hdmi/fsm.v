module fsm(clk, reset, hsync, vsync, active_draw, h_slow, h_counter, v_slow, v_counter, new_frame);
    input clk, reset;
    output reg hsync, vsync, active_draw;
    output new_frame;
    output reg [9:0] h_counter, v_counter;
    reg [2:0] state, next_state;
    reg [2:0] count, count2;
    output reg [7:0] h_slow;
    output reg [6:0] v_slow;
    
    localparam ACTIVE_DRAW = 3'b000;
    localparam HORIZONTAL_BLANKING = 3'b001;
    localparam H_SYNC = 3'b010;
    localparam VERTICAL_BLANKING = 3'b011;
    localparam V_SYNC = 3'b100;
    localparam TOTAL_SYNC = 3'b101;

    parameter active_drawing_h          = 640;
    parameter horizontal_front_porch    = 16;
    parameter horizontal_sync           = 96;
    parameter horizontal_back_porch     = 48;
    parameter active_drawing_v          = 480;
    parameter vertical_front_porch      = 10;
    parameter vertical_sync             = 2;
    parameter vertical_back_porch       = 33;
    parameter total_horizontal          = 800; //640+16+96+48
    parameter total_vertical            = 525; //480+10+2+33


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= ACTIVE_DRAW;
        end else 
            state <= next_state;
    end

    always@(*) begin
        active_draw=0;
        hsync=0;
        vsync=0;
        next_state = state;

        case(state)

            ACTIVE_DRAW: begin
                active_draw = 1;
                if (h_counter == active_drawing_h-1) next_state = HORIZONTAL_BLANKING;
            end

            HORIZONTAL_BLANKING: begin
                if (h_counter == (active_drawing_h + horizontal_front_porch-1)) begin
                    next_state = H_SYNC;
                end
                else if( h_counter == total_horizontal-1 && v_counter < active_drawing_v-1) begin
                    next_state = ACTIVE_DRAW;
                end
                else if( v_counter == active_drawing_v-1 && h_counter == total_horizontal-1) begin
                    next_state = VERTICAL_BLANKING;
                end
            end

            H_SYNC: begin
                hsync = 1;
                if (h_counter == (active_drawing_h + horizontal_front_porch + horizontal_sync - 1) && v_counter > active_drawing_v - 1) begin
                    next_state = VERTICAL_BLANKING;
                end
                else if( h_counter == (active_drawing_h + horizontal_front_porch + horizontal_sync - 1) ) begin
                    next_state = HORIZONTAL_BLANKING;
                end
            end

            VERTICAL_BLANKING: begin
                if (h_counter == active_drawing_h+horizontal_front_porch-1) begin
                    next_state = H_SYNC;
                end
                else if( v_counter == active_drawing_v + vertical_front_porch-1 && h_counter == total_horizontal-1) begin
                    next_state = V_SYNC;
                end
                else if( v_counter == total_vertical-1 && h_counter == total_horizontal-1) begin
                    next_state = ACTIVE_DRAW;
                end
            end

            V_SYNC: begin
                vsync = 1;
                if (h_counter == active_drawing_h + horizontal_front_porch-1) begin
                    next_state = TOTAL_SYNC;
                end
                else if( h_counter == total_horizontal-1 && v_counter == active_drawing_v + vertical_front_porch + vertical_sync-1 ) begin
                    next_state = VERTICAL_BLANKING;
                end
            end

            TOTAL_SYNC: begin
                hsync = 1;
                vsync = 1;
                if (h_counter == active_drawing_h + horizontal_front_porch + horizontal_sync-1)
                    next_state = V_SYNC;
            end

            default: begin
                next_state = ACTIVE_DRAW;
            end
        endcase
    end

//horizontal counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_counter <= 0;
            h_slow    <= 0;
            count     <= 0;
        end else begin
            if (h_counter == total_horizontal-1) begin
                h_counter <= 0;
            end else begin
                h_counter <= h_counter + 1;
            end

            if (h_counter == total_horizontal-1) begin
            //if (h_counter == total_horizontal-2) begin
                h_slow <= 0;
                count  <= 0;
            end else if (count == 4) begin
                count  <= 0;
                h_slow <= h_slow + 1;
            end else begin
                count <= count + 1;
            end
        end
    end


//vertical counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            v_counter <= 0;
            v_slow    <= 0;
            count2    <= 0;
        end else begin
            // Τρέχει μόνο στο τέλος κάθε γραμμής
            if (h_counter == total_horizontal-1) begin
                if (v_counter == total_vertical-1) begin
                    v_counter <= 0;
                    v_slow    <= 0;
                    count2    <= 0; 
                end else begin
                    v_counter <= v_counter + 1;

                    // 2) Update v_slow / count2 ΜΟΝΟ εδώ
                    if (count2 == 4) begin
                        count2 <= 0;
                        v_slow <= v_slow + 1;
                    end else begin
                        count2 <= count2 + 1;
                        // v_slow μένει ίδιο
                    end
                end

            end
        end
    end

    assign new_frame = (h_counter == active_drawing_h-1) && (v_counter == active_drawing_v-1);
endmodule 

