`timescale 1ns / 1ps

module tb;
    reg clk100Mhz, rst;
    reg [2:0] btnRaw;
    wire [15:13] led;

    top dut (.clk100Mhz(clk100Mhz), .rst(rst), .btnRaw(btnRaw), .led(led));

    always #5 clk100Mhz = ~clk100Mhz;

    initial begin
        clk100Mhz = 0; rst = 1; btnRaw = 3'b000;
        #100 rst = 0;

        // IDLE -> WAIT (btnRaw[0])
        #200000 btnRaw = 3'b001;
        #100000 btnRaw = 3'b000;

        // WAIT -> CNT (bntRaw[1])
        #1000000 btnRaw = 3'b010;
        #100000 btnRaw = 3'b000;

        // CNT -> StOP (btnRaw[1])
        #1000000 btnRaw = 3'b010;
        #100000 btnRaw = 3'b000;

        // STOP -> WAIT (btnRaw[2])
        #1000000 btnRaw = 3'b100;
        #100000 btnRaw = 3'b000;

        // WAIT -> CNT (btnRaw[1])
        #1000000 btnRaw = 3'b010;
        #100000 btnRaw = 3'b000;

        #2000000 $finish;
    end

endmodule
