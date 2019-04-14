`timescale 1ns/1ns
module buffer2 
    ( input clock, 
      input reset, 
      input [31:0] pc_in, 
      input [31:0] valA_in, 
      input [31:0] valB_in, 
      input [31:0] offset_in, 
      input [31:0] jump_addr_in,
      input [4:0] dest_in, 
      input [5:0] op_in,
      input [7:0] signals_in,
      output [31:0] pc_out, 
      output [31:0] valA_out, 
      output [31:0] valB_out, 
      output [31:0] offset_out, 
      output [31:0] jump_addr_out,
      output [4:0] dest_out, 
      output [5:0] op_out,
      output [7:0] signals_out
  );

    register #(32) pc(
        .in(pc_in),
        .out(pc_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(32) reg1(
        .in(valA_in),
        .out(valA_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(32) reg2(
        .in(valB_in),
        .out(valB_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(32) off(
        .in(offset_in),
        .out(offset_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(5) wrt(
        .in(dest_in),
        .out(dest_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(6) op(
        .in(op_in),
        .out(op_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(32) jmp(
        .in(jump_addr_in),
        .out(jump_addr_out),
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
