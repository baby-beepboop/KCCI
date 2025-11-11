module buzzNote(
    input clk, rst,

    input [4:0] noteSel,    // 0: 도, 1: 레, 2: 미, 3: 솔, 4: 라
    output reg noteOut
    );

    wire en;
    assign en = |noteSel;

    reg [31:0] halfPeriod;
    always @(*) begin
        if (noteSel[4])      halfPeriod = 227270;    // 라 (220.000 Hz)
        else if (noteSel[3]) halfPeriod = 255100;    // 솔 (195.998 Hz)
        else if (noteSel[2]) halfPeriod = 303380;    // 미 (164.814 Hz)
        else if (noteSel[1]) halfPeriod = 340530;    // 레 (146.832 Hz)
        else                 halfPeriod = 382234;    // 도 (130.813 Hz)
    end

    reg [31:0] cnt;
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            cnt <= 0;
            noteOut <= 0;
        end

        else if (en) begin
            if (cnt >= halfPeriod - 1) begin
                cnt <= 0;
                noteOut <= ~noteOut;
            end
            else begin
                cnt <= cnt + 1;
            end
        end
        
        else begin
            cnt <= 0;
            noteOut <= 0;
        end
    end

endmodule
