module top(
    input clk_100Mhz, rst,

    input btn_raw,
    output led
    );

    wire tick;
    wire btn_db;

    tickGen #(
        .CLK_FREQ(100_000_000),
        .TICK_FREQ(1000)
    ) u_tick (.clk_100Mhz(clk_100Mhz), .rst(rst), .tick(tick));
    
    debounce u_debounce (.clk_100Mhz(clk_100Mhz), .rst(rst), .tick(tick), .btn_raw(btn_raw), .btn_db(btn_db));

    toggle u_toggle (.clk_100Mhz(clk_100Mhz), .rst(rst), .btn(btn_db), .led(led));

endmodule
