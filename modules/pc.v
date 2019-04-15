`timescale 1ns/1ns
module pc(clk, newPC, PC, reset, load); 
  
input clk, reset;
input [31:0] newPC;  
output [31:0] PC;  
input load;

reg [31:0] currPC;

initial begin
currPC = 0;
end

always @(posedge clk, posedge reset) begin
    if (reset)
        currPC <= 0;
    else if (!load)
        currPC <= newPC;
end

assign PC = currPC;
endmodule
