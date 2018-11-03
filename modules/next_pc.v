`timescale 1ns/1ns
module next_pc (currPC, out, offset, jmp); 
  input [31:0] currPC, offset;
  input jmp;
  output reg [31:0] out;

	always @(currPC, jmp, offset)
		if (jmp == 0)
			out <= currPC + 32'd4;
		else
			out <= currPC + 32'd4 + 32'd4 * offset;	  
endmodule
