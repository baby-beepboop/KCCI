module fndCtrl(
    input clk_100Mhz, rst,
    input tick,

    input [13:0] segData,

    output reg [3:0] an,
    output reg [7:0] seg
    );

    wire [3:0] d0, d1, d2, d3;
    assign d0 = segData % 10;
    assign d1 = (segData / 10) % 10;
    assign d2 = (segData / 100) % 10;
    assign d3 = (segData / 1000) % 10;

    reg [1:0] sel;
    always @(posedge clk_100Mhz, posedge rst) begin
        if (rst) begin
            sel <= 0;
        end

        else if (tick) begin
            sel <= sel + 1'b1;
        end
    end

    reg [3:0] digit;
    always @(*) begin
        case (sel)
            2'd0: begin
                an = 4'b1110;
                digit = d0;
            end
            2'd1: begin
                an = 4'b1101;
                digit = d1;
            end
            2'd2: begin
                an = 4'b1011;
                digit = d2;
            end
            2'd3: begin
                an = 4'b0111;
                digit = d3;
            end
            default: begin
                an = 4'b1111;
                digit = 0;
            end
        endcase
    end

    always @(*) begin
        case (digit)
            4'd0: seg = 8'b1100_0000;
            4'd1: seg = 8'b1111_1001;
            4'd2: seg = 8'b1010_0100;
            4'd3: seg = 8'b1011_0000;
            4'd4: seg = 8'b1001_1001;
            4'd5: seg = 8'b1001_0010;
            4'd6: seg = 8'b1000_0010;
            4'd7: seg = 8'b1111_1000;
            4'd8: seg = 8'b1000_0000;
            4'd9: seg = 8'b1001_0000;
            default: seg = 8'b1111_1111;
        endcase
    end

endmodule
