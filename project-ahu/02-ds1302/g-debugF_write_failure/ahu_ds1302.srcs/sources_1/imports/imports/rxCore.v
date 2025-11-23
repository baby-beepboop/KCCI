module rxCore #(
    parameter BPS = 9600
)(
    input clk, rst,

    input data,

    output reg       done,
    output reg [7:0] rxOut
    );

    localparam CLKS_PER_SAMPLE = 100_000_000 / (BPS * 16);    // = 651
    reg [$clog2(CLKS_PER_SAMPLE)-1:0] sampleCnt;
    reg sampleTick;

    reg [3:0] bitSampleIdx, dataBitIdx;

    localparam IDLE=0, START=1, DATA=2, STOP=3;
    reg [1:0] cState, nState;

    reg [7:0] dataReg;

    // 샘플링 tick
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sampleCnt <= 0;
            sampleTick <= 0;
        end
        else begin
            if ((cState == IDLE) && (data == 1'b0)) begin
                sampleCnt <= 0;
                sampleTick <= 0;
            end

            else begin
                if (sampleCnt == CLKS_PER_SAMPLE - 1) begin
                    sampleCnt <= 0;
                    sampleTick <= 1'b1;
                end
                else begin
                    sampleCnt <= sampleCnt + 1;
                    sampleTick <= 1'b0;
                end
            end
        end
    end

    // 샘플 인덱스 & 수신 데이터(data) 비트 인덱스 카운터
/*
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bitSampleIdx <= 0;
            dataBitIdx <= 0;
        end
        else begin
            if (cState != nState) begin
                bitSampleIdx <= 0;
                if (nState == DATA) begin
                    dataBitIdx <= 0;
                end
            end

            else if (sampleTick) begin
                bitSampleIdx <= bitSampleIdx + 1;
                if ((cState == DATA) && (bitSampleIdx == 15)) begin
                    bitSampleIdx <= 0;
                    dataBitIdx <= dataBitIdx + 1;
                end
            end
        end
    end
*/

    // FSM 상태 전이
    always @(posedge clk or posedge rst) begin
        if (rst) cState <= IDLE;
        else     cState <= nState;
    end

    always @(*) begin
        nState = cState;

        case (cState)
            IDLE:  if (data == 1'b0)                                            nState = START;
            START: if (sampleTick && (bitSampleIdx == 7))                       nState = DATA;
            DATA:  if (sampleTick && (bitSampleIdx == 15) && (dataBitIdx == 8)) nState = STOP;
            STOP:  if (sampleTick && (bitSampleIdx == 15))                      nState = IDLE;
            default: nState = IDLE;
        endcase
    end

    // FSM 동작
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bitSampleIdx <= 0;
            dataBitIdx <= 0;
            done <= 0;
            rxOut <= 0;
            dataReg <= 0;
        end

        else begin
            done <= 1'b0;

            case (cState)
                IDLE: begin
                    if (data == 1'b0) begin
                        bitSampleIdx <= 0;
                    end
                end
                START: begin
                    if (sampleTick) begin
                        bitSampleIdx <= bitSampleIdx + 1;

                        if (bitSampleIdx == 7) begin
                            dataBitIdx <= 0;
                            bitSampleIdx <= 0;
                        end
                    end
                end
                DATA: begin
                    if (sampleTick) begin
                        bitSampleIdx <= bitSampleIdx + 1;
                        if (bitSampleIdx == 15) begin
                            dataReg[dataBitIdx] <= data;
                            bitSampleIdx <= 0;

                            if (dataBitIdx != 7) begin
                                dataBitIdx <= dataBitIdx + 1;
                            end
                        end
                    end
                end
                STOP: begin
                    if (sampleTick) begin
                        bitSampleIdx <= bitSampleIdx + 1;
                        if (bitSampleIdx == 15) begin
                            rxOut <= dataReg;
                            done <= 1'b1;
                        end
                    end
                end
            endcase
        end
    end

endmodule
