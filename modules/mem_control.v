`timescale 1ns/1ns

module mem_control (
    input clock, reset, write, read,
    input hit,
    output update_tag,      
    output update_cache,
    output ready
);

    parameter ST_IDLE       = 4'b0000;
    parameter ST_READ       = 4'b0001;
    parameter ST_READHIT    = 4'b0010;
    parameter ST_READMISS   = 4'b0011;
    parameter ST_WRITE      = 4'b0100;
    parameter ST_WRITEHIT   = 4'b0101;
    parameter ST_WRITEMISS  = 4'b0110;
    parameter ST_READRAM    = 4'b0111;
    parameter ST_WRITERAM   = 4'b1000;
    parameter ST_WRITEWAIT  = 4'b1001;

    reg [3:0] state, nextstate;
    reg enable;
    reg update;
    reg update_cache;

    always @(posedge clock)
        state = nextstate;

    always @(posedge reset) begin
        nextstate = ST_IDLE;
        enable = 0;
        update = 0;
        update_cache = 0;
    end

    //always @(write or read)
    //    state = ST_IDLE;

    always @(state or posedge write or posedge read) begin
    //always @(posedge clock)
    //    state = nextstate;
        if (~write & ~read)
            state = ST_IDLE;
        case(state)
            ST_IDLE: begin
                enable = 0;
                update = 0;
                update_cache = 0;
                if (read)
                    nextstate = ST_READ;
                else if (write)
                    nextstate = ST_WRITE;
            end

            ST_READ: begin
                if (!read)
                    nextstate = ST_IDLE;
                else begin
                    if (hit) begin 
                        nextstate = ST_IDLE;
                        enable = 1;
                    end
                    else begin 
                        nextstate = ST_READRAM;
                        update = 1;
                    end
                end
            end

            ST_READRAM: begin
                nextstate = ST_READMISS;
                update_cache = 1;
            end

            ST_WRITE: begin
                if (!write)
                    nextstate = ST_IDLE;
                else begin
                    if (hit) begin
                        nextstate = ST_WRITEWAIT;
                        //update = 1;
                        update_cache = 1;
                    end
                    else begin
                        nextstate = ST_WRITEWAIT;
                        //update = 1;
                    end
                end
            end

            ST_READMISS: begin
                nextstate = ST_IDLE;
                enable = 1;
            end

            ST_WRITEWAIT: begin
                nextstate = ST_WRITERAM;
            end

            ST_WRITERAM: begin
                nextstate = ST_IDLE;
                enable = 1;
            end

        endcase
    end

    assign ready = enable;
    assign update_tag = update;
endmodule
