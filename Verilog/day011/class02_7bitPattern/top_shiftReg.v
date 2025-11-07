module top_shiftReg(
    input clk, rst,

    input btnU, btnD,
    output [7:0] led
    );

    wire tick;
    wire btnUdb, btnDdb;

    tickGen #(
        .CLK_FREQ(100_000_000),
        .TICK_FREQ(1000)
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
    wire din = btnURise? 1'b1 : 1'b0;
    
    shiftRegister u_shiftRegister (.clk(clk), .rst(rst), .din(din), .en(en), .dout(led[0]), .shiftReg7(led[7:1]));

endmodule
