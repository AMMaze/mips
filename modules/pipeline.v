`timescale 1ns/1ns
module pipeline ( 
    input clock, reset, change, step);

    wire clk;
    clock_state clk_st(
        .clock(clock),
        .reset(reset),
        .change(change),
        .step(step),
        .out_clk(clk)
    );

	wire reg_write; //true: write to register
    wire pc_ctrl; //next instruction: pc + 4 bytes * offset
	wire [5:0] ALU_ctrl; //alu opcode
    wire [31:0] i_addr, i_data; //address and data of new instruction
    

    wire jmp_flg;
    wire [31:0] alu_res, jmp_addr;  //jump address for PC
    
    wire [31:0] b3_jmp_addr; //for third buffer
    wire b3_jmp_flg;

    wire stall1, stall2;         //for corner case: read right after LW

    wire mem_stall;
    //first stage
    //fetching instruction from memory and calculating address of the next instruction 
    fetch fetch (
        .clock(clk),
        .reset(reset),
        .jump_target(b3_jmp_addr),
        .jump_flg(b3_jmp_flg),
        .stall(stall1 | stall2 | mem_stall),
        .instruction(i_data),
        .address(i_addr)
    );

    wire [31:0] b1_i_data, b1_i_addr;

    buffer1 if_id_buf1 (
        .clock(clk),
        .reset(reset | b3_jmp_flg),
        .load(stall1 | stall2 | mem_stall),
        .pc_in(i_addr),
        .instr_in(i_data),
        .pc_out(b1_i_addr),
        .instr_out(b1_i_data)
    );


    wire [31:0] wrdata, read_data1, read_data2, offset32;
    wire [4:0] wraddr, dest;
    wire [5:0] alu_op;
    wire [7:0] signals;
    wire [31:0] jump_addr;
    wire [4:0] b4_dest;         //from forth buffer
    wire [7:0] b4_signals;
    wire [31:0] b4_wrdata;
    //second stage
    //decoding current instruction, reading values from registers
    decode decode (
        .clock(clk),
        .reset(reset),
        .instruction(b1_i_data),       //instruction fetched on previous stage
        .i_address(b1_i_addr),
        .write_data(b4_wrdata),        //data to be written to register
        .write_address(b4_dest),     //address of register for writing from last stage
        .write(b4_signals[5]),          //enable write to register
        .valA(read_data1),          //data from first register [25:21]
        .valB(read_data2),          //data from second register [20:16]
        .immediate(offset32),         //extended immediate value
        .destination(dest),         //destination register for currect instruction
        .goto_address(jump_addr),   //extended unconditional jump address
        .opcode(alu_op),            //alu opcode
        .signals(signals)           //control signals
    );


    wire [4:0] b3_dest;     //from second and third buffer
    wire [4:0] b2_dest;
    //mux4 for data from decode, execute, memory and write
    //stages to bypass when RAW hazard occurs
    wire [1:0] valA_control, valB_control;
    wire [31:0] read_data1_raw, read_data2_raw;
    data_haz_control dhc_valA (
        .raddr(b1_i_data[25:21]),
        .dest2(b2_dest),
        .dest3(b3_dest),
        .dest4(b4_dest),
        .rwrt2(b2_signals[5]),
        .rwrt3(b3_signals[5]),
        .rwrt4(b4_signals[5]),
        .memtoreg2(b2_signals[6]),
        .out(valA_control),
        .stall(stall1)
    );


    mux4 #(32) mux4_valA_input (
        .i0(read_data1),
        .i1(alu_res),
        .i2(wrdata),
        .i3(b4_wrdata),
        .s(valA_control),
        .o(read_data1_raw)
    );

    data_haz_control dhc_valB (
        .raddr(b1_i_data[20:16]),
        .dest2(b2_dest),
        .dest3(b3_dest),
        .dest4(b4_dest),
        .rwrt2(b2_signals[5]),
        .rwrt3(b3_signals[5]),
        .rwrt4(b4_signals[5]),
        .memtoreg2(b2_signals[6]),
        .out(valB_control),
        .stall(stall2)
    );


    mux4 #(32) mux4_valB_input (
        .i0(read_data2),
        .i1(alu_res),
        .i2(wrdata),
        .i3(b4_wrdata),
        .s(valB_control),
        .o(read_data2_raw)
    );

    wire [31:0] b2_i_addr, b2_read_data1, b2_read_data2, b2_offset32, b2_jump_addr;
    wire [5:0] b2_alu_op;
    wire [7:0] b2_signals;

    buffer2 id_ex_buf2 (
        .clock(clk),
        .reset(reset | b3_jmp_flg),
        .stall(stall1 | stall2),
        .load(~mem_stall),
        .pc_in(b1_i_addr),
        .valA_in(read_data1_raw),
        .valB_in(read_data2_raw),
        .offset_in(offset32),
        .jump_addr_in(jump_addr),
        .dest_in(dest),
        .op_in(alu_op),
        .signals_in(signals),
        .pc_out(b2_i_addr),
        .valA_out(b2_read_data1),
        .valB_out(b2_read_data2),
        .offset_out(b2_offset32),
        .jump_addr_out(b2_jump_addr),
        .dest_out(b2_dest),
        .op_out(b2_alu_op),
        .signals_out(b2_signals)
    );



    execute execute (
        .clock(clk),
        .reset(reset),
        .i_address(b2_i_addr),
        .goto_address(b2_jump_addr),
        .valA(b2_read_data1),
        .valB(b2_read_data2),
        .offset(b2_offset32),
        .destination(b2_dest),
        .opcode(b2_alu_op),
        .signals(b2_signals),
        .jump_address(jmp_addr),    //final jump target
        .jump(jmp_flg),             //jump flag
        .alu_result(alu_res)        //ALU result
    );


    wire [31:0] b3_alu_res, b3_read_data2;
    wire [5:0] b3_alu_op;
    wire [7:0] b3_signals;
    
    buffer3 ex_mem_buf3 (
        .clock(clk),
        .reset(reset),
        .load(~mem_stall),
        .target_in(jmp_addr),
        .jmp_in(jmp_flg),
        .alu_in(alu_res),
        .valB_in(b2_read_data2),
        .dest_in(b2_dest),
        .op_in(b2_alu_op),
        .signals_in(b2_signals),
        .target_out(b3_jmp_addr),
        .jmp_out(b3_jmp_flg),
        .alu_out(b3_alu_res),
        .valB_out(b3_read_data2),
        .dest_out(b3_dest),
        .op_out(b3_alu_op),
        .signals_out(b3_signals)
    );



    wire [31:0] mdata;
    memory_stage memory_stage (
        .clock(clk),
        .reset(reset),
        .alu_result(b3_alu_res),
        .valB(b3_read_data2),
        .signals(b3_signals),
        .final_data(wrdata),
        .stall(mem_stall)
    );


    wire [5:0] b4_alu_op;

    buffer4 mem_wrt_buf4 (
        .clock(clk),
        .reset(reset),
        .load(~mem_stall),
        .data_in(wrdata),
        //.mem_in(mdata),
        .dest_in(b3_dest),
        .op_in(b3_alu_op),
        .signals_in(b3_signals),
        .data_out(b4_wrdata),
        //.mem_out(b4_mdata),
        .dest_out(b4_dest),
        .op_out(b4_alu_op),
        .signals_out(b4_signals)
    );

    /*mux2 mux2_m (
        .i0(b4_alu_res),
        .i1(b4_mdata),
        .s(b4_signals[6]),
        .o(wrdata)
    );*/

    //assign wraddr = b4_dest;
    //assign reg_write = b4_signals[5];

endmodule
