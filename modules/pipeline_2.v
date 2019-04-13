`timescale 1ns/1ns
module pipeline_2 
    ( input clock, 
      input reset, 
      input [31:0] pc_in, 
      input [31:0] valA_in, 
      input [31:0] valB_in, 
      input [31:0] offset_in, 
      input [4:0] dest_in, 
      input [5:0] op_in,
      output [31:0] pc_out, 
      output [31:0] valA_out, 
      output [31:0] valB_out, 
      output [31:0] offset_out, 
      output [4:0] dest_out, 
      output [5:0] op_out,
      input ALU_in,
      output ALU_out,
      input MemToReg_in,
      output MemToReg_out,
      input RegWrt_in,
      output RegWrt_out,
      input MemWrt_in,
      output MemWrt_out,
      input MemRead_in,
      output MemRead_out,
      input branch_in,
      output branch_out,
      input eq_in,
      output eq_out,
      input goto_in,
      output goto_out,
      input Sign_in,
      output Sign_out,
      input [5:0] ALU_ctrl_in,
      output [5:0] ALU_ctrl_out
    );

//ALUSrc, MemToReg, reg_write, MemWrite, MemRead, branch, eq, goto_flg, Sign, ALU_ctrl

    register #(6) sig10(
        .in(ALU_ctrl_in),
        .out(ALU_ctrl_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(1) sig9(
        .in(Sign_in),
        .out(Sign_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(1) sig8(
        .in(goto_in),
        .out(goto_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(1) sig7(
        .in(eq_in),
        .out(eq_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(1) sig6(
        .in(branch_in),
        .out(branch_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(1) sig5(
        .in(MemRead_in),
        .out(MemRead_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(1) sig4(
        .in(RegWrt_in),
        .out(RegWrt_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(1) sig3(
        .in(MemWrt_in),
        .out(MemWrt_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(1) sig2(
        .in(MemToReg_in),
        .out(MemToReg_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
    );

    register #(1) sig1(
        .in(ALU_in),
        .out(ALU_out),
        .load(1'd1),
        .clock(clock),
        .reset(reset)
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
endmodule
