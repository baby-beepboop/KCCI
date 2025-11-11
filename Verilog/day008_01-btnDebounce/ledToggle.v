module ledToggle(
    input clk,
    output [1:0] led
    );

    reg toggle = 1'b0;

    always @(posedge clk) begin
        toggle <= ~toggle;
    end

    assign led[0] = (toggle == 1)? 1'b1 : 1'b0;

endmodule

module ledTickToggle(
    input tick, rst,
    output [1:0] led
    );

    localparam CNT_FREQ = 500;
    localparam CNT_WIDTH = 9;
    localparam [CNT_WIDTH-1:0] CNT_MAX = CNT_FREQ - 1;
    
    reg [CNT_WIDTH-1:0] cnt;
    reg tickToggle = 1'b0;

    always @(posedge tick, posedge rst) begin
        if (rst) begin
            cnt <= 0;
            tickToggle <= 0;
        end

        else begin
            if (cnt == CNT_MAX) begin
                cnt <= 0;
                tickToggle <= ~tickToggle;
            end
            else begin
                cnt <= cnt + 1'b1;
            end
        end
    end

    assign led[1] = tickToggle;

endmodule
