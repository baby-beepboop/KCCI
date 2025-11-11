module top(
    input clk, rst,

    input btnL, btnR,    // Power on, Open cover
    output buzz
    );

    wire tick;
    wire btnLdb, btnRdb;

    tickGen #(
        .CLK_FREQ(100_000_000),
        .TICK_FREQ(1000)
    ) u_tickGen (.clk100Mhz(clk), .rst(rst), .tick(tick));

    debounce u_debounce (.clk(clk), .rst(rst), .tick(tick), .btnRaw({btnR, btnL}), .btnDb({btnRdb, btnLdb}));

    wire powerOnMelody, openCoverMelody;
    
    // DEBUG: 버튼을 누르고 있는 동안만 멜로디 재생 -> 멜로디 모듈의 입력을 버튼 엣지 감지 신호 en으로 설정
    reg [1:0] btnPrev;
    always @(posedge clk, posedge rst) begin
        if (rst) btnPrev <= 0;
        else btnPrev <= {btnRdb, btnLdb};
    end
    wire btnLrise = btnLdb & ~btnPrev[0];
    wire btnRrise = btnRdb & ~btnPrev[1];

    reg enL, enR;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            enL <= 0;
            enR <= 0;
        end

        else begin
            if (btnLrise) enL <= 1;
            else if (powerOnDone) enL <= 0;

            if (btnRrise) enR <= 1;
            else if (openCoverDone) enR <= 0;
        end
    end

    powerOn u_powerOn (.clk(clk), .rst(rst), .en(enL), .done(powerOnDone), .melody(powerOnMelody));
    openCover u_openCover (.clk(clk), .rst(rst), .en(enR), .done(openCoverDone), .melody(openCoverMelody));
    
    assign buzz = enL? powerOnMelody :
                  enR? openCoverMelody : 1'b0;

endmodule
