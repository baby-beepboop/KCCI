module top_fsm(
    input clk, rst,

    input btnU, btnD,
    output [15:0] led
    );

    wire tick;
    wire btnUdb, btnDdb;

    tickGen #(
        .CLK_FREQ(100_000_000),
        .TICK_FREQ(100_000_000)
    ) u_tick (.clk100Mhz(clk), .rst(rst), .tick(tick));

    debounce u_debounce (.clk(clk), .rst(rst), .tick(tick), .btnRaw({btnU, btnD}), .btnDb({btnUdb, btnDdb}));

    reg [1:0] btnPrev;
    always @(posedge clk, posedge rst) begin
        if (rst) btnPrev <= 0;
        else btnPrev <= {btnUdb, btnDdb};
    end
    wire btnURise = btnUdb & ~btnPrev[1];
    wire btnDRise = btnDdb & ~btnPrev[0];

    wire en = btnURise | btnDRise;
    reg din;
    always @(posedge clk, posedge rst) begin
        if (rst) din <= 0;
        else if (btnURise) din <= 1'b1;
        else if (btnDRise) din <= 1'b0;
    end
    
    fsm u_fsm (.clk(clk), .rst(rst), .din(din), .en(en), .dout(led));

endmodule
