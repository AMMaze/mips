`timescale 1ns/1ns
module buffer3 
    ( input clock, 
      input reset, 
      input [31:0] target_in, 
      input jmp_in, 
      input [31:0] alu_in, 
      input [31:0] valB_in, 
      input [4:0] dest_in, 
      input [5:0] op_in,
      input [7:0] signals_in,
      output [31:0] target_out, 
      output jmp_out, 
      output [31:0] alu_out, 
      output [31:0] valB_out, 
      output [4:0] dest_out, 
      output [5:0] op_out,
      output [7:0] signals_out
    );

    register #(32) r0(
        .in(target_in),
        .out(target_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(32) r1(
        .in(alu_in),
        .out(alu_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(32) r2(
        .in(valB_in),
        .out(valB_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(1) r3(
        .in(jmp_in),
        .out(jmp_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(5) r4(
        .in(dest_in),
        .out(dest_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(6) r5(
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
