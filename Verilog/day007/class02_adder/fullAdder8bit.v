module fullAdder8bit(
    input [7:0] a, b,
    input cin,

    output [7:0] sum,
    output co
    );

    wire fa4bit0_co;

    fullAdder4bit fa4bit0 (.a(a[3:0]), .b(b[3:0]), .cin(1'b0), .sum(sum[3:0]), .co(fa4bit0_co));
    fullAdder4bit fa4bit1 (.a(a[7:4]), .b(b[7:4]), .cin(fa4bit0_co), .sum(sum[7:4]), .co(co));
endmodule
