`timescale 1ns / 1ps

module tb_fsm;
    reg clk, rst;

    reg btnU, btnD;
    wire [15:0] led;

    top_fsm dut (.clk(clk), .rst(rst), .btnU(btnU), .btnD(btnD), .led(led));

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1; btnU = 0; btnD = 0;
        #100 rst = 0;

        // 1
        btnU = 1'b1; #100000;
        btnU = 1'b0; #50000;

        // 0
        btnD = 1'b1; #100000;
        btnD = 1'b0; #50000;

        // 0
        btnD = 1'b1; #100000;
        btnD = 1'b0; #50000;

        // 1
        btnU = 1'b1; #100000;
        btnU = 1'b0; #50000;

        // 1
        btnU = 1'b1; #100000;
        btnU = 1'b0; #50000;

        // 0
        btnD = 1'b1; #100000;
        btnD = 1'b0; #50000;

        #2000000 $finish;
    end

endmodule
