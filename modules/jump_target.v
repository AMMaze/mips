`timescale 1ns/1ns
module jump_target (im_val, target, curr_addr, goto);

    input [25:0] im_val;
    input goto;
    input [31:0] curr_addr;
    output reg [31:0] target;

    always @(posedge goto)
    begin
        if (goto)
        begin
            target[31:28] = curr_addr[31:28];
            target[27:2] = im_val;
            target[1:0] = 2'b00;
        end
    end

endmodule
