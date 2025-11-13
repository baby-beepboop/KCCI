module fndCtrlIdle(
    input clk100Mhz, rst,

    input flag,
    
    output reg [3:0] an,
    output reg [6:0] seg
    );

    reg [25:0] cnt;
    reg  [3:0] step;

    always @(posedge clk100Mhz, posedge rst) begin
        if (rst) begin
            cnt <= 0;
            step <= 0;
        end

        else if (flag) begin
            if (cnt == 50_000_000 - 1) begin
                cnt <= 0;
                step <= step + 1'b1;
            end
            else begin
                cnt <= cnt + 1'b1;
            end
        end

        else begin
            cnt <= 0;
            step <= 0;
        end
    end

    always @(*) begin
        case (step)
            4'd0:  begin an = 4'b1110; seg = 7'b111_1110; end    // A
            4'd1:  begin an = 4'b1100; seg = 7'b111_1110; end
            4'd2:  begin an = 4'b1001; seg = 7'b111_1110; end
            4'd3:  begin an = 4'b0011; seg = 7'b111_1110; end
            4'd4:  begin an = 4'b0111; seg = 7'b101_1110; end    // A, F
            4'd5:  begin an = 4'b0111; seg = 7'b100_1111; end    // F, E
            4'd6:  begin an = 4'b0111; seg = 7'b110_0111; end    // E, D
            4'd7:  begin an = 4'b0011; seg = 7'b111_0111; end    // D
            4'd8:  begin an = 4'b1001; seg = 7'b111_0111; end
            4'd9:  begin an = 4'b1100; seg = 7'b111_0111; end
            4'd10: begin an = 4'b1110; seg = 7'b111_0011; end    // D, C
            4'd11: begin an = 4'b1110; seg = 7'b111_1001; end    // C, B
            4'd12: begin an = 4'b1110; seg = 7'b111_1101; end    // B
            default: begin an = 4'b1111; seg = 7'b111_1111; end
        endcase
    end

endmodule
