`timescale 1ns/1ns
module execute (
    input clock, reset, 
    input [31:0] i_address,
    input [31:0] goto_address,
    input [31:0] valA,
    input [31:0] valB,
    input [31:0] offset,
    input [4:0] destination,
    input [5:0] opcode,
    input [7:0] signals,
    output [31:0] jump_address,
    output jump,
    output [31:0] alu_result
);

	//signals[7]: wire ALUSrc; //true: second operand is extended [15:0] (constant, offset); false: second operand is [20:16] (register)
	//signals[6]: wire MemToReg; //from memory to register (LW)
	//signals[5]: wire reg_write; //true: write to register
	//signals[4]: wire MemRead; //read from memory (LW)
	//signals[3]: wire MemWrite; //write to memory (SW)
	//signals[2]: wire branch; //jump indicator
	//signals[1]: wire eq; //jump on equal (subtraction == zero)
    //signals[0]: wire goto_flg


    wire [31:0] ALU_input; //input for ALU
    //alu itself is quite simple: two operands and opcode
    //but we need separate wire ALU_input, since the second operand depends on
    //instruction type
	alu mips_alu(
        .in1(valA), 
        .in2(ALU_input), 
        .aluop(opcode), 
        .out(alu_result)
    );


    //interpretation of ALU_out, that is basically just a subtraction of given operands,  
    //depends on the type of an instruction (bne/beq) 
	assign jump = (((alu_result != 32'd0)^signals[1]) ? signals[2] : 0) | signals[0];

    //result address for conditional jump (+offset)
    wire [31:0] cond_addr;
    adder #(32) cond(
        .x(32'd4 + 32'd4 * offset),
        .y(i_address),
        .out(cond_addr)
    );

    //deciding whether we should use offset for conditional jump or address for
    //goto
    mux2 #(32) mux2_jump(cond_addr, goto_address, signals[0], jump_address); 
    
    
    //source for second operand in ALU: constant/register
	mux2 mux2_2(valB, offset, signals[7], ALU_input); 
    

endmodule
