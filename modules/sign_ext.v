`timescale 1ns/1ns
module sign_ext #(parameter Width = 16) 
                 (input [Width - 1:0] in, output reg [31:0] out);
    
    always @(in)             
        out <= $signed (in);
    
endmodule
