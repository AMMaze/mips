`timescale 1ns/1ns
module data_haz_control (
    input [4:0] raddr, dest2, dest3, dest4, 
    input rwrt2, rwrt3, rwrt4,
    input memtoreg2,
    output reg [1:0] out,
    output reg stall
);

    always @(raddr, dest2, dest3, dest4, rwrt2, rwrt3, rwrt4)
    begin
        if ((raddr == dest2) && rwrt2) begin
            if(memtoreg2)
                stall = 1;
            else begin
                out = 2'b01;
                stall = 0;
            end
        end
        else if ((raddr == dest3) && rwrt3) begin
            out = 2'b10;
            stall = 0;
        end
        else if ((raddr == dest4) && rwrt4) begin
            out = 2'b11;
            stall = 0;
        end
        else begin 
            out = 2'b00;
            stall = 0;
        end
    end

endmodule
