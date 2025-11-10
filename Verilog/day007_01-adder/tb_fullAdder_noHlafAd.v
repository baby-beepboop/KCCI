`timescale 1ns / 1ps

module tb_fullAdder_noHalfAd;
    reg [2:0] sw;
    wire [1:0] led;

    fullAdder_noHalfAd uut (
        .sw(sw),
        .led(led)
    );

    initial begin
        sw[0] = 0;
        sw[1] = 0;
        sw[2] = 0;

        #10;
        sw[0] = 0;
        sw[1] = 0;
        sw[2] = 1;

        #10;
        sw[0] = 0;
        sw[1] = 1;
        sw[2] = 0;

        #10;
        sw[0] = 0;
        sw[1] = 1;
        sw[2] = 1;

        #10;
        sw[0] = 1;
        sw[1] = 0;
        sw[2] = 0;

        #10;
        sw[0] = 1;
        sw[1] = 0;
        sw[2] = 1;

        #10;
        sw[0] = 1;
        sw[1] = 1;
        sw[2] = 0;

        #10;
        sw[0] = 1;
        sw[1] = 1;
        sw[2] = 1;

        #10 $finish;
    end
endmodule
