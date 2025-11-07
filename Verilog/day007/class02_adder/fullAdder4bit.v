module fullAdder4bit(
    input [3:0] a, b,
    input cin,

    output [3:0] sum,
    output co
    );

    wire fa0_co, fa1_co, fa2_co;

    fullAdder_usingHalfAd fa0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .co(fa0_co));
    fullAdder_usingHalfAd fa1 (.a(a[1]), .b(b[1]), .cin(fa0_co), .sum(sum[1]), .co(fa1_co));
    fullAdder_usingHalfAd fa2 (.a(a[2]), .b(b[2]), .cin(fa1_co), .sum(sum[2]), .co(fa2_co));
    fullAdder_usingHalfAd fa3 (.a(a[3]), .b(b[3]), .cin(fa2_co), .sum(sum[3]), .co(co));
endmodule
