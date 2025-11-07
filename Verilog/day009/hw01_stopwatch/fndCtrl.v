module fndCtrl(
    input clk100Mhz, rst,
    input tick,

    input [13:0] segData,
    input        idle,

    output reg [3:0] an,
    output reg [6:0] seg,
    output           dp
    );

    wire [3:0] anIdle;
    wire [6:0] segIdle;
    fndCtrlIdle u_fndCtrlIdle (.clk100Mhz(clk100Mhz), .rst(rst), .flag(idle), .an(anIdle), .seg(segIdle));

    reg [3:0] anSW;
    reg [6:0] segSW;
    always @(*) begin
        if (idle) begin
            an = anIdle;
            seg = segIdle;
        end
        else begin
            an = anSW;
            seg = segSW;
        end
    end

    wire [3:0] d0, d1, d2, d3;
    assign d0 = (segData / 10) % 10;
    assign d1 = (segData / 100) % 10;
    assign d2 = (segData / 1000) % 6;
    assign d3 = (segData / 6000) % 10;

    reg [1:0] sel;
    always @(posedge clk100Mhz, posedge rst) begin
        if (rst) sel <= 0;
        else if (tick) sel <= sel + 1'b1;
    end

    reg [3:0] digit;
    always @(*) begin
        case (sel)
            2'd0: begin anSW = 4'b1110; digit = d0; end
            2'd1: begin anSW = 4'b1101; digit = d1; end
            2'd2: begin anSW = 4'b1011; digit = d2; end
            2'd3: begin anSW = 4'b0111; digit = d3; end
            default: begin anSW = 4'b1111; digit = 0; end
        endcase
    end

    always @(*) begin
        case (digit)
            4'd0: segSW = 7'b100_0000;
            4'd1: segSW = 7'b111_1001;
            4'd2: segSW = 7'b010_0100;
            4'd3: segSW = 7'b011_0000;
            4'd4: segSW = 7'b001_1001;
            4'd5: segSW = 7'b001_0010;
            4'd6: segSW = 7'b000_0010;
            4'd7: segSW = 7'b111_1000;
            4'd8: segSW = 7'b000_0000;
            4'd9: segSW = 7'b001_0000;
            default: segSW = 7'b111_1111;
        endcase
    end

    assign dp = idle || (an[1] && an[3]);

endmodule
