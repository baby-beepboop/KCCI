module top(
    input clk_100Mhz, rst,

    input [2:0] btnRaw,
    input [7:0] sw,

    output [15:0] led,
    output  [3:0] an,
    output  [7:0] seg
    );

    wire tick;
    wire  [2:0] btnDb;
    wire [13:0] segData;

    tickGen #(
        .CLK_FREQ(100_000_000),
        .TICK_FREQ(1000)
    ) u_tick (.clk_100Mhz(clk_100Mhz), .rst(rst), .tick(tick));

    debounce u_debounce (.clk_100Mhz(clk_100Mhz), .rst(rst), .tick(tick), .btnRaw(btnRaw), .btnDb(btnDb));

    cmdCtrl u_cmdCtrl (.clk_100Mhz(clk_100Mhz), .rst(rst), .tick(tick), .btnDb(btnDb), .sw(sw), .led(led), .segData(segData));

    fndCtrl u_fndCtrl (.clk_100Mhz(clk_100Mhz), .rst(rst), .tick(tick), .segData(segData), .an(an), .seg(seg));
    
endmodule
