// txData v1.0: 7가지 RTC 데이터를 순차적으로 txCore에 전송
module txData(
    input clk, rst,

    // RTC 입력 데이터
    input       rtcValid,
    input [7:0] secData, minData, hrsData, dateData, monData, dayData, yrData,

    // UART Tx Core Handshake
    input busy, done,

    // UART Tx Core 출력
    output reg       en,
    output reg [7:0] data
    );
    
    localparam [3:0] IDLE=0, TX_SEC=1, TX_MIN=2, TX_HRS=3, TX_DATE=4, TX_MON=5, TX_DAY=6, TX_YR=7, TX_DONE=8;
    reg [3:0] cState, nState;

    // FSM
    always @(posedge clk or posedge rst) begin
        if (rst) cState <= IDLE;
        else cState <= nState;
    end

    always @(*) begin
        nState = cState;

        case (cState)
            IDLE:    if (rtcValid) nState = TX_SEC;
            TX_SEC:  if (done)     nState = TX_MIN;
            TX_MIN:  if (done)     nState = TX_HRS;
            TX_HRS:  if (done)     nState = TX_DATE;
            TX_DATE: if (done)     nState = TX_MON;
            TX_MON:  if (done)     nState = TX_DAY;
            TX_DAY:  if (done)     nState = TX_YR;
            TX_YR:   if (done)     nState = TX_DONE;
            TX_DONE: if (!busy)    nState = IDLE;
            default: nState = IDLE;
        endcase
    end

    // 출력 신호
    always @(*) begin
        en = 0;
        data = 0;

        case (cState)
            TX_SEC:  begin en = 1'b1; data = secData; end
            TX_MIN:  begin en = 1'b1; data = minData; end
            TX_HRS:  begin en = 1'b1; data = hrsData; end
            TX_DATE: begin en = 1'b1; data = dateData; end
            TX_MON:  begin en = 1'b1; data = monData; end
            TX_DAY:  begin en = 1'b1; data = dayData; end
            TX_YR:   begin en = 1'b1; data = yrData; end
        endcase
    end

endmodule
