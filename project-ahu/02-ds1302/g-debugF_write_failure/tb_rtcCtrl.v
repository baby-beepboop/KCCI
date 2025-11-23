`timescale 1ns / 1ps

module tb_rtcCtrl;
    reg clk, rst;

    reg       btn;
    reg [5:0] mode;
    reg       cw, ccw, save;
    reg       writeDone;

    reg [7:0] minData, hrsData, dateData, monData, yrData;

    wire       writeEn;
    wire [7:0] writeAddr;
    wire [7:0] writeData;

    wire [3:0] fndD0, fndD1, fndD2, fndD3;
    wire [1:0] fndDot;

    rtcCtrl uut (.clk(clk), .rst(rst), .btn(btn), .mode(mode), .cw(cw), .ccw(ccw), .save(save), .writeDone(writeDone),
                 .minData(minData), .hrsData(hrsData), .dateData(dateData), .monData(monData), .yrData(yrData),
                 .writeEn(writeEn), .writeAddr(writeAddr), .writeData(writeData),
                 .fndD0(fndD0), .fndD1(fndD1), .fndD2(fndD2), .fndD3(fndD3), .fndDot(fndDot));

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        
        btn = 0; mode = 0;
        cw = 0; ccw = 0; save = 0;
        writeDone = 0;

        minData = 0; hrsData = 0; dateData = 0; monData = 0; yrData = 0;

        #100 rst = 1'b0;

        $display("=============================");
        $display("[%0t] Simulation Start", $time);
        $display("=============================");
    end

    initial begin
        #200;

        // Step 1: Write Mode 진입
        $display("[%0t] Step 1: Enter Write Mode", $time);
        mode = 6'b000010;

        // Step 2: FND 편집 값 설정
        #100;
        $display("[%0t] Step 2: Set edited FND values", $time);
        yrData = 8'd24;

        // Step 3: save 버튼 pulse
        #100;
        $display("[%0t] Step 3: SAVE button pulse", $time);
        save = 1'b1;
        #20 save = 1'b0;

        // Step 4: writeEn(WP 해제 요청) 확인 및 writeDone 응답
        @(posedge writeEn);
        $display("[%0t] Step 4: 1st writeEn detected (WP Unlock Request)", $time);
        
        #500;
        writeDone = 1'b1;
        #20 writeDone = 1'b0;

        // Step 5: writeDone 시뮬레이션
        @(posedge writeEn);
        $display("[%0t] Step 5: 2nd writeEn detected (Data Write Request)", $time);

        #500;
        writeDone = 1'b1;
        #20 writeDone = 1'b0;

        #200;
        $display("[%0t] Simulation completed.", $time);
        $finish;
    end

endmodule
