`timescale 1ns/1ns
module clock_state (clock, reset, change, step, out_clk);

    input clock, reset, change, step;
    output out_clk;

    reg int_clk, prev_change, change_pushed;

    initial begin
        int_clk = 0;
        prev_change = 0;
        change_pushed = 0;
    end

    always @(posedge reset) begin
        int_clk = 0;
        prev_change = 0;
        change_pushed = 1;
    end

    always @(clock)
        if (!change_pushed)
            int_clk = clock;

    always @(posedge clock)
        if (change_pushed)
            int_clk = step;

    always @(posedge clock) begin
        if (prev_change != change) begin
            if (change) 
                change_pushed = ~change_pushed;
            prev_change = change;
        end
    end
            
    assign out_clk = int_clk;
endmodule
