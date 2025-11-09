module rotary(
    input clk, rst,

    input s1, s2, key,
    output reg [15:0] led
    );

    reg [1:0] grayCode;
    always @(posedge clk, posedge rst) begin
        if (rst) grayCode <= 0;
        else grayCode <= {s1, s2};
    end

    localparam S00=2'b00, S01=2'b01, S11=2'b11, S10=2'b10;
    reg [1:0] cState, nState;
    
    always @(posedge clk, posedge rst) begin
        if (rst) cState <= S00;
        else cState <= nState;
    end

    // 00 -> 01 -> 11 -> 10 :  CW
    // 00 -> 10 -> 11 -> 01 :  CCW
    always @(*) begin
        nState = cState;

        case (cState)
            S00: begin
                if (grayCode == 2'b01)      nState = S01;
                else if (grayCode == 2'b10) nState = S10;
            end
            S01: begin
                if (grayCode == 2'b11)      nState = S11;
                else if (grayCode == 2'b00) nState = S00;
            end
            S11: begin
                if (grayCode == 2'b10)      nState = S10;
                else if (grayCode == 2'b01) nState = S01;
            end
            S10: begin
                if (grayCode == 2'b00)      nState = S00;
                else if (grayCode == 2'b11) nState = S11;
            end
        endcase
    end

    reg [1:0] dir;
    reg [7:0] cnt;
    reg keyPrev;
    reg ledToggle;
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            dir <= 0;
            cnt <= 0;
            keyPrev <= 0;
            ledToggle <= 0;
        end

        else begin
            // CW
            if ((cState == S10) && (nState == S00)) begin
                dir <= 2'b01;
                cnt <= cnt + 1;
            end
            // CCW
            else if ((cState == S01) && (nState == S00)) begin
                dir <= 2'b10;
                cnt <= cnt - 1;
            end

            keyPrev <= key;
            if (~keyPrev && key) ledToggle <= ~ledToggle;
        end
    end

    always @(*) begin
        led[15:14] = dir;
        led[13] = ledToggle;
        led[12:8] = 5'b00000;
        led[7:0] = cnt;
    end

endmodule
