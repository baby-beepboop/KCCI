module fsm(
    input clk, rst,

    input din,
    input en,

    output reg [15:0] dout
    );

    localparam IDLE=0, SHIFT=1, CHECK=2, OUT=3;
    reg [1:0] cState, nState;

    always @(posedge clk, posedge rst) begin
        if (rst) cState <= IDLE;
        else cState <= nState;
    end

    always @(*) begin
        nState = cState;

        case (cState)
            IDLE:  if (en) nState = SHIFT;
            SHIFT: nState = CHECK;
            CHECK: nState = OUT;
            OUT:   nState = IDLE;
        endcase
    end

    reg [6:0] shiftReg7;
    reg [1:0] twice;
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            shiftReg7 <= 0;
            twice <= 0;
            dout <= 0;
        end

        else begin
            case (cState)
                IDLE: dout <= 0;

                SHIFT: begin
                    shiftReg7 <= {shiftReg7[5:0], din};
                end

                CHECK: begin
                    case ({shiftReg7[1], din})
                        2'b00: twice <= 2'b01;
                        2'b11: twice <= 2'b10;
                        default: twice <= 2'b00;
                    endcase
                end

                OUT: begin
                    dout[6:0] <= shiftReg7;
                    dout[15:14] <= twice;
                    dout[13:7] <= 0;
                end
            endcase
        end
    end

endmodule
