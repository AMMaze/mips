`timescale 1ns/1ns
module next_pc (currPC, out, jmp_addr, jmp); 
  input [31:0] currPC, jmp_addr;
  input jmp;
  output reg [31:0] out;

	always @(currPC, jmp, jmp_addr)
    begin
        if (jmp == 0)
			out <= currPC + 32'd4;
		else
			out <= jmp_addr;	  
    end
endmodule
