module fullAdder_noHalfAd(
    input [2:0] sw,
    output [1:0] led
    );

    assign led[0] = (sw[0] ^ sw[1]) ^ sw[2];
    assign led[1] = ((sw[0] ^ sw[1]) & sw[2]) | (sw[0] & sw[1]);
endmodule
