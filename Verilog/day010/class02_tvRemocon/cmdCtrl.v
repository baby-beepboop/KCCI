module cmdCtrl(
    input clk, rstn,
    input tick,

    input            up, down,
    output reg [3:0] ch
    );

    reg upPrev, downPrev;
    wire upRise = up & ~upPrev;
    wire downRise = down & ~downPrev;
    always @(posedge clk, negedge rstn) begin
        if (!rstn) upPrev <= 0;
        else upPrev <= up;
    end
    always @(posedge clk, negedge rstn) begin
        if (!rstn) downPrev <= 0;
        else downPrev <= down;
    end

    localparam [1:0] CH0=0, CH1=1, CH2=2, CH3=3;
    reg [1:0] cState, nState;

    always @(posedge clk, negedge rstn) begin
        if (!rstn) cState <= CH0;
        else cState <= nState;
    end

    always @(*) begin
        nState = cState;

        case (cState)
            CH0: if (upRise)        nState = CH1;
                 else if (downRise) nState = CH3;

            CH1: if (upRise)         nState = CH2;
                  else if (downRise) nState = CH0;

            CH2: if (upRise)        nState = CH3;
                 else if (downRise) nState = CH1;

            CH3: if (upRise)         nState = CH0;
                  else if (downRise) nState = CH2;

            default: nState = CH0;
        endcase
    end

    always @(*) begin
        case (cState)
            CH0: ch = 4'b0001;
            CH1: ch = 4'b0010;
            CH2: ch = 4'b0100;
            CH3: ch = 4'b1000;
            default: ch = 4'b0000;
        endcase
    end

endmodule
