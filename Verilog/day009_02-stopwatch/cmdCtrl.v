module cmdCtrl(
    input clk100Mhz, rst,
    input tick,

    input [2:0] btnDb,

    output             idle,
    output reg [15:13] led,
    output      [13:0] segData
    );

    localparam [1:0] IDLE=0, WAIT=1, CNT=2, STOP=3;
    reg [1:0] cState, nState;

    reg [2:0] btnPrev;
    wire [2:0] btnRise = btnDb & ~btnPrev;
    
    reg [8:0] stopCnt;
    wire stopTimeout = (stopCnt == 499);

    always @(posedge clk100Mhz, posedge rst) begin
        if (rst) btnPrev <= 0;
        else btnPrev <= btnDb;
    end

    always @(posedge clk100Mhz, posedge rst) begin
        if (rst) cState <= IDLE;
        else cState <= nState;
    end

    always @(*) begin
        nState = cState;

        case (cState)
            IDLE: if (btnRise[0]) nState = WAIT;

            WAIT: if (btnRise[1])      nState = CNT;
                  else if (btnRise[2]) nState = WAIT;

            CNT: if (btnRise[1])      nState = STOP;
                 else if (btnRise[2]) nState = WAIT;

            STOP: if (btnRise[1])      nState = CNT;
                  else if (btnRise[2]) nState = WAIT;
                  else if (stopTimeout) nState <= IDLE;

            default: nState = IDLE;
        endcase
    end

    always @(*) begin
        case (cState)
            IDLE: led[15:13] = 3'b000;
            WAIT: led[15:13] = 3'b100;
            CNT:  led[15:13] = 3'b010;
            STOP: led[15:13] = 3'b001;
            default: led[15:13] = 3'b000;
        endcase
    end

    reg [3:0] tickCnt;
    reg pulse;
    always @(posedge clk100Mhz, posedge rst) begin
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

    reg [13:0] secCnt;
    always @(posedge clk100Mhz, posedge rst) begin
        if (rst) begin
            secCnt <= 0;
        end

        else if (pulse) begin
            case (cState)
                WAIT: secCnt <= 0;
                CNT:  secCnt <= secCnt + 1;
            endcase
        end
    end

    assign segData = secCnt;

    always @(posedge clk100Mhz, posedge rst) begin
        if (rst) begin
            stopCnt <= 0;
        end

        else if (cState == STOP) begin
            if (pulse) begin
                if (stopCnt == 499) stopCnt <= 0;
                else stopCnt <= stopCnt + 1'b1;
            end
        end

        else begin
            stopCnt <= 0;
        end
    end

    assign idle = (cState == IDLE);

endmodule
