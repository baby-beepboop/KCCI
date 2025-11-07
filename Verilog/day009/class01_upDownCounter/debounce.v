module debounce(
    input clk_100Mhz, rst,
    input tick,
    
    input      [2:0] btnRaw,
    output reg [2:0] btnDb
    );

    localparam CNT_MAX = 10;    // 안정에 필요한 연속 tick 수 (10ms)

    reg [3:0] cnt;
    always @(posedge clk_100Mhz, posedge rst) begin
        if (rst) begin
            cnt <= 0;
            btnDb <= 0;
        end

        else if (tick) begin
            if (btnRaw == btnDb) begin
                cnt <= 0;
            end

            else begin
                cnt <= cnt + 1'b1;

                if (cnt >= CNT_MAX-1) begin    // 10ms가 지나면 debouncing
                    btnDb <= btnRaw;
                    cnt <= 0;
                end
            end
        end
    end

endmodule
