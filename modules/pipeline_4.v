`timescale 1ns/1ns
module pipeline_4 
(
    input clock, 
    input reset,
    input [31:0] alu_in,
    input [31:0] mem_in,
    input [5:0] dest_in,
    input [5:0] op_in,
    output [31:0] alu_out,
    output [31:0] mem_out,
    output [5:0] dest_out,
    output [5:0] op_out
);

    register #(32) r0(
        .in(alu_in),
        .out(alu_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(32) r1(
        .in(mem_in),
        .out(mem_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(6) r2(
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
endmodule
    
