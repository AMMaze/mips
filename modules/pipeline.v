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

    //first stage
    //fetching instruction from memory and calculating address of the next instruction 
    fetch fetch (
        .clock(clk),
        .reset(reset),
        .jump_target(jmp_addr),
        .jump_flg(jmp_flg),
        .instruction(i_data),
        .address(i_addr)
    );


    wire [31:0] wrdata, read_data1, read_data2, offset32;
    wire [4:0] wraddr, dest;
    wire [5:0] alu_op;
    wire [7:0] signals;
    wire [31:0] jump_addr;
    //second stage
    //decoding current instruction, reading values from registers
    decode decode (
        .clock(clk),
        .reset(reset),
        .instruction(i_data),       //instruction fetched on previous stage
        .i_address(i_addr),
        .write_data(wrdata),        //data to be written to register
        .write_address(wraddr),     //address of register for writing from last stage
        .write(reg_write),          //enable write to register
        .valA(read_data1),          //data from first register [25:21]
        .valB(read_data2),          //data from second register [20:16]
        .immediate(offset32),         //extended immediate value
        .destination(dest),         //destination register for currect instruction
        .goto_address(jump_addr),   //extended unconditional jump address
        .opcode(alu_op),            //alu opcode
        .signals(signals)           //control signals
    );



    execute execute (
        .clock(clk),
        .reset(reset),
        .i_address(i_addr),
        .goto_address(jump_addr),
        .valA(read_data1),
        .valB(read_data2),
        .offset(offset32),
        .destination(dest),
        .opcode(alu_op),
        .signals(signals),
        .jump_address(jmp_addr),    //final jump target
        .jump(jmp_flg),             //jump flag
        .alu_result(alu_res)        //ALU result
    );


    wire [31:0] mdata;
    memory_stage memory_stage (
        .clock(clk),
        .reset(reset),
        .alu_result(alu_res),
        .valB(read_data2),
        .signals(signals),
        .memory_data(mdata)
    );



    mux2 mux2_m (
        .i0(alu_res),
        .i1(mdata),
        .s(signals[6]),
        .o(wrdata)
    );

    assign wraddr = dest;
    assign reg_write = signals[5];

endmodule
