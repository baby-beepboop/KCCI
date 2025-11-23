module top_uart(
    input clk, rst,

    input [7:0] rtcSec, rtcMin, rtcHrs, rtcDate, rtcMon, rtcDay, rtcYr,
    
    input rxIn,

    output       txOut,
    output [7:0] rxOut,
    
    output [15:0] led
    );

    wire rtcTxTrig;

    localparam BPS_VAL = 9600;

    wire txBusy, txDone;
    wire txEn;
    wire [7:0] txData;

    wire rxDone;

    txFormatter u_txFormatter (.clk(clk), .rst(rst),
                               .trig(rtcTxTrig), .secData(rtcSec), .minData(rtcMin), .hrsData(rtcHrs),
                               .dateData(rtcDate), .monData(rtcMon), .dayData(rtcDay), .yrData(rtcYr),
                               .busy(txBusy), .done(txDone), .txEn(txEn), .data(txData));

    txCore #(.BPS(BPS_VAL)) u_txCore (.clk(clk), .rst(rst), .en(txEn), .data(txData),
                                      .busy(txBusy), .done(txDone), .txOut(txOut));
//    rxCore #(.BPS(BPS_VAL)) u_rxCore (.clk(clk), .rst(rst), .data(rxIn), .done(rxDone), .rxOut(rxOut));
    uart_rx #(.BPS(BPS_VAL)) u_rxCOre (.clk(clk), .reset(rst), .rx(rxIn), .rx_done(rxDone), .data_out(rxOut));

    cmdCtrl u_cmdCtrl (.clk(clk), .rst(rst), .rxDone(rxDone), .rxData(rxOut), .rtcTxReq(rtcTxTrig), .led(led));

endmodule
