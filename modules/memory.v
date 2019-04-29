`timescale 1ns/1ns
module memory(clock, read, write, addr, data_in, data_out);

    input clock;
    input read;                       
    input write;                      
    input [31:0] addr;   
    input [31:0] data_in;     
    output [31:0] data_out;  
  
    reg   [31:0] DATABUS_driver;
    wire  [31:0] data_out = DATABUS_driver;
    reg   [31:0] ram[0:2**16-1];           

    //reg [31:0] data_out;

    integer i;

    initial     
    begin
        DATABUS_driver = 0;
        for (i=0; i < 2**16; i = i + 1)
            ram[i] <= i*10 + 1;
    end

    //always @(read or write or addr or data_in)
    always @(posedge clock)
    begin
        //$display("ram[3] = %0d, address = %0d, input = %0d", ram[3], addr, data_in);
        if (write)
            ram[addr[15:0]] = data_in;
        
        DATABUS_driver =  ram[addr[15:0]];
    end
endmodule
