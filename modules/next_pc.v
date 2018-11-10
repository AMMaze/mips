`timescale 1ns/1ns
module next_pc (currPC, out, offset, jmp, goto); 
  input [31:0] currPC, offset;
  input jmp, goto;
  output reg [31:0] out;

	always @(currPC, jmp, offset, goto)
    begin
        if (goto)
            out <= offset;
		else if (jmp == 0)
			out <= currPC + 32'd4;
		else
			out <= currPC + 32'd4 + 32'd4 * offset;	  
    end
endmodule
