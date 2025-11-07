`timescale 1ns / 1ps

module tb_fullAdder4bit;
    reg [3:0] a, b;
    reg cin;

    wire [3:0] sum;
    wire co;

    fullAdder4bit dut (.a(a), .b(b), .cin(cin), .sum(sum), .co(co));

    initial begin
            a = 0; b = 0; cin = 0;
        #10 a = 4'b0001; b = 4'b0001;
        #10 a = 4'b0011; b = 4'b0011;
        #10 a = 4'b0111; b = 4'b0011;
        #10 a = 4'b1111; b = 4'b1011;
        #10 $finish;
    end
endmodule
