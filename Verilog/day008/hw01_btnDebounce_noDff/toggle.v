module toggle(
    input clk_100Mhz, rst,
    
    input btn,
    output reg led
    );

    reg btn_prev;

    always @(posedge clk_100Mhz, posedge rst) begin
        if (rst) begin
            led <= 0;
            btn_prev <= 0;
        end

        else begin
            btn_prev <= btn;

            if (btn & ~btn_prev) begin    // btn이 0 -> 1 되면 LED toggle
                led <= ~led;
            end
        end
    end

endmodule
