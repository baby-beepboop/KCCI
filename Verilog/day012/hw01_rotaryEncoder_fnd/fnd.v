module fnd(
    input clk, rst,
    input tick,

    input [15:0] din,

    output reg [3:0] an,
    output reg [6:0] seg
    );

    reg [1:0] sel;
    always @(posedge clk, posedge rst) begin
        if (rst) sel <= 0;
        else if (tick) sel <= sel + 1'b1;
    end

    reg [26:0] blinkCnt;
    reg blink;
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            blinkCnt <= 0;
            blink <= 0;
        end
        else if (blinkCnt == 100_000_000 - 1) begin
            blinkCnt <= 0;
            blink <= ~blink;
        end
        else begin
            blinkCnt <= blinkCnt + 1'b1;
        end
    end

    wire [1:0] dir = din[15:14];
    wire [7:0] cnt = din[7:0];
    wire [3:0] d0 = cnt[3:0];
    wire [3:0] d1 = cnt[7:4];
    wire [3:0] d2 = 4'h0;
    reg  [3:0] d3;

    reg [3:0] digit;
    always @(*) begin
        case (sel)
            2'd0: begin an = 4'b1110; digit = d0; end
            2'd1: begin an = 4'b1101; digit = d1; end
            2'd2: begin an = 4'b1011; digit = d2; end
            2'd3: begin an = 4'b0111; digit = d3; end
            default: begin an = 4'b1111; digit = 0; end
        endcase
    end

    // an[3]: 방향
    always @(*) begin
        if (blink) begin
            case (dir)
                2'b01: d3 = 4'hF;
                2'b10: d3 = 4'hB;
                default: d3 = 4'h0;
            endcase
        end
        else begin
            d3 = 4'h0;
        end
    end

    // an[2:0]: 카운터
    always @(*) begin
        if (sel == 2'd3 && blink == 0 && (dir == 2'b01 || dir == 2'b10)) begin
            seg = 7'b111_1111;
        end
        else begin
            case (digit)
                4'h0: seg = 7'b100_0000;
                4'h1: seg = 7'b111_1001;
                4'h2: seg = 7'b010_0100;
                4'h3: seg = 7'b011_0000;
                4'h4: seg = 7'b001_1001;
                4'h5: seg = 7'b001_0010;
                4'h6: seg = 7'b000_0010;
                4'h7: seg = 7'b111_1000;
                4'h8: seg = 7'b000_0000;
                4'h9: seg = 7'b001_0000;
                4'hA: seg = 7'b000_1000;
                4'hB: seg = 7'b000_0011;
                4'hC: seg = 7'b100_0110;
                4'hD: seg = 7'b010_0001;
                4'hE: seg = 7'b000_0110;
                4'hF: seg = 7'b000_1110;
                default: seg = 7'b111_1111;
            endcase
        end
    end

endmodule
