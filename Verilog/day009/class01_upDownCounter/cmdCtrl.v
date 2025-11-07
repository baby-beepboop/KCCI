module cmdCtrl(
    input clk_100Mhz, rst,
    input tick,

    input [2:0] btnDb,
    input [7:0] sw,

    output reg [15:0] led,
    output     [13:0] segData
    );

    localparam [1:0] IDLE=0, UP=1, DOWN=2, SW_READ=3;
    reg [1:0] cState, nState;

    reg [3:0] tickCnt;
    reg pulse;

    reg [13:0] secCnt;

    always @(posedge clk_100Mhz, posedge rst) begin
        if (rst) begin
            cState <= IDLE;
        end
        else begin
            cState <= nState;
        end
    end

    always @(*) begin
        nState = cState;

        case (cState)
            IDLE:    if (btnDb[0]) nState = UP;
            UP:      if (btnDb[0]) nState = DOWN;
            DOWN:    if (btnDb[0]) nState = SW_READ;
            SW_READ: if (btnDb[0]) nState = UP;
            default: nState = IDLE;
        endcase
    end

    always @(*) begin
        case (cState)
            IDLE:    led[15:13] = 3'b000;
            UP:      led[15:13] = 3'b100;
            DOWN:    led[15:13] = 3'b010;
            SW_READ: led[15:13] = 3'b001;
            default: led[15:13] = 3'b000;
        endcase
    end

    always @(posedge clk_100Mhz, posedge rst) begin
        if (rst) begin
            tickCnt <= 0;
            pulse <= 0;
        end
        
        else if (tick) begin
            if (tickCnt == 9) begin
                tickCnt <= 0;
                pulse <= 1'b1;                // 10ms마다 1 clock 펄스
            end
            else begin
                tickCnt <= tickCnt + 1'b1;
                pulse <= 1'b0;
            end
        end

        else begin
            pulse <= 1'b0;
        end
    end

    always @(posedge clk_100Mhz, posedge rst) begin
        if (rst) begin
            secCnt <= 0;
        end

        else if (pulse) begin
            case (cState)
                UP:      secCnt <= secCnt + 1;
                DOWN:    secCnt <= secCnt - 1;
                SW_READ: secCnt <= sw;
            endcase
        end
    end

    assign segData = secCnt;

endmodule
