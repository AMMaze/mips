`timescale 1ns/1ns
module buffer4 
(
    input clock, 
    input reset,
    input [31:0] data_in,
    //input [31:0] mem_in,
    input [4:0] dest_in,
    input [5:0] op_in,
    input [7:0] signals_in,
    output [31:0] data_out,
    //output [31:0] mem_out,
    output [4:0] dest_out,
    output [5:0] op_out,
    output [7:0] signals_out
);

    register #(32) r0(
        .in(data_in),
        .out(data_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    /*register #(32) r1(
        .in(mem_in),
        .out(mem_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );*/

    register #(5) r2(
        .in(dest_in),
        .out(dest_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(6) r3(
        .in(op_in),
        .out(op_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );
    
    register #(8) sig(
        .in(signals_in),
        .out(signals_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );
endmodule
    
