module top(
    input clk, rst,

    input btn,
    input s1, s2, key,

    output [15:0] led,
    output  [3:0] an,
    output  [6:0] seg
    );

    wire tick;
    wire btnDb;
    wire s1Db, s2Db, keyDb;

    tickGen #(
        .CLK_FREQ(100_000_000),
        .TICK_FREQ(5_000)          // Debounce delay = 2ms (tick = 0.2ms)
    ) u_tick (.clk100Mhz(clk), .rst(rst), .tick(tick));

    debounceBtn u_debounceBtn (.clk(clk), .rst(rst), .tick(tick), .btnRaw(btn), .btnDb(btnDb));
    debounceRotary u_debounceRotary (.clk(clk), .rst(rst), .tick(tick), .btnRaw({key, s2, s1}), .btnDb({keyDb, s2Db, s1Db}));

    rotary u_rotary (.clk(clk), .rst(rst), .s1(s1Db), .s2(s2Db), .key(keyDb), .led(led));

    fnd u_fnd (.clk(clk), .rst(rst), .tick(tick), .din(led), .an(an), .seg(seg));

endmodule
