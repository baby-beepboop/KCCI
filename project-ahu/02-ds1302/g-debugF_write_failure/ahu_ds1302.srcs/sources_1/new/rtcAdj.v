// rtcAdj v1.0: 로터리 엔코더 펄스에 따라 RTC BCD 값을 증감 및 경계 조건 처리
module rtcAdj(
    input clk, rst,

    input [2:0] mode,
    input       key,
    input       cw, ccw,

    input [7:0] secIn, minIn, hrsIn, dateIn, monIn, dayIn, yrIn,
    output reg [7:0] secOut, minOut, hrsOut, dateOut, monOut, dayOut, yrOut,

    output reg       writeReq,
    output reg [3:0] writeAddr
    );

    reg [7:0] secReg, minReg, hrsReg, dateReg, monReg, dayReg, yrReg;

    // 쓰기 요청이 없을 때 현재 RTC 데이터를 내부 레지스터에 로드
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            secReg <= 8'h00; minReg <= 8'h00; hrsReg <= 8'h00;
            dateReg <= 8'h01; monReg <= 8'h01; dayReg <= 8'h01; yrReg <= 8'h00;
        end
        else begin
            if (!writeReq) begin
                secReg <= secIn; minReg <= minIn; hrsReg <= hrsIn;
                dateReg <= dateIn; monReg <= monIn; dayReg <= dayIn; yrReg <= yrIn;
            end

            if (mode[1] && )
        end
    end

    // 쓰기 모드 판별 및 경계값 설정
    always @(*) begin
        currVal = 0;
        writeAddr = 0;
        minVal = 0;
        maxVal = 0;

        if (mode[0]) begin       // 연도 쓰기 모드
            currVal = yrReg;
            writeAddr = 4'h7;
            minVal = 8'd0;
            maxVal = 8'd99;
        end
        else if (mode[1]) begin
            currVal = dateReg;
            writeAddr = 4'h5;
            minVal = 8'd0;
        end
    end

endmodule
