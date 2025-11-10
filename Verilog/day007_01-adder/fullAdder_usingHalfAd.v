module fullAdder(
    input a, b, cin,
    output sum, co
    );

    wire halfAd1_sum;
    wire halfAd1_co;
    wire halfAd2_co;

    halfAdder halfAd1 (
        .a(a),
        .b(b),
        .sum(halfAd1_sum),
        .co(halfAd1_co)
    );

    halfAdder halfAd2 (
        .a(halfAd1_sum),
        .b(cin),
        .sum(sum),
        .co(halfAd2_co)
    );

    assign co = halfAd1_co | halfAd2_co;
endmodule
