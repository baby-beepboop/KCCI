// ds1302write v1.1: DS1302 RTC 칩에 1바이트 데이터를 쓰기
//    UPDATE: top 모듈에서 Tri-state 제어
// Protocol: CE High -> Command Write -> Data Write -> CE Low
module ds1302write(
    // 시스템 인터페이스
    input clk, rst,

    input       en,              // 쓰기 요청 신호
    input [7:0] addr,            // 쓰기 할 주소
    input [7:0] dataIn,            // 쓸 데이터

    // DS1302 3-wire 인터페이스
    input      sclk,             // DS1302 Serial Clock
    output reg ce,               // DS1302 Chip Enable

    output reg dataOut,          // DS1302 Bi-directional Data Line (Output Only)
    output reg ioDir,          // 1: 출력 모드, 0: 대기

    // 출력 인터페이스
    output reg done              // 쓰기 완료 신호
    );

    reg sclkDelay;
    wire sclkRising, sclkFalling;

    localparam [3:0] IDLE=0, START=1, SEND_CMD=2, SEND_DATA=3, STOP=4;
    reg [3:0] cState, nState;

    reg [3:0] bitCnt;
    reg [7:0] shiftReg;

    // SCLK 1 clock 딜레이
    always @(posedge clk) begin
        sclkDelay <= sclk;
    end

    // SCLK 엣지 검출
    assign sclkRising = sclk & (~sclkDelay);
    assign sclkFalling = (~sclk) & sclkDelay;

    // dsData I/O (Tristate Buffer Control)
    // 쓰기 모듈은 항상 출력만 하므로 ioDir은 항상 1
    assign dsData = (ce) ? dataOut : 1'bz;

    // FSM 상태 전이
    always @(posedge clk or posedge rst) begin
        if (rst) cState <= IDLE;
        else cState <= nState;
    end
    
    always @(*) begin
        nState = cState;

        case (cState)
            IDLE:      if (en)                          nState = START;
            START:                                       nState = SEND_CMD;
            SEND_CMD:  if (sclkFalling && (bitCnt == 7)) nState = SEND_DATA;
            SEND_DATA: if (sclkFalling && (bitCnt == 7)) nState = STOP;
            STOP:                                        nState = IDLE;
            default: nState = IDLE;
        endcase
    end

    // FSM 동작
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ce <= 0;
            ioDir <= 0;
            bitCnt <= 0;
            shiftReg <= 0;
            dataOut <= 0;
            done <= 0;
        end

        else begin
            done <= 1'b0;

            case (cState)
                IDLE: begin
                    ce <= 1'b0;
                    ioDir <= 1'b0;
                    bitCnt <= 0;
                    dataOut <= 0;
                    if (en) begin
                        shiftReg <= addr;    // 주소 로드
                    end
                end

                // Protocol: CE High
                START: begin
                    ce <= 1'b1;
                    ioDir <= 1'b1;
                    dataOut <= shiftReg[0];    // 첫 비트(LSB) 준비
                end
                SEND_CMD: begin
                    if (sclkFalling) begin
                        if (bitCnt == 7) begin
                            bitCnt <= 0;
                            shiftReg <= dataIn;      // 다음에 보낼 데이터 로드
                            dataOut <= dataIn[0];    // 데이터의 첫 비트(LSB) 준비
                        end

                        // Protocol: Command Write (LSB first)
                        else begin
                            bitCnt <= bitCnt + 1;
                            shiftReg <= shiftReg >> 1;
                            dataOut <= shiftReg[1];       // 다음 비트(현재 1번 비트) 출력
                        end
                    end
                end

                SEND_DATA: begin
                    if (sclkFalling) begin
                        // Protocol: CE Low
                        if (bitCnt == 7) begin
                            bitCnt <= 0;
                            ce <= 1'b0;
                            ioDir <= 1'b0;
                            done <= 1'b1;
                        end

                        // Protocol: Data Write (LSB first)
                        else begin
                            bitCnt <= bitCnt + 1;
                            shiftReg <= shiftReg >> 1;
                            dataOut <= shiftReg[1];
                        end
                    end
                end
                
                STOP: begin
                    ce <= 0;
                    ioDir <= 0;
                    done <= 0;
                end
            endcase
        end
    end

endmodule
