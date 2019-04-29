`timescale 1ns/1ns
module tag_ram 
#(parameter CACHESIZE = 1024)
(
    input clock, reset, write,
    input [3:0] tag_in,
    input [9:0] index,
    output [3:0] tag_out
);

    reg [3:0] tag_out;
    reg [3:0] tag_ram [0:CACHESIZE-1];

    integer i;
    always @(reset)
        for (i = 0; i < CACHESIZE; i = i + 1)
            tag_ram[i] = 4'd0;

    //always @(write or tag_in or index) begin
    always @(posedge clock) begin
        if (write)
            tag_ram[index] = tag_in;
        tag_out = tag_ram[index];    
    end

endmodule
