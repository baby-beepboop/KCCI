module top(
    input clk_100Mhz, rst,

    input btnC,
    output [1:0] led
    );

    wire debouncedBtn;
    wire tick;

    debounce u_debounce (.clk_100Mhz(clk_100Mhz), .rst(rst), .btnC(btnC), .debouncedBtn(debouncedBtn));
    ledToggle u_toggle (.clk(debouncedBtn), .led(led));

    tickGen #(
        .CLK_FREQ(100_000_000),
        .TICK_FREQ(1000)
    ) u_tick (.clk_100Mhz(clk_100Mhz), .rst(rst), .tick(tick));
    ledTickToggle u_tickToggle (.tick(tick), .rst(rst), .led(led));

endmodule
