module powerOn(
    input clk, rst,

    input en,

    output done,
    output reg melody
    );

    localparam SIM_MODE = 0;    // 1=simulation, 0=FPGA

    localparam IDLE=0, BEEP_1K=1, BEEP_2K=2, BEEP_3K=3, BEEP_4K=4, SILENT=5, DONE=6;
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
                if (en) nState = BEEP_1K;
            end
            BEEP_1K: begin
                period = SIM_MODE? 700 : 70_000_000;    // 70ms
                beepFreq = SIM_MODE? 50 : 50_000;       // 1KHz

                if (cnt == 0) nState = BEEP_2K;
            end
            BEEP_2K: begin
                period = SIM_MODE? 700 : 70_000_000;
                beepFreq = SIM_MODE? 25 : 25_000;       // 2KHz

                if (cnt == 0) nState = BEEP_3K;
            end
            BEEP_3K: begin
                period = SIM_MODE? 700 : 70_000_000;
                beepFreq = SIM_MODE? 17 : 16_667;       // 3KHz

                if (cnt == 0) nState = BEEP_4K;
            end
            BEEP_4K: begin
                period = SIM_MODE? 700 : 70_000_000;
                beepFreq = SIM_MODE? 13 : 12_500;       // 4KHz

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
