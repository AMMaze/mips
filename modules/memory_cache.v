`timescale 1ns/1ns
module memory_cache (
    input clock, reset, read, write, 
    input [31:0] address, data_in,
    output [31:0] data_out,
    output stall
);

    wire ready;
    
    wire hit, utag, ucache;
    wire [127:0] mdata_out;//, cache_data;

    //arrays with tag and valid arrays
    data_bank #(1024) data_bank1 (
        .clock(clock),
        .reset(reset),
        .write(utag),
        .valid(1'b1),
        .addr(address),
        .hit(hit)
    );


    //array with cached data
    cache_ram cache_ram (
        .clock(clock),
        .reset(reset),
        .write(ucache),
        .data_in(data_in),
        .line_in(mdata_out),
        .in_sel(~utag),
        .index(address[11:2]),
        .offset(address[1:0]),
        .data_out(data_out)
    );

    //data loaded from memory (array)
    //memory implemented by means of arrays
    memory memory (
        .clock(clock),
        .read(read),
        .write(write),
        .addr(address),
        .data_in(data_in),
        .data_out(mdata_out)
    );

    
    //fsm for read/write process 
    mem_control control (
       .clock(clock),
       .reset(reset),
       .write(write),
       .read(read),
       .hit(hit),
       .update_tag(utag),
       .update_cache(ucache),
       .ready(ready)
    );

    assign stall = ~ready & (write | read);

endmodule
