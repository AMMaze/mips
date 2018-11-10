`timescale 1ns/1ns
module sign_ext #(parameter Width = 16) 
                 (input [Width - 1:0] in, input sign, output reg [31:0] out);
    
    always @(in, sign)
    begin
        if (sign)
            out <= $signed (in);
        else begin
            out[31:Width] <= 0;
            out[Width - 1:0] <= in;
        end
    end
    
endmodule
