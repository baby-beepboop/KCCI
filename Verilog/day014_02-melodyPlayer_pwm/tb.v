`timescale 1ns / 1ps

module tb;
    reg clk, rst;
    reg btnL, btnR;
    wire buzz;

    top dut (.clk(clk), .rst(rst), .btnL(btnL), .btnR(btnR), .buzz(buzz));

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1; btnL = 0; btnR = 0; #100;
        rst = 0; #1000;

        // Power on
        $display("[%0t] >>> bntL pressed (Power on)", $time);
        btnL = 1; #50_000;
        btnL = 0;
        $display("[%0t] >>> bntL released", $time);

        #5_000;

        // Open cover
        $display("[%0t] >>> bntR pressed (Open cover)", $time);
        btnR = 1; #50_000;
        btnR = 0;
        $display("[%0t] >>> bntR released", $time);

        #5_000;

        $display("[%0t] >>> Simulation finished", $time);
        $finish;
    end

    initial begin
        $monitor("[%0t] rst=%b btnL=%b btnR=%b buzz=%b", $time, rst, btnL, btnR, buzz);
    end

endmodule
