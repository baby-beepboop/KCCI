`timescale 1ns / 1ps

module tb;
    reg clk, rst;
    
    reg btn, s1, s2, key;
    
    wire [15:0] led;
    wire [3:0] an;
    wire [6:0] seg;

    top dut (.clk(clk), .rst(rst), .btn(btn), .s1(s1), .s2(s2), .key(key), .led(led), .an(an), .seg(seg));

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        btn = 0; s1 = 0; s2 = 0; key = 0;
        #20 rst = 0;

        // CW
        #50 s1 = 1; s2 = 0;
        #50 s1 = 1; s2 = 1;
        #50 s1 = 0; s2 = 1;
        #50 s1 = 0; s2 = 0;
        #100;

        #50 s1 = 1; s2 = 0;
        #50 s1 = 1; s2 = 1;
        #50 s1 = 0; s2 = 1;
        #50 s1 = 0; s2 = 0;
        #100;

        // CCW
        #50 s1 = 0; s2 = 1;
        #50 s1 = 1; s2 = 1;
        #50 s1 = 1; s2 = 0;
        #50 s1 = 0; s2 = 0;
        #100;

        #50 key = 1;
        #100 key = 0;

        #500 $finish;
    end

endmodule
