// fndCtrl v3.0: 슬라이드 스위치 입력에 따라 RTC 데이터 표시
module fndCtrl(
    input clk, rst,
    input tick,

    input [2:0] mode,    // 슬라이드 스위치 입력 (0: 연도, 1: 날짜, 2: 시간)

    input [7:0] yrData, monData, dateData, hrsData, minData,

    output reg [3:0] an,
    output reg [6:0] seg,
    output reg       dp
    );

    // BCD 데이터 분리
    // 연도 (YY)
    wire [3:0] yrUnits = yrData[3:0];
    wire [3:0] yrTens = yrData[7:4];

    // 날짜 (MMDD)
    wire [3:0] monUnits = monData[3:0];
    wire [3:0] monTens = monData[7:4];
    wire [3:0] dateUnits = dateData[3:0];
    wire [3:0] dateTens = dateData[7:4];

    // 시간 (HHMM)
    wire [3:0] hrsUnits = hrsData[3:0];
    wire [3:0] hrsTens = hrsData[7:4] & 4'h3;
    wire [3:0] minUnits = minData[3:0];
    wire [3:0] minTens = minData[7:4];

    reg [1:0] sel;
    reg [3:0] digit;

    // 다이나믹 스캔
    always @(posedge clk, posedge rst) begin
        if (rst) sel <= 0;
        else if (tick) sel <= sel + 1;
    end

    // 자리 선택 및 데이터 선택
    always @(*) begin
        an = 4'b1111;
        digit = 0;
        dp = 1;

        // 연도 (20YY.)
        if (mode[0]) begin
            case (sel)
                2'd0: begin an = 4'b1110; digit = yrUnits; dp = 1'b0; end
                2'd1: begin an = 4'b1101; digit = yrTens; dp = 1'b1; end
                2'd2: begin an = 4'b1011; digit = 4'd0; dp = 1'b1; end
                2'd3: begin an = 4'b0111; digit = 4'd2; dp = 1'b1; end
                default: begin an = 4'b1111; digit = 0; dp = 1; end
            endcase
        end

        // 날짜 (MM.DD.)
        else if (mode[1]) begin
            case (sel)
                2'd0: begin an = 4'b1110; digit = dateUnits; dp = 1'b0; end
                2'd1: begin an = 4'b1101; digit = dateTens; dp = 1'b1; end
                2'd2: begin an = 4'b1011; digit = monUnits; dp = 1'b0; end
                2'd3: begin an = 4'b0111; digit = monTens; dp = 1'b1; end
                default: begin an = 4'b1111; digit = 0; dp = 1; end
            endcase
        end

        // 시간 (HH.MM)
        else if (mode[2]) begin
            case (sel)
                2'd0: begin an = 4'b1110; digit = minUnits; dp = 1'b1; end
                2'd1: begin an = 4'b1101; digit = minTens; dp = 1'b1; end
                2'd2: begin an = 4'b1011; digit = hrsUnits; dp = 1'b0; end
                2'd3: begin an = 4'b0111; digit = hrsTens; dp = 1'b1; end
                default: begin an = 4'b1111; digit = 0; dp = 1; end
            endcase
        end

        else begin    // default: 시간
            case (sel)
                2'd0: begin an = 4'b1110; digit = minUnits; dp = 1'b1; end
                2'd1: begin an = 4'b1101; digit = minTens; dp = 1'b1; end
                2'd2: begin an = 4'b1011; digit = hrsUnits; dp = 1'b0; end
                2'd3: begin an = 4'b0111; digit = hrsTens; dp = 1'b1; end
                default: begin an = 4'b1111; digit = 0; dp = 1; end
            endcase
        end
    end

    // BCD to 7-Segment 디코더
    always @(*) begin
        case (digit)
            4'd0: seg = 7'b100_0000;
            4'd1: seg = 7'b111_1001;
            4'd2: seg = 7'b010_0100;
            4'd3: seg = 7'b011_0000;
            4'd4: seg = 7'b001_1001;
            4'd5: seg = 7'b001_0010;
            4'd6: seg = 7'b000_0010;
            4'd7: seg = 7'b111_1000;
            4'd8: seg = 7'b000_0000;
            4'd9: seg = 7'b001_0000;
            default: seg = 7'b111_1111;
        endcase
    end

endmodule
