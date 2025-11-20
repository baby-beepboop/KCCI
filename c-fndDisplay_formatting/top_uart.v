module top_uart(
    input clk, rst,

    input       rtcValid,
    input [7:0] rtcSecData, rtcMinData, rtcHrsData, rtcDateData, rtcMonData, rtcDayData, rtcYrData,

    output txOut
    );

    localparam BPS_VAL = 9600;

    wire txBusy, txDone;
    wire txEn;
    wire [7:0] txData;

    txFormatter u_txFormatter (.clk(clk), .rst(rst),
                               .rtcValid(rtcValid), .secData(rtcSecData), .minData(rtcMinData), .hrsData(rtcHrsData),
                               .dateData(rtcDateData), .monData(rtcMonData), .dayData(rtcDayData), .yrData(rtcYrData),
                               .busy(txBusy), .done(txDone), .en(txEn), .data(txData));

    txCore #(.BPS(BPS_VAL)) u_txCore (.clk(clk), .rst(rst), .en(txEn), .data(txData),
                                      .busy(txBusy), .done(txDone), .txOut(txOut));

endmodule
