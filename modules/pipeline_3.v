`timescale 1ns/1ns
module pipeline_3 
    ( input clock, 
      input reset, 
      input [31:0] target_in, 
      input eq_in, 
      input [31:0] alu_in, 
      input [31:0] valB_in, 
      input [5:0] dest_in, 
      input [5:0] op_in,
      output [31:0] target_out, 
      output eq_out, 
      output [31:0] alu_out, 
      output [31:0] valB_out, 
      output [5:0] dest_out, 
      output [5:0] op_out
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
        .in(eq_in),
        .out(eq_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(6) r4(
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

endmodule
