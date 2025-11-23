module top_ds1302(
    input clk, rst,

    output sclk, ce,
    inout  dsData,

    input [2:0] sw,
    output [15:0] led,
    output  [3:0] an,
    output  [6:0] seg,
    output        dp,

    input RsRx,
    output RsTx
    );

    wire tick1s, tick1ms;

    wire [7:0] secData, minData, hrsData, dateData, monData, dayData, yrData;

    wire [7:0] rxOut;

    sclkGen u_sclkGen (.clk100Mhz(clk), .rst(rst), .sclk(sclk));

    // DS1302 읽기 시작 트리거 생성 (1s 펄스)
    tickGen #(
        .CLK_FREQ(100_000_000),
        .TICK_FREQ(1)
    ) u_tick1sGen (.clk100Mhz(clk), .rst(rst), .tick(tick1s));
    // FND 스캔 펄스 생성 (1ms)
    tickGen #(
        .CLK_FREQ(100_000_000),
        .TICK_FREQ(1000)
    ) u_tick1msGen (.clk100Mhz(clk), .rst(rst), .tick(tick1ms));

    ds1302read u_rtcRead (.clk(clk), .rst(rst), .en(tick1s), .sclk(sclk), .ce(ce), .dsData(dsData),
                          .secData(secData), .minData(minData), .hrsData(hrsData),
                          .dateData(dateData), .monData(monData), .dayData(dayData), .yrData(yrData), .dataValid(rtcValid));

    fndCtrl u_fndCtrl (.clk(clk), .rst(rst), .tick(tick1ms), .mode(sw),
                       .yrData(yrData), .monData(monData), .dateData(dateData), .hrsData(hrsData), .minData(minData),
                       .an(an), .seg(seg), .dp(dp));

    top_uart u_uart (.clk(clk), .rst(rst),
                     .rtcSecData(secData), .rtcMinData(minData), .rtcHrsData(hrsData),
                     .rtcDateData(dateData), .rtcMonData(monData), .rtcDayData(dayData), .rtcYrData(yrData),
                     .rxIn(RsRx), .txOut(RsTx), .rxOut(rxOut), .led(led));

endmodule
