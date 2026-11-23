
module tm_choice (input [7:0] data_in, output reg [8:0] q_m);
    integer i;
    reg signed [4:0] N1D,N0D;
    
    always @(*) begin
        N1D = 5'd0;  
        for( i = 0; i<8; i = i + 1) begin
            N1D = N1D + data_in[i];
        end
        N0D = 5'd8 - N1D;

        if ((N1D > 4) || (N1D == 4 && data_in[0] == 1'b0)) begin
            //option2
            q_m[0]= data_in[0];
            for (i = 1; i < 8; i = i + 1) begin
                q_m[i] = ~(q_m[i-1] ^ data_in[i]);
            end
            q_m[8] = 1'b0;
        end else begin
            //option 1
            q_m[0]= data_in[0];
            for (i = 1; i < 8; i = i + 1) begin
                q_m[i] = q_m[i-1] ^ data_in[i];
            end
            q_m[8] = 1'b1;
        end
    end

endmodule
