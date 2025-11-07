`timescale 1ns / 1ps

module tb_fsm2;
    reg clk, rstn;

    reg go, ws;
    wire rd, ds;

    fsm2 uut (.clk(clk), .rstn(rstn), .go(go), .ws(ws), .rd(rd), .ds(ds));

    always #5 clk = ~clk;

    initial begin
        clk = 0; rstn = 0; go = 0; ws = 0;
        #100 rstn = 1;

        // IDLE -> READ
        #200000 go = 1'b1;
        #100000 go = 1'b0;

        // READ -> DLY
        #1000000 ws = 1'b1;
        #100000;
        #10;

        // DLY -> DONE
        #1000000 ws = 1'b0;
        #100000;

        #2000000 $finish;
    end

endmodule
