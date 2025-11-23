// rtcCtrl v1.0: 슬라이드 스위치와 버튼 입력에 따라 RTC 편집 및 FND 표시 데이터 결정
// default: 시간 표시, Display Mode: 버튼 입력마다 시간->연도->날짜->시간 표시, Write Mode: 연도/달/일/시/분 쓰기
module rtcCtrl(
    input clk, rst,

    input       btn,
    input [5:0] mode,             // 0: Display Mode, 1-5: Write Mode
    input       cw, ccw, save,

    input [7:0] minData, hrsData, dateData, monData, yrData,

    output reg       writeEn,
    output reg [3:0] writeAddr,
    output reg [7:0] writeData,

    output reg [3:0] fndD0, fndD1, fndD2, fndD3,    //
    output reg [1:0] fndDot                         // [1]: D2의 dot, [0]: D0의 dot
    );

    localparam [1:0] TIME=0, YEAR=1, DATE=2;
    reg [1:0] dispState;
    reg [7:0] viewVal;

    reg [2:0] editMode;
    reg [7:0] initialVal;
    reg [7:0] editValReg;
    reg editing;

    // Display Mode FSM 상태 전이
    always @(posedge clk or posedge rst) begin
        if (rst) dispState <= TIME;

        else if (mode[0] && btn) begin
            case (dispState)
                TIME: dispState <= YEAR;
                YEAR: dispState <= DATE;
                DATE: dispState <= TIME;
            endcase
        end

        else if (!mode[0]) begin
            dispState <= TIME;
        end
    end
    
    // Write Mode 디코더
    always @(*) begin
        if (mode[1])      editMode = 1;    // 연도
        else if (mode[2]) editMode = 2;    // 달
        else if (mode[3]) editMode = 3;    // 일
        else if (mode[4]) editMode = 4;    // 시
        else if (mode[5]) editMode = 5;    // 분
        else              editMode = 0;
    end

    // Decimal to BCD
    function [7:0] bcdInc;
        input [7:0] val;
        input [7:0] maxVal;

        reg [7:0] dec;
        begin
            dec = (val[7:4]*10) + val[3:0];
            if (((dec == 0) && (maxVal != 0)) && ((val[7:4] == maxVal[7:4]) && (val[3:0] == maxVal[3:0]))) begin
                dec = ((maxVal == 8'h12) || (maxVal == 8'h31)) ? 1 : 0;
            end
            else if (dec >= ((maxVal[7:4]*10) + maxVal[3:0])) begin
                dec = ((maxVal == 8'h12) || (maxVal == 8'h31)) ? 1 : 0;
            end
            else begin
                dec = dec + 1;
            end

            bcdInc = {dec/10, dec%10};
        end
    endfunction

    function [7:0] bcdDec;
        input [7:0] val;
        input [7:0] maxVal;
        input [7:0] minVal;

        reg [7:0] dec;
        begin
            dec = (val[7:4]*10) + val[3:0];
            if (dec <= ((minVal[7:4]*10) + minVal[3:0])) begin
                dec = (maxVal[7:4]*10) + minVal[3:0];
            end
            else begin
                dec = dec - 1;
            end

            bcdDec = {dec/10, dec%10};
        end
    endfunction

    // 값 래치, 수정, 쓰기
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            initialVal <= 0;
            editValReg <= 0;
            editing <= 0;
            writeEn <= 0;
            writeAddr <= 0;
            writeData <= 0;
        end

        else begin
            writeEn <= 1'b0;

            if (editMode != 0) begin
                // 현재 RTC 값 또는 이전 편집값 로드
                case (editMode)
                    1: initialVal <= (editing) ? editValReg : yrData;
                    2: initialVal <= (editing) ? editValReg : monData;
                    3: initialVal <= (editing) ? editValReg : dateData;
                    4: initialVal <= (editing) ? editValReg : hrsData;
                    5: initialVal <= (editing) ? editValReg : minData;
                    default: initialVal <= 0;
                endcase

                if (cw) begin
                    case (editMode)
                        1: editValReg <= bcdInc(initialVal, 8'h99);
                        2: editValReg <= bcdInc(initialVal, 8'h12);
                        3: editValReg <= bcdInc(initialVal, 8'h31);
                        4: editValReg <= bcdInc(initialVal, 8'h23);
                        5: editValReg <= bcdInc(initialVal, 8'h59);
                    endcase
                    editing <= 1'b1;
                end
                else if (ccw) begin
                    case (editMode)
                        1: editValReg <= bcdDec(initialVal, 8'h99, 8'h00);
                        2: editValReg <= bcdDec(initialVal, 8'h12, 8'h01);
                        3: editValReg <= bcdDec(initialVal, 8'h31, 8'h01);
                        4: editValReg <= bcdDec(initialVal, 8'h23, 8'h00);
                        5: editValReg <= bcdDec(initialVal, 8'h59, 8'h00);
                    endcase
                    editing <= 1'b1;
                end

                if (save) begin
                    editing <= 1'b0;
                    writeEn <= 1'b1;
                    writeData <= editValReg;
                    
                    case (editMode)
                        1: writeAddr <= 4'h7;
                        2: writeAddr <= 4'h6;
                        3: writeAddr <= 4'h5;
                        4: writeAddr <= 4'h4;
                        5: writeAddr <= 4'h2;
                    endcase
                end
            end

            else begin
                editing <= 1'b0;
            end
        end
    end

    // FND 데이터 Mux (출력)
    always @(*) begin
        fndD3 = hrsData[7:4]; fndD2 = hrsData[3:0];
        fndD1 = minData[7:4]; fndD0 = minData[3:0];
        fndDot = 2'b01;

        // Write Mode
        if (editMode != 0) begin
            case (editMode)
                1: viewVal = (editing) ? editValReg : yrData;
                2: viewVal = (editing) ? editValReg : monData;
                3: viewVal = (editing) ? editValReg : dateData;
                4: viewVal = (editing) ? editValReg : hrsData;
                5: viewVal = (editing) ? editValReg : minData;
                default: viewVal = 0;
            endcase

            case (editMode)
                1: begin    // 20YY.
                    fndD3 = 4'd2; fndD2 = 4'd0;
                    fndD1 = viewVal[7:4]; fndD0 = viewVal[3:0];
                    fndDot = 2'b10;
                end
                2: begin    // MM.DD.
                    fndD3 = viewVal[7:4]; fndD2 = viewVal[3:0];
                    fndD1 = dateData[7:4]; fndD0 = dateData[3:0];
                    fndDot = 2'b00;
                end
                3: begin    // MM.DD.
                    fndD3 = monData[7:4]; fndD2 = monData[3:0];
                    fndD1 = viewVal[7:4]; fndD0 = viewVal[3:0];
                    fndDot = 2'b00;
                end
                4: begin    // HH.MM
                    fndD3 = viewVal[7:4]; fndD2 = viewVal[3:0];
                    fndD1= minData[7:4]; fndD0 = minData[3:0];
                    fndDot = 2'b01;
                end
                5: begin    // HH.MM
                    fndD3 = hrsData[7:4]; fndD2 = hrsData[3:0];
                    fndD1 = viewVal[7:4]; fndD0 = viewVal[3:0];
                    fndDot = 2'b01;
                end
            endcase
        end

        // Display Toggle Mode
        else if (mode[0]) begin
            case (dispState)
                TIME: begin
                    fndD3 = hrsData[7:4]; fndD2 = hrsData[3:0];
                    fndD1= minData[7:4]; fndD0 = minData[3:0];
                    fndDot = 2'b01;
                end
                DATE: begin
                    fndD3 = monData[7:4]; fndD2 = monData[3:0];
                    fndD1 = dateData[7:4]; fndD0 = dateData[3:0];
                    fndDot = 2'b00;
                end
                YEAR: begin
                    fndD3 = 4'd2; fndD2 = 4'd0;
                    fndD1 = yrData[7:4]; fndD0 = yrData[3:0];
                    fndDot = 2'b10;
                end
            endcase
        end

        // Default
        else begin
            fndD3 = hrsData[7:4]; fndD2 = hrsData[3:0];
            fndD1= minData[7:4]; fndD0 = minData[3:0];
            fndDot = 2'b01;
        end
    end

endmodule
