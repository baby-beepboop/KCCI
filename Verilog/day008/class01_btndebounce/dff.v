module dff(
    input clk_8hz, rst,

    input d,
    output reg q
    //output reg qBar
    );

    always @(posedge clk_8hz, posedge rst) begin
        if (rst) begin
            q <= 0;
            //qBar <= 0;
        end

        else begin
            q <= d;
            //qBar <= !q;
        end
    end

endmodule
