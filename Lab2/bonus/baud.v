module baud_controller(reset, clk, baud_select, sample_ENABLE);
    input reset, clk;
    input [2:0] baud_select;
    output reg sample_ENABLE;
    reg [14:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 15'd0;
            sample_ENABLE <= 1'b0;
        end else begin
            sample_ENABLE <= 1'b0;
            case (baud_select)
            
                3'b000: begin   //300*16 baud
                    if (counter >= 15'd20833) begin
                        counter <= 15'd0;
                        sample_ENABLE <= 1'b1;
                    end else begin
                        counter <= counter + 15'd1;
                    end
                end
                3'b001: begin  // 1200*16 baud
                    if (counter >= 15'd5208) begin
                        counter <= 15'd0;
                        sample_ENABLE <= 1'b1;
                    end else begin
                        counter <= counter + 15'd1;
                    end
                end
                3'b010: begin // 4800*16 baud
                    if (counter >= 15'd1302) begin
                        counter <= 15'd0;
                        sample_ENABLE <= 1'b1;
                    end else begin
                        counter <= counter + 15'd1;
                    end
                end
                3'b011: begin // 9600*16 baud
                    if (counter >= 15'd651) begin
                        counter <= 15'd0;
                        sample_ENABLE <= 1'b1;
                    end else begin
                        counter <= counter + 15'd1;
                    end
                end
                3'b100: begin // 19200*16 baud
                    if (counter >= 15'd325) begin
                        counter <= 15'd0;
                        sample_ENABLE <= 1'b1;
                    end else begin
                        counter <= counter + 15'd1;
                    end
                end
                3'b101: begin // 38400*16 baud
                    if (counter >= 15'd163) begin
                        counter <= 15'd0;
                        sample_ENABLE <= 1'b1;
                    end else begin
                        counter <= counter + 15'd1;
                    end
                end
                3'b110: begin // 57600*16 baud
                    if (counter >= 15'd108) begin
                        counter <= 15'd0;
                        sample_ENABLE <= 1'b1;
                    end else begin
                        counter <= counter + 15'd1;
                    end
                end
                3'b111: begin // 115200*16 baud
                    if (counter >= 15'd54) begin
                        counter <= 15'd0;
                        sample_ENABLE <= 1'b1;
                    end else begin
                        counter <= counter + 15'd1;
                    end
                end
                default: begin // Default to 9600 baud
                    if (counter >= 15'd5207) begin
                        counter <= 15'd0;
                        sample_ENABLE <= 1'b1;
                    end else begin
                        counter <= counter + 15'd1;
                    end
                end
            endcase
        end
    end

endmodule