`timescale 1ns/1ns
module memory_cache (
    input clock, reset, read, write, 
    input [31:0] address, data_in,
    output [31:0] data_out,
    output stall
);

    wire ready;
    /*
    wire hit;
    wire [127:0] mdata_out;//, cache_data;
    //assign cache_data = ~hit & ~write ? mdata_out : data_in; 
    data_bank #(1024) data_bank1 (
        .clock(clock),
        .reset(reset),
        .write((write & hit) | (~hit & read)),
        .valid(1'b1),
        .addr(address),
        //.data_in(cache_data),
        .hit(hit)
        //.data_out(data_out)
    );


    wire [31:0] test;
    cache_ram cache_ram (
        .clock(clock),
        .reset(reset),
        .write((write & hit) | (~hit & read)),
        .data_in(data_in),
        .line_in(mdata_out),
        .in_sel(hit),
        .index(address[11:2]),
        .offset(address[1:0]),
        .data_out(test)
    );
*/

    memory memory (
        .clock(clock),
        .read(read),
        .write(write),
        .addr(address),
        .data_in(data_in),
        .data_out(data_out)
    );


   mem_control control (
       .clock(clock),
       .reset(reset),
       .write(write),
       .read(read),
       .ready(ready)
   );

/*
    wire ready;
    accumulate acc (
        .clock(clock),
        .reset(reset),
        .val(2'b10),
        .load((~hit & read)),
        .ready(ready)
    );
*/
    //assign stall = (~hit & read);// | (~ready & read);
    assign stall = ~ready & (write | read);

endmodule
