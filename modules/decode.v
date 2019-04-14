`timescale 1ns/1ns
module decode (
    input clock, reset,
    input [31:0] instruction,   //instruction fetched on previous stage
    input [31:0] i_address,     //instruction address
    input [31:0] write_data,    //data to be written to register
    input [4:0] write_address,  //address of register for writing from last stage
    input write,                //enable write to register
    output [31:0] valA,         //data from first register [25:21]
    output [31:0] valB,         //data from second register [20:16]
    output [31:0] immediate,     //extended immediate value
    output [4:0] destination,   //destination register for currect instruction
    output [31:0] goto_address, //goto address
    output [5:0] opcode,        //alu opcode
    output [7:0] signals        //control signals
);

    wire reg_res; //false: write to [15:11] reg (third) (ADDI, LW); true: write to [20:16] reg (second) (R)
	//signals[7]: wire ALUSrc; //true: second operand is extended [15:0] (constant, offset); false: second operand is [20:16] (register)
	//signals[6]: wire MemToReg; //from memory to register (LW)
	//signals[5]: wire reg_write; //true: write to register
	//signals[4]: wire MemRead; //read from memory (LW)
	//signals[3]: wire MemWrite; //write to memory (SW)
	//signals[2]: wire branch; //jump indicator
	//signals[1]: wire eq; //jump on equal (subtraction == zero)
    //signals[0]: wire goto_flg; //next instruction: pc + 4 bytes * offset



    //file with all registers that actually just a pair of muxs (selects outputs
    //from registers specified in raddr1 and raddr2).
	register_file regfile(
        .raddr1(instruction[25:21]), 
        .raddr2(instruction[20:16]), 
        .waddr(write_address),  //!! from last stage 
        .wdata(write_data),     //!! from last stage 
        .write(write),          //!! from last stage
        .clock(clock), 
        .reset(reset), 
        .rdata1(valA), 
        .rdata2(valB)
    );

	//wire [31:0] extended32; //immediate value extended to 32 bits
    wire Sign;
    //since immediate values are restricted to 16 bits, we have to extend it to 32 bits
	sign_ext SignExt(
        .in(instruction[15:0]), 
        .sign(Sign),
        .out(immediate[31:0])
    );
    
    //destination register depends on the type of instruction
    //R-type -> [15:11]
	mux2 #(5) mux2_1(instruction[20:16], instruction[15:11], reg_res, destination); 


    //mips_states control(i_data, reg_res, ALUSrc, MemToReg, reg_write, MemWrite, MemRead, branch, eq, goto_flg, Sign, ALU_ctrl);
    
    //wire [31:0] goto_addr;
    //extending 26 bits to 32 for goto
    jump_target jump_target(
        .im_val(instruction[25:0]),
        .target(goto_address),
        .curr_addr(i_address),
        .goto(signals[0])
    );        
    
    decode_signals control(instruction, reg_res, Sign, opcode, signals);

endmodule
