module top(
    input clk, rst,

    input btnU, btnL, btnC, btnR, btnD,    // 도, 레, 미, 솔, 라
    
    output       buzz,
    output [1:0] led
    );

    wire tick;
    wire btnUdb, btnLdb, btnCdb, btnRdb, btnDdb;

    tickGen #(
        .CLK_FREQ(100_000_000),
        .TICK_FREQ(1000)
    ) u_tick (.clk100Mhz(clk), .rst(rst), .tick(tick));

    debounce u_debounce (.clk(clk), .rst(rst), .tick(tick), .btnRaw({btnD, btnR, btnC, btnL, btnU}),
                         .btnDb({btnDdb, btnRdb, btnCdb, btnLdb, btnUdb}));

    buzzNote u_buzzNote (.clk(clk), .rst(rst), .noteSel({btnDdb, btnRdb, btnCdb, btnLdb, btnUdb}), .noteOut(buzz));

endmodule
