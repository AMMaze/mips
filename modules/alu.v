`timescale 1ns/1ns
module alu
  #(parameter Width = 32)
  ( input [Width-1:0] in1, in2,
    input [5:0] aluop,
    output reg [Width-1:0] out
  );
  
  parameter OPR_ADD = 6'b100000;
  parameter OPR_SUB = 6'b100010;
  parameter OPR_AND = 6'b100100;
  parameter OPR_OR = 6'b100101;
  parameter OPR_SLTU = 6'b101011;
  parameter OPR_SLT = 6'b101010;
  parameter OPR_ADDU = 6'b100001;
  parameter OPR_SUBU = 6'b100011;
  
  always @(in1, in2, aluop)
    case(aluop)
    OPR_ADD : out = $signed(in1) + $signed(in2);
    OPR_SUB : out = $signed(in1) - $signed(in2);
    OPR_AND : out = in1 & in2;
    OPR_OR : out = in1 | in2;
    OPR_SLTU : out = in1 < in2;
    OPR_SLT : out = $signed(in1) < $signed(in2);
    OPR_ADDU : out = in1 + in2;
    OPR_SUBU : out = in1 - in2;
    default : out = 0;
    endcase
endmodule
