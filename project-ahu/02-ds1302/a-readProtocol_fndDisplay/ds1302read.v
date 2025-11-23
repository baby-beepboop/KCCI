// ds1302read v1.0: DS1302 RTC 칩에서 초(Seconds) 데이터를 읽기
// Protocol: CE High -> Command(0x81) Write -> Data Read -> CE Low
module ds1302read(
    // 시스템 인터페이스
    input clk, rst,
    input en,                     // 읽기 동작 시작 트리거

    // DS1302 3-wire 인터페이스
    input      sclk,
    output reg ce,                // DS1302 Serial Clock, Chip Enable
    inout      dsData,            // DS1302 Bi-directional Data Line

    // 출력 데이터 인터페이스
    output reg [7:0] rtcData,     // 읽어온 시간 데이터
    output reg       dataValid    // 읽기 완료 신호
    );

    localparam [7:0] SEC_READ_ADDR = 8'h81;

    reg sclkDelay;
    wire sclkRising, sclkFalling;

    reg ioDir;               // dsData 방향 제어 (0: 입력/Z, 1: 출력)
    wire dataIn;             // dsData에서 읽어온 데이터
    reg dataOut;             // daData에 출력할 데이터

    reg [2:0] dataBitCnt;    // 전송/수신된 비트 카운터 (0-7)
    reg [7:0] shiftReg;

    localparam IDLE=0, START_CMD=1, SEND_ADDR_H=2, SEND_ADDR_L=3, TURN_IO=4, READ_DATA_H=5, READ_DATA_L=6, STOP_CMD=7;
    reg [3:0] cState, nState;

    // SCLK 1 clock 딜레이
    always @(posedge clk) begin
        sclkDelay <= sclk;
    end

    // SCLK 엣지 검출
    assign sclkRising = sclk & (~sclkDelay);
    assign sclkFalling = (~sclk) & sclkDelay;

    // dsData I/O (Tristate Buffer Control)
    assign dsData = ioDir ? dataOut : 1'bz;
    assign dataIn = dsData;

    // FSM
    always @(posedge clk or posedge rst) begin
        if (rst) cState <= IDLE;
        else cState <= nState;
    end

    always @(*) begin
        nState = cState;

        case (cState)
            IDLE:        if (en)         nState = START_CMD;
            START_CMD:                   nState = SEND_ADDR_H;
            SEND_ADDR_H: if (sclkRising) nState = SEND_ADDR_L;
            SEND_ADDR_L: begin
                if (sclkFalling) begin
                    if (dataBitCnt == 7) nState = TURN_IO;
                    else nState = SEND_ADDR_H;
                end
            end
            TURN_IO:                     nState = READ_DATA_H;
            READ_DATA_H: if (sclkRising) nState = READ_DATA_L;
            READ_DATA_L: begin
                if (sclkFalling) begin
                    if (dataBitCnt == 7) nState = STOP_CMD;
                    else nState = READ_DATA_H;
                end
            end
            STOP_CMD:                    nState = IDLE;
            default: nState = IDLE;
        endcase
    end

    // FSM 동작
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ce <= 0;
            ioDir <= 0;
            dataBitCnt <= 0;
            rtcData <= 0;
            dataValid <= 0;
            dataOut <= 0;
            shiftReg <= 0;
        end

        else begin
            dataValid <= 1'b0;

            case (cState)
                IDLE: begin
                    if (en) begin
                        shiftReg <= SEC_READ_ADDR;
                        ioDir <= 1'b1;
                        dataBitCnt <= 0;
                    end
                end

                // Protocol: CE High
                START_CMD: begin
                    ce <= 1'b1;
                end
                
                // Protocol: Command(0x81) Write (MSB first)
                SEND_ADDR_H: begin
                    if (sclkRising) begin
                        dataOut <= shiftReg[7];
                        shiftReg <= shiftReg << 1;
                    end
                end
                SEND_ADDR_L: begin
                    if (sclkFalling) begin
                        dataBitCnt <= dataBitCnt + 1;
                    end
                end
                TURN_IO: begin
                    ioDir <= 1'b0;
                    dataBitCnt <= 0;
                    shiftReg <= 0;
                end

                // Protocol: Data Read (LSB first)
                READ_DATA_H: begin
                    if (sclkRising) begin
                        shiftReg <= {dataIn, shiftReg[7:1]};
                    end
                end
                READ_DATA_L: begin
                    if (sclkFalling) begin
                        dataBitCnt <= dataBitCnt + 1;
                    end
                end

                // Protocol: CE Low
                STOP_CMD: begin
                    ce <= 1'b0;
                    ioDir <= 0;
                    rtcData <= shiftReg;
                    dataValid <= 1'b1;
                end
            endcase
        end
    end

endmodule
