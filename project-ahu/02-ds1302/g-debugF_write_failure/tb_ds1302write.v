`timescale 1ns / 1ps

module tb_ds1302write;
    reg clk, rst;

    reg       en;
    reg [7:0] addr;
    reg [7:0] dataIn;
    
    reg  sclk;
    wire ce;

    wire dataOut;
    wire ioDir;
    wire done;

    ds1302write uut (.clk(clk), .rst(rst), .en(en), .addr(addr), .dataIn(dataIn),
                     .sclk(sclk), .ce(ce),
                     .dataOut(dataOut), .ioDir(ioDir), .done(done));

    initial clk = 0;
    always #5 clk = ~clk;

    // SCLK Control
    task sclkPulse;
        input integer cycles;
        begin
            repeat (cycles) begin
                #10 sclk = 1;
                #10 sclk = 0;
            end
        end
    endtask

    initial begin
        rst = 1;
        en = 0; sclk = 0; addr = 0; dataIn = 0;

        #100 rst = 0;
        $display("===================================================");
        $display("[%0t] Simulation Start - Testing ds1302write FSM", $time);
        $display("===================================================");

        // Step 1: Write WP Unlock (Addr: 0x8E, Data: 0x00)
        #100;
        $display("[%0t] Step 1: Request WP Unlock (0x8E, 0x00)", $time);
        addr = 8'h8E;
        dataIn = 8'h00;
        en = 1'b1;

        #20 en = 1'b0;

        // Wait for FSM to enter SEND_CMD (and set CE=1)
        #20;
        $display("[%0t] CE=%b, Addr=%h, Start SCLK clocking...", $time, ce, addr);

        // 8 bits of Command (Address) + 8 bits of Data
        // Total 16 clock cycles required
        sclkPulse(16);

        // Wait for done
        fork
            begin
                sclkPulse(16);
                #50;
            end
            begin
                wait(done);
                $display("[%0t] SUCCESS: Write operation completed. 'done' asserted!", $time);
            end
        join
        
        if (!done) begin
            $display("[%0t] FAILURE: 'done' signal failed to assert!", $time);
        end

        #100;
        $display("[%0t] Simulation finished.", $time);
        $finish;
    end

endmodule
