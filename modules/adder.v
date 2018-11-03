`timescale 1ns/1ns
module adder
  #(parameter Width = 32)
  ( input [Width-1:0] in1,
    input [Width-1:0] in2,
    output [Width-1:0] out
  );
  assign out = in1 + in2;
endmodule
