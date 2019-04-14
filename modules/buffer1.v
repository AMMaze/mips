`timescale 1ns/1ns
module buffer1 (clock, reset, pc_in, instr_in, pc_out, instr_out);

    input clock, reset;

    input [31:0] pc_in;
    input [31:0] instr_in;

    output [31:0] pc_out;
    output [31:0] instr_out;

    register #(32) r0(
        .in(pc_in),
        .out(pc_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(32) r1(
        .in(instr_in),
        .out(instr_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

endmodule
