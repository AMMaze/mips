`timescale 1ns/1ns
module memory(read, write, addr, data_in, data_out);

    input read;                       
    input write;                      
    input [7:0] addr;   
    input [31:0] data_in;     
    output [31:0] data_out;  
  
    reg   [31:0] DATABUS_driver;
    wire  [31:0] data_out = DATABUS_driver;
    reg   [31:0] ram[0:255];           

    integer i;

    initial     
    begin
        DATABUS_driver = 0;
        for (i=0; i <= 255; i = i + 1)
            ram[i] = i*10 + 1;
    end

    always @(read or write or addr or data_in)
    begin
        if (write)
            ram[addr] = data_in;
        
        DATABUS_driver =  ram[addr];
    end
endmodule
