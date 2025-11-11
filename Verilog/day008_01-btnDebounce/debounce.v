module debounce(
    input clk_100Mhz, rst,
    
    input btnC,
    output debouncedBtn
    );

    wire clk;
    wire dff0_q, dff1_q;

    clkDivider u_clkDivider (.clk_100Mhz(clk_100Mhz), .rst(rst), .clk_8hz(clk));

    dff u_dff0 (.clk_8hz(clk), .rst(rst), .d(btnC), .q(dff0_q));
    dff u_dff1 (.clk_8hz(clk), .rst(rst), .d(dff0_q), .q(dff1_q));

    assign debouncedBtn = dff0_q & ~dff1_q;

endmodule
