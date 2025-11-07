`timescale 1ns / 1ps

module tb_fullAdder_usingHalfAd;
    reg a, b, cin;
    wire sum, co;

    fullAdder_usingHalfAd dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .co(co)
    );

    initial begin
            a = 0; b = 0; cin = 0;
        #10 a = 0; b = 0; cin = 1;
        #10 a = 0; b = 1; cin = 0;
        #10 a = 0; b = 1; cin = 1;
        #10 a = 1; b = 0; cin = 0;
        #10 a = 1; b = 0; cin = 1;
        #10 a = 1; b = 1; cin = 0;
        #10 a = 1; b = 1; cin = 1;
        #10 $finish;
    end
endmodule
