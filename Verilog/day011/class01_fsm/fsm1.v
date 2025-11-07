module fsm1(
    input clk, rstn,

    input      done,
    output reg ack
    );

    localparam READY=0, TRANS=1, WRITE=2, READ=3;
    reg [1:0] cState, nState;

    always @(posedge clk, negedge rstn) begin
        if (!rstn) cState <= READY;
        else cState <= nState;
    end

    always @(*) begin
        nState = cState;

        case (cState)
            READY: if (done) nState = TRANS;
                   else      nState = READY;
            
            TRANS: if (!done) nState = WRITE;
                   else       nState = TRANS;
            
            WRITE: if (done) nState = READ;
                   else      nState = WRITE;

            READ: if (done) nState = READY;
                  else      nState = READ;

            default: nState = READY;
        endcase
    end

    always @(*) begin
        case (cState)
            READY: if (done) ack = 1'b1;
                   else      ack = 1'b0;
            TRANS: ack = 1'b0;
            WRITE: if (done) ack = 1'b1;
                   else      ack = 1'b0;
            READ:  ack = 1'b0;
        endcase
    end

endmodule
