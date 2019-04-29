`timescale 1ns/1ns
module data_bank (
    input clock, reset, write, valid,
    input [31:0] addr, //data_in,
    output hit
    //output [31:0] data_out
);
    /*
    cache_ram cache_ram (
        .clock(clock),
        .reset(reset),
        .write(write),
        .data_in(data_in),
        .index(addr[11:2]),
        .offset(addr[1:0]),
        .data_out(data_out)
    );
    */

    wire [3:0] tag;

    tag_ram tag_ram (
        .clock(clock),
        .reset(reset),
        .write(write),
        .tag_in(addr[15:12]),
        .index(addr[11:2]),
        .tag_out(tag)
    );

    wire _valid;

    
    v_ram v_ram (
        .clock(clock),
        .reset(reset),
        .write(write),
        .v_in(valid),
        .index(addr[11:2]),
        .v_out(_valid)
    );

    assign hit = (tag == addr[31:12]) & _valid;

endmodule
