`timescale 1ns/1ns
module pc(clk, newPC, PC); 
  
input clk;
input [31:0] newPC;  
output [31:0] PC;  

reg [31:0] currPC;

initial begin
currPC = 0;
end

always @(posedge clk) begin
  currPC = newPC;
end

assign PC = currPC;
endmodule
