`timescale 1ns/1ns
module next_pc (clock, reset, currPC, out, jmp_addr, jmp); 
  input clock, reset;
  input [31:0] currPC, jmp_addr;
  input jmp;
  output reg [31:0] out;

	always @(currPC, jmp, jmp_addr)
    //always @(posedge clock, posedge reset)
    begin
        //if (reset == 1)
        //    out = 0;
        if (jmp == 0)
			out <= currPC + 32'd4;
		else
			out <= jmp_addr;	  
    end
endmodule
