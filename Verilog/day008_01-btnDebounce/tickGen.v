module tickGen(
    input clk_100Mhz, rst,

    output reg tick
    );

    parameter CLK_FREQ = 100_000_000;
    parameter TICK_FREQ = 1000;

    localparam TICK_CNT = CLK_FREQ / TICK_FREQ;               // 100_000_000 / 1000 = 100_000
    localparam TICK_WIDTH = 16;                               // ceil(log2(TICK_CNT)) = 16
    localparam [TICK_WIDTH-1:0] TICK_MAX = TICK_CNT - 1;

    reg [TICK_WIDTH-1:0] tickCnt;

    always @(posedge clk_100Mhz, posedge rst) begin
        if (rst) begin
            tickCnt <= 0;
            tick <= 0;
        end

        else begin
            if (tickCnt == TICK_MAX) begin
                tickCnt <= 0;
                tick <= 1'b1;
            end
            else begin
                    tickCnt <= tickCnt + 1'b1;
                    tick <= 1'b0;
            end
        end
    end

endmodule
