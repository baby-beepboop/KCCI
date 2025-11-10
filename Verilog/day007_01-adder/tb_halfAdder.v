`timescale 1ns / 1ps

module tb_halfAdder;
    reg a, b;
    wire sum, co;

    halfAdder dut (
        .a(a),
        .b(b),
        .sum(sum),
        .co(co)
    );

    initial begin
        a = 1'b0;
        b = 1'b0;

        #10;
        a = 1'b0;
        b = 1'b1;

        #10;
        a = 1'b1;
        b = 1'b0;

        #10;
        a = 1'b1;
        b = 1'b1;

        #10 $finish;
    end
endmodule
