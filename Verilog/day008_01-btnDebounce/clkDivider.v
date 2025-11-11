module clkDivider(
    input clk_100Mhz, rst,

    output reg clk_8hz
    );

    localparam HALF_PERIOD = 625_000;                        // 625,000 cycles
    localparam CNT_WIDTH = 20;                               // ceil(log2(HALF_PERIOD)) = 20
    localparam [CNT_WIDTH-1:0] CNT_MAX = HALF_PERIOD - 1;

    //reg [$clog2(1250000)-1:0] cnt = 0;
    reg [CNT_WIDTH-1:0] cnt;

    always @(posedge clk_100Mhz, posedge rst) begin
        if (rst) begin
            cnt <= 0;
            clk_8hz <= 0;
        end
        
        else begin
            //if (cnt == (1_250_000/2)-1)
            if (cnt == CNT_MAX) begin
                cnt <= 0;
                clk_8hz <= ~clk_8hz;     // TOGGLE!
            end
            else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

endmodule
