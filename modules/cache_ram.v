`timescale 1ns/1ns
module cache_ram 
#(parameter CACHESIZE = 1024)
(
    input clock, reset, write,
    input [31:0] data_in,
    input [127:0] line_in,
    input in_sel,
    input [9:0] index,
    input [1:0] offset,
    output [31:0] data_out
);

    reg [31:0] data_out;
    reg [127:0] data_ram [0:CACHESIZE-1];

    integer i;
    always @(reset)
        for (i = 0; i < CACHESIZE; i = i + 1)
            data_ram[i] = 128'd0;

    //always @(write or data_in or index) begin
    always @(posedge clock) begin
        if (write) begin
            if (in_sel)
                //data_ram[index][32*(offset+1)-1:32*offset] = data_in;
                case(offset)
                    2'b00:
                        data_ram[index][127:96] = data_in;
                    2'b01:
                        data_ram[index][95:64] = data_in;
                    2'b10:
                        data_ram[index][63:32] = data_in;
                    2'b11:
                        data_ram[index][31:0] = data_in;
                endcase
            else 
                data_ram[index] = line_in;
        end
        //data_out = data_ram[index][32*(offset+1)-1:32*offset];    
        case(offset)
            2'b00:
                data_out = data_ram[index][127:96];
            2'b01:
                data_out = data_ram[index][95:64];
            2'b10:
                data_out = data_ram[index][63:32];
            2'b11:
                data_out = data_ram[index][31:0];
        endcase
    end

endmodule
