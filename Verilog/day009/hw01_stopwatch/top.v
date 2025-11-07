module top(
    input clk100Mhz, rst,

    input [2:0] btnRaw,

    output [15:13] led,
    output   [3:0] an,
    output   [6:0] seg,
    output         dp
    );

    wire tick;
    wire [2:0] btnDb;
    wire idle;
    wire [1:0] state;
    wire [13:0] segData;
    
    tickGen #(
        .CLK_FREQ(100_000_000),
        .TICK_FREQ(1000)
    ) u_tick (.clk100Mhz(clk100Mhz), .rst(rst), .tick(tick));

    debounce u_debounce (.clk100Mhz(clk100Mhz), .rst(rst), .tick(tick), .btnRaw(btnRaw), .btnDb(btnDb));

    cmdCtrl u_cmdCtrl (.clk100Mhz(clk100Mhz), .rst(rst), .tick(tick), .btnDb(btnDb),
                       .idle(idle), .led(led), .segData(segData));

    fndCtrl u_fndCtrl (.clk100Mhz(clk100Mhz), .rst(rst), .tick(tick), .segData(segData), .idle(idle),
                       .an(an), .seg(seg), .dp(dp));

endmodule
