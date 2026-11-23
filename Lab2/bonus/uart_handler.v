module uart_handler(clk,reset,Tx_address,send,Tx_BUSY,Rx_address,vld,ERROR,Rx_FERROR,Rx_PERROR,dp);
    input clk,reset,send,Tx_BUSY,vld,Rx_FERROR,Rx_PERROR;
    output reg [3:0] Tx_address, Rx_address;
    output reg ERROR;
    output dp;

    always@(posedge clk or posedge reset) begin
        if(reset)
            Tx_address <= 4'b1111;
        else if(send && !Tx_BUSY)
            Tx_address <= Tx_address+1;

    end

    always@(posedge clk or posedge reset) begin
        if(reset)
            Rx_address <= 4'b0000;
        else if(vld)
            Rx_address <= Rx_address+1; 
    end

    //ERROR LOGIC
    always@(posedge clk or posedge reset)begin
        if(reset) ERROR<=0;
        else if(Rx_FERROR || Rx_PERROR) ERROR<=1;
    end
    assign dp=!ERROR; //turn all dp on when ERROR

endmodule