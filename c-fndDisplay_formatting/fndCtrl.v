// fndCtrl v2.0: ds1302read에서 읽어온 시(Hour), 분(Minute) 데이터를 FND 4자리에 HH:MM 형태로 표시
module fndCtrl(
    input clk, rst,
    input tick,

    input [7:0] hourData, minData,

    output reg [3:0] an,
    output reg [6:0] seg,
    output reg       dp
    );

    // BCD 데이터 분리
    // Hour
    // hourData[7:4]: 10의 자리, hourData[3:0]: 1의 자리
    wire [3:0] hourUnits = hourData[3:0];
    wire [3:0] hourTens = hourData[7:4] & 4'h3;
    // Minute
    // minData[7:4]: 10의 자리, minData[3:0]: 1의 자리
    wire [3:0] minUnits = minData[3:0];
    wire [3:0] minTens = minData[7:4];

    reg [1:0] sel;      // 0: Min Units, 1: Min Tens, 2: Hour Units, 3: Hour Tens
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

        case (sel)
            2'd0: begin
                an = 4'b1110; digit = minUnits; dp = 1'b1;
            end
            2'd1: begin
                an = 4'b1101; digit = minTens; dp = 1'b1;
            end
            2'd2: begin
                an = 4'b1011; digit = hourUnits; dp = 1'b0;
            end
            2'd3: begin
                an = 4'b0111; digit = hourTens; dp = 1'b1;
            end
            default: begin
                an = 4'b1111; digit = 0;
            end
        endcase
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
