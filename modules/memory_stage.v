`timescale 1ns/1ns
module memory_stage (
    input clock, reset,
    input [31:0] alu_result,
    input [31:0] valB,
    input [7:0] signals,
    output [31:0] final_data,
    output stall
);


	//signals[7]: wire ALUSrc; //true: second operand is extended [15:0] (constant, offset); false: second operand is [20:16] (register)
	//signals[6]: wire MemToReg; //from memory to register (LW)
	//signals[5]: wire reg_write; //true: write to register
	//signals[4]: wire MemRead; //read from memory (LW)
	//signals[3]: wire MemWrite; //write to memory (SW)
	//signals[2]: wire branch; //jump indicator
	//signals[1]: wire eq; //jump on equal (subtraction == zero)
    //signals[0]: wire goto_flg; //next instruction: pc + 4 bytes * offset


    wire [31:0] memory_data;
	//connection with ram if carried out through cache
    memory_cache data_mem(
        .clock(clock),
        .reset(reset),
        .read(signals[4]), 
        .write(signals[3]), 
        .address(alu_result), 
        .data_in(valB), 
        .data_out(memory_data),
        .stall(stall)
    );


    mux2 mux2_m (
        .i0(alu_result),
        .i1(memory_data),
        .s(signals[6]),
        .o(final_data)
    );

endmodule
