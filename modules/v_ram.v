`timescale 1ns/1ns
module v_ram 
#(parameter CACHESIZE = 1024)
(
    input clock, reset, write,
    input v_in,
    input [9:0] index,
    output v_out
);

    reg v_out;
    reg v_ram [0:CACHESIZE-1];

    
    integer i;
    always @(reset)
        for (i = 0; i < CACHESIZE; i = i + 1)
            v_ram[i] = 0;

    //always @(write or index or v_in) begin
    always @(posedge clock) begin
        if (write)
            v_ram[index] = v_in;
        v_out = v_ram[index];    
    end


endmodule
