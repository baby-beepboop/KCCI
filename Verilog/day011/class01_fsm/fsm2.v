module fsm2(
    input clk, rstn,

    input      go, ws,
    output reg rd, ds
    );

    localparam IDLE=0, READ=1, DLY=2, DONE=3;
    reg [1:0] cState, nState;

    always @(posedge clk, negedge rstn) begin
        if (!rstn) cState <= IDLE;
        else cState <= nState;
    end

    always @(*) begin
        nState = cState;

        case (cState)
            IDLE: if (go)       nState = READ;
                  else if (!go) nState = IDLE;

            READ: if (ws) nState = DLY;
            
            DLY:  if (!ws)     nState = DONE;
                  else if (ws) nState = READ;

            DONE: if (go) nState = IDLE;

            default: nState = IDLE;
        endcase
    end

    always @(*) begin
        case (cState)
            READ: rd = 1'b1;
            DLY:  rd = 1'b1;
            DONE: ds = 1'b1;
            default: begin rd = 0; ds = 0; end
        endcase
    end

endmodule
