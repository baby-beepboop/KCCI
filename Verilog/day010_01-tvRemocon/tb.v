`timescale 1ns / 1ps

module tb;
    reg clk, rstn;
    reg [1:0] btn;
    wire [3:0] led;

    top dut (.clk(clk), .rstn(rstn), .up(btn[0]), .down(btn[1]), .ch(led));

    always #5 clk = ~clk;

    initial begin
        clk = 0; rstn = 0; btn = 2'b00;
        #100 rstn = 1;

        // CH0 -> CH1 (up)
        #200000 btn[0] = 1;
        #100000 btn[0] = 0;

        // CH1 -> CH2 (up)
        #1000000 btn[0] = 1;
        #100000 btn[0] = 0;

        // CH2 -> CH3 (up)
        #1000000 btn[0] = 1;
        #100000 btn[0] = 0;

        // CH3 -> CH4 (up)
        #1000000 btn[0] = 1;
        #100000 btn[0] = 0;

        // CH4 -> CH0 (up)
        #1000000 btn[0] = 1;
        #100000 btn[0] = 0;

        // CH0 -> CH4 (down)
        #1000000 btn[1] = 1;
        #100000 btn[1] = 0;

        #2000000 $finish;
    end

endmodule
