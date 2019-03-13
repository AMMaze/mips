`timescale 1ns/1ns
module adder
#(parameter Width = 32)
(
    input [Width - 1:0] x,
    input [Width - 1:0] y,
    output [Width - 1:0] out
);

    assign out = x + y;

endmodule
