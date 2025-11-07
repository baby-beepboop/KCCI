`timescale 1ns / 1ps

module tb_fsm1;
    reg clk, rstn;
    
    reg done;
    wire ack;

    fsm1 uut (.clk(clk), .rstn(rstn), .done(done), .ack(ack));

    always #5 clk = ~clk;

    initial begin
        clk = 0; rstn = 0; done = 0;
        #100 rstn = 1;

        // READY -> TRANS
        #200000 done = 1'b1;
        #100000;

        // TRNAS -> WRITE
        #1000000 done = 1'b0;
        #100000;

        // WRITE -> READ -> READY
        #1000000 done = 1'b1;
        #100000;

        #2000000 $finish;
    end

endmodule
