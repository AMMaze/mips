`timescale 1ns/1ns
module alu
  #(parameter Width = 32)
  ( input [Width-1:0] in1, in2,
    input [5:0] aluop,
    output reg [Width-1:0] out
  );
  
  parameter OPR_ADD = 6'b100000;
  parameter OPR_SUB = 6'b100010;
  
  always @(in1, in2, aluop)
    case(aluop)
    OPR_ADD : out = in1 + in2;
    OPR_SUB : out = in1 - in2;
    default : out = 0;
    endcase
endmodule
