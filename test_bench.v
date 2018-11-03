`timescale 1ns/1ns
module test_bench ();

	reg osc;
	reg rst;
	initial begin
		osc = 0;
		rst = 1;
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
	wire clk;
	assign clk = osc; 
	

	wire reset;
	assign reset = rst;

	wire reg_res; //true: write to [15:11] reg (third) (ADDI, LW); false: write to [20:16] reg (second) (R)
	wire ALUSrc;
	wire MemToReg; //from memory to register (LW)
	wire reg_write; //true: write to register
	wire MemWrite; //write to memory (SW)
	wire MemRead; //read from memory (LW)
	wire eq;
	wire branch, pc_ctrl;
	wire [5:0] ALU_ctrl;

	wire [31:0] new_addr, i_addr;
	pc mips_pc(clk, new_addr, i_addr);
	
	wire [31:0] i_data;
	instruction_memory mips_im(i_addr, i_data);
	
	wire [4:0] write_addr;
	wire [31:0] read_data1, read_data2, write_data;
	register_file regfile(i_data[25:21], i_data[20:16], write_addr, write_data, reg_write, clk, reset, read_data1, read_data2);
	
	wire [31:0] ALU_input, ALU_out;
	alu mips_alu(read_data1, ALU_input, ALU_ctrl, ALU_out);
	
	wire [31:0] mem_data;
	memory dm(MemRead, MemWrite, ALU_out[7:0], read_data2, mem_data);

	wire [31:0] extended32;
	sign_ext SignExt(i_data[15:0], extended32[31:0]);
	
	assign pc_ctrl = ((ALU_out != 32'd0)^eq) ? branch : 0;

	next_pc NextPC(i_addr, new_addr, extended32, pc_ctrl);
	
	mux2 #(5) mux2_1(i_data[20:16], i_data[15:11], reg_res, write_addr); 
	mux2 mux2_2(read_data2, extended32, ALUSrc, ALU_input); 
	mux2 mux2_3(ALU_out, mem_data, MemToReg, write_data); 
	
	mips_states control(i_data, reg_res, ALUSrc, MemToReg, reg_write, MemWrite, MemRead, branch, eq, ALU_ctrl);
	
endmodule
