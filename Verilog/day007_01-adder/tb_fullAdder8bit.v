`timescale 1ns / 1ps

module tb_fullAdder8bit;
    reg [7:0] a, b;
    reg cin;

    wire [7:0] sum;
    wire co;

    fullAdder8bit dut (.a(a), .b(b), .cin(cin), .sum(sum), .co(co));
    
    initial begin
            a = 0; b = 0; cin = 0;
        #10 a = 8'b0000_0011; b = 8'b0000_0001;    // sum = 0000_0011
        #10 a = 8'b0000_1111; b = 8'b0000_0001;    // sum = 0001_0000
        #10 a = 8'b0000_1111; b = 8'b0010_0001;    // sum = 0011_0000
        #10 a = 8'b0100_1111; b = 8'b1110_0001;    // sum = 1_0011_0000
        #10 $finish;
    end
endmodule
