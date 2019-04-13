`timescale 1ns/1ns
module mips (clock, reset, change, step);
    
    input clock, reset, change, step;

    wire clk;
    clock_state clk_st(
        .clock(clock),
        .reset(reset),
        .change(change),
        .step(step),
        .out_clk(clk)
    );


    wire reg_res; //false: write to [15:11] reg (third) (ADDI, LW); true: write to [20:16] reg (second) (R)
	wire ALUSrc; //true: second operand is extended [15:0] (constant, offset); false: second operand is [20:16] (register)
	wire MemToReg; //from memory to register (LW)
	wire reg_write; //true: write to register
	wire MemWrite; //write to memory (SW)
	wire MemRead; //read from memory (LW)
	wire eq; //jump on equal (subtraction == zero)
	wire branch; //jump indicator
    wire pc_ctrl; //next instruction: pc + 4 bytes * offset
	wire [5:0] ALU_ctrl; //alu opcode

    //wires for decode buffer
    wire ALUSrc_decode, MemToReg_decode, reg_write_decode, MemWrite_decode;
    wire MemRead_decode, branch_decode, eq_decode, goto_flg_decode;
    wire Sign_decode;
    wire [5:0] ALU_ctrl_decode;

	wire [31:0] new_addr, i_addr; //instructions addresses
    //program counter that works like this: pass new instruct address -> on pos
    //edge of the clock it will change it's output (PC) for new address
	pc mips_pc(
        .clk(clk), 
        .newPC(new_addr), 
        .PC(i_addr),
        .reset(reset)
    );
	
	wire [31:0] i_data; //instruction data
    //selects from it's memory (just a big 'case') instruction corresponding to
    //a certain number (i.e. 'address' -- sel)
	instruction_memory mips_inst_memory(
        .sel(i_addr), 
        .out(i_data)
    );
	
    //buffer for first pipeline stage 
    wire [31:0] pc_out;
    wire [31:0] instr_out;
    pipeline_1 ifetch (
        .clock(clk),
        .reset(reset),
        .pc_in(i_addr),
        .instr_in(i_data),
        .pc_out(pc_out),
        .instr_out(instr_out)
    );

	wire [4:0] write_addr; //write to this register
	wire [31:0] read_data1; //data from first register [25:21]
    wire [31:0] read_data2; //data from second register [20:16]
    wire [31:0] write_data; //data for writing into the write_addr

    wire [4:0] dest_decode;
    //file with all registers that actually just a pair of muxs (selects outputs
    //from registers specified in raddr1 and raddr2).
	register_file regfile(
        .raddr1(instr_out[25:21]), 
        .raddr2(instr_out[20:16]), 
        .waddr(dest_decode), 
        .wdata(write_data), 
        .write(reg_write_decode), 
        .clock(clk), 
        .reset(reset), 
        .rdata1(read_data1), 
        .rdata2(read_data2)
    );
	
	wire [31:0] ALU_input, ALU_out; //input and output for ALU
    //alu itself is quite simple: two operands and opcode
    //but we need separate wire ALU_input, since the second operand depends on
    //instruction type
	alu mips_alu(
        .in1(read_data1), 
        .in2(ALU_input), 
        .aluop(ALU_ctrl_decode), 
        .out(ALU_out)
    );
	
	wire [31:0] mem_data; //data loaded from memory (array)
    //memory implemented by means of arrays
    memory data_mem(
        .read(MemRead_decode), 
        .write(MemWrite_decode), 
        .addr(ALU_out[7:0]), 
        .data_in(read_data2), 
        .data_out(mem_data)
    );

	wire [31:0] extended32; //immediate value extended to 32 bits
    wire Sign;
    //since immediate values are restricted to 16 bits, we have to extend it to 32 bits
	sign_ext SignExt(
        .in(instr_out[15:0]), 
        .sign(Sign_decode),
        .out(extended32[31:0])
    );
	
    wire [31:0] pc_out_decode;
    wire [31:0] rdata_decode_1;
    wire [31:0] rdata_decode_2;
    wire [31:0] offset_decode;
    wire [5:0] op_decode;
    wire goto_flg;
    pipeline_2 idecode(
        .clock(clk),
        .reset(reset),
        .pc_in(pc_out),
        .valA_in(read_data1),
        .valB_in(read_data2),
        .offset_in(extended32),
        .dest_in(write_addr),
        .op_in(instr_out[31:26]),
        .pc_out(pc_out_decode),
        .valA_out(rdata_decode_1),
        .valB_out(rdata_decode_2),
        .offset_out(offset_decode),
        .dest_out(dest_decode),
        .op_out(op_decode),
        .ALU_in(ALUSrc),
        .ALU_out(ALUSrc_decode),
        .MemToReg_in(MemToReg),
        .MemToReg_out(MemToReg_decode),
        .RegWrt_in(reg_write),
        .RegWrt_out(reg_write_decode),
        .MemWrt_in(MemWrite),
        .MemWrt_out(MemWrite_decode),
        .MemRead_in(MemRead),
        .MemRead_out(MemRead_decode),
        .branch_in(branch),
        .branch_out(branch_decode),
        .eq_in(eq),
        .eq_out(eq_decode),
        .goto_in(goto_flg),
        .goto_out(goto_flg_decode),
        .Sign_in(Sign),
        .Sign_out(Sign_decode),
        .ALU_ctrl_in(ALU_ctrl),
        .ALU_ctrl_out(ALU_ctrl_decode)
    ); 


    //interpretation of ALU_out, that is basically just a subtraction of given operands,  
    //depends on the type of an instruction (bne/beq) 
	assign pc_ctrl = ((ALU_out != 32'd0)^eq_decode) ? branch_decode : 0;

    wire [31:0] goto_addr;
    //extending 26 bits to 32 for goto
    jump_target jump_target(
        .im_val(instr_out[25:0]),
        .target(goto_addr),
        .curr_addr(pc_out),
        .goto(goto_flg_decode)
    );        

    //result address for conditional jump (+offset)
    wire [31:0] cond_addr;
    adder #(32) cond(
        .x(32'd4 + 32'd4 * extended32),
        .y(pc_out),
        .out(cond_addr)
    );

    wire [31:0] res_jump_addr;
    //deciding whether we should use offset for conditional jump or address for
    //goto
    mux2 #(32) mux2_jump(cond_addr, goto_addr, goto_flg_decode, res_jump_addr); 

    //returns address of a new instruction
	next_pc NextPC(
        .clock(clk),
        .reset(reset),
        .currPC(i_addr), 
        .out(new_addr), 
        .jmp_addr(res_jump_addr), 
        .jmp(pc_ctrl)
    );

    //destination register depends on the type of instruction
    //R-type -> [15:11]
	mux2 #(5) mux2_1(instr_out[20:16], instr_out[15:11], reg_res, write_addr); 
    //source for second operand in ALU: constant/register
	mux2 mux2_2(read_data2, extended32, ALUSrc_decode, ALU_input); 
    //for lw-op result is loaded from memory, in other cases - output from alu
	mux2 mux2_3(ALU_out, mem_data, MemToReg_decode, write_data); 
	
	mips_states control(instr_out, reg_res, ALUSrc, MemToReg, reg_write, MemWrite, MemRead, branch, eq, goto_flg, Sign, ALU_ctrl);


endmodule
