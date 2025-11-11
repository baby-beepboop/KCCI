module openCover(
    input clk, rst,

    input en,

    output done,
    output reg melody
    );

    localparam SIM_MODE = 0;

    localparam IDLE=0, BEEP_261=1, BEEP_329=2, BEEP_554=3, SILENT=4, DONE=5;
    reg [2:0] cState, nState;

    reg [31:0] cnt, period;
    reg [31:0] beepCnt, beepFreq;

    // FSM
    always @(posedge clk, posedge rst) begin
        if (rst) cState <= IDLE;
        else cState <= nState;
    end

    always @(*) begin
        nState = cState;
        period = 0;
        beepFreq = 0;

        case (cState)
            IDLE: begin
                if (en) nState = BEEP_261;
            end
            BEEP_261: begin
                period = SIM_MODE? 700 : 70_000_000;    // 70ms
                beepFreq = SIM_MODE? 192 : 191_573;     // 261Hz

                if (cnt == 0) nState = BEEP_329;
            end
            BEEP_329: begin
                period = SIM_MODE? 700 : 70_000_000;
                beepFreq = SIM_MODE? 152 : 151_981;     // 329Hz

                if (cnt == 0) nState = BEEP_554;
            end
            BEEP_554: begin
                period = SIM_MODE? 700 : 70_000_000;
                beepFreq = SIM_MODE? 90 : 90_243;       // 554Hz

                if (cnt == 0) nState = SILENT;
            end
            SILENT: begin
                period = SIM_MODE? 3000 : 300_000_000;    // 3s
                
                if (cnt == 0) nState = DONE;
            end
            DONE: begin
            end
        endcase
    end

    // 타이머
    always @(posedge clk, posedge rst) begin
        if (rst) cnt <= 0;

        else begin
            if (nState != cState) cnt <= period;
            else if (cnt != 0) cnt <= cnt - 1;
        end
    end

    // 주파수 생성
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            beepCnt <= 0;
            melody <= 0;
        end
        
        else begin
            if (cState == IDLE || cState == SILENT || cState == DONE) begin
                melody <= 0;
            end
            else if (beepCnt >= beepFreq - 1) begin
                beepCnt <= 0;
                melody <= ~melody;
            end
            else begin
                beepCnt <= beepCnt + 1;
            end
        end
    end

    assign done = (cState == DONE);

endmodule
