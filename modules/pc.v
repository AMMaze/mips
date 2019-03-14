`timescale 1ns/1ns
module pc(clk, newPC, PC, reset); 
  
input clk, reset;
input [31:0] newPC;  
output [31:0] PC;  

reg [31:0] currPC;

initial begin
currPC = 0;
end

always @(posedge clk, posedge reset) begin
//always @(newPC, posedge reset) begin
    if (reset)
        currPC <= 0;
    else
        currPC <= newPC;
end

assign PC = currPC;
endmodule
