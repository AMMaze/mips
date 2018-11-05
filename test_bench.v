`timescale 1ns/1ns
module test_bench ();

	reg osc;
	reg rst;
    reg change, step;
	initial begin
		osc = 0;
		rst = 1;
        change = 0;
        step = 0;
	end
    
    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, test_bench);
    end

	always begin
		if(rst == 1)
			#100 rst = 0;
		else
			#100 osc = ~osc;
	end
	
    mips mips_mod(
        .clock(osc),
        .reset(rst),
        .change(change),
        .step(step)
    );

    /*
    wire clk;
	assign clk = osc; 
	

	wire reset;
	assign reset = rst;

	wire reg_res; //true: write to [15:11] reg (third) (ADDI, LW); false: write to [20:16] reg (second) (R)
	wire ALUSrc; //true: second operand is extended [15:0] (constant, offset); false: second operand is [20:16] (register)
	wire MemToReg; //from memory to register (LW)
	wire reg_write; //true: write to register
	wire MemWrite; //write to memory (SW)
	wire MemRead; //read from memory (LW)
	wire eq; //jump on equal (subtraction == zero)
	wire branch; //jump indicator
    wire pc_ctrl; //next instruction: pc + 4 bytes * offset
	wire [5:0] ALU_ctrl; //alu opcode

	wire [31:0] new_addr, i_addr; //instructions addresses
    //program counter that works like this: pass new instruct address -> on pos
    //edge of the clock it will change it's output (PC) for new address
	pc mips_pc(
        .clk(clk), 
        .newPC(new_addr), 
        .PC(i_addr)
    );
	
	wire [31:0] i_data; //instruction data
    //selects from it's memory (just a big 'case') instruction corresponding to
    //a certain number (i.e. 'address' -- sel)
	instruction_memory mips_inst_memory(
        .sel(i_addr), 
        .out(i_data)
    );
	
	wire [4:0] write_addr; //write to this register
	wire [31:0] read_data1; //data from first register [25:21]
    wire [31:0] read_data2; //data from second register [20:16]
    wire [31:0] write_data; //data for writing into the write_addr
    //file with all registers that actually just a pair of muxs (select outputs
    //from registers specified in raddr1 and raddr2).
	register_file regfile(
        .raddr1(i_data[25:21]), 
        .raddr2(i_data[20:16]), 
        .waddr(write_addr), 
        .wdata(write_data), 
        .write(reg_write), 
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
        .aluop(ALU_ctrl), 
        .out(ALU_out)
    );
	
	wire [31:0] mem_data; //data loaded from memory (array)
    //memory implemented by means of arrays
    memory data_mem(
        .read(MemRead), 
        .write(MemWrite), 
        .addr(ALU_out[7:0]), 
        .data_in(read_data2), 
        .data_out(mem_data)
    );

	wire [31:0] extended32; //constant extended to 32 bits
    //since constants are restricted to 16 bits, we have to extend it to 32 bits
	sign_ext SignExt(
        .in(i_data[15:0]), 
        .out(extended32[31:0])
    );
	
    //interpretation of ALU_out, that is basically just a subtraction of given operands,  
    //depends on the type of an instruction (bne/beq) 
	assign pc_ctrl = ((ALU_out != 32'd0)^eq) ? branch : 0;

    //returns address of a new instruction
    //offset is applied to current address only when jump is active
	next_pc NextPC(
        .currPC(i_addr), 
        .out(new_addr), 
        .offset(extended32), 
        .jmp(pc_ctrl)
    );
	
    //destination register depends on the type of instruction
    //R-type -> [15:11]
	mux2 #(5) mux2_1(i_data[20:16], i_data[15:11], reg_res, write_addr); 
    //source for second operand in ALU: constant/register
	mux2 mux2_2(read_data2, extended32, ALUSrc, ALU_input); 
    //for lw-op result is loaded from memory, in other cases - output from alu
	mux2 mux2_3(ALU_out, mem_data, MemToReg, write_data); 
	
	mips_states control(i_data, reg_res, ALUSrc, MemToReg, reg_write, MemWrite, MemRead, branch, eq, ALU_ctrl);
    */

endmodule
