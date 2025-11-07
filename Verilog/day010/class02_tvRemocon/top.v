module top(
    input clk, rstn,

    input up, down,
    output [3:0] ch
    );

    wire tick;
    wire upDb, downDb;

    tickGen #(
        .CLK_FREQ(100_000_000),
        .TICK_FREQ(100_000)
    ) u_tick (.clk100Mhz(clk), .rstn(rstn), .tick(tick));

    debounce u_debounce (.clk(clk), .rstn(rstn), .tick(tick), .btnRaw({down, up}), .btnDb({downDb, upDb}));

    cmdCtrl u_cmdCtrl (.clk(clk), .rstn(rstn), .tick(tick), .up(upDb), .down(downDb), .ch(ch));

endmodule
