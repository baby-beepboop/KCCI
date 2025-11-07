module shiftRegister(
    input clk, rst,

    input din,
    input en,

    output           dout,
    output reg [6:0] shiftReg7
    );

    always @(posedge clk, posedge rst) begin
        if (rst) shiftReg7 <= 0;
        
        else if (en) begin
            shiftReg7 <= {shiftReg7[5:0], din};
        end
    end

    assign dout = (shiftReg7 == 7'b1010111);

endmodule
