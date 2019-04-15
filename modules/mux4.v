// обычный мультиплексор: на выход o выдаётся значение ij, где j = s
// Width - ширина мультиплексируемых данных, по умолчанию - 32
`timescale 1ns/1ns
module mux4
  #(parameter Width = 32)
  ( input [Width-1:0] i0, i1, i2, i3,
    input [1:0] s,
    output reg [Width-1:0] o
  );
  
  always @(s, i0, i1, i2, i3)
    case(s)
    3'd0: o = i0;
    3'd1: o = i1;
    3'd2: o = i2;
    3'd3: o = i3;
    default: o = 0;
    endcase
endmodule
