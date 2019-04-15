`timescale 1ns/1ns
module fetch (
    input clock, reset, 
    input [31:0] jump_target,   //jump address
    input jump_flg,             
    input stall,
    output [31:0] instruction,  //instruction data 
    output [31:0] address       //instruction address
);


	wire [31:0] new_addr, i_addr; //instructions addresses
    //program counter that works like this: pass new instruct address -> on pos
    //edge of the clock it will change it's output (PC) for new address
	pc mips_pc(
        .clk(clock), 
        .newPC(new_addr), 
        .PC(i_addr),
        .reset(reset),
        .load(stall)
    );
	
    //selects from it's memory (just a big 'case') instruction corresponding to
    //a certain number (i.e. 'address' -- sel)
	instruction_memory mips_inst_memory(
        .sel(i_addr), 
        .out(instruction)
    );

    //returns address of a new instruction
    //offset is applied to current address only when jump is active
	next_pc NextPC(
        .currPC(i_addr), 
        .out(new_addr), 
        .jmp_addr(jump_target), 
        .jmp(jump_flg)
    );

    assign address = i_addr;
endmodule
