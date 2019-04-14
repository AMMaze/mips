`timescale 1ns/1ns
module test_bench ();

	reg osc;
	reg rst;
    reg change, step;
	initial begin
		osc = 0;
		rst = 1;
        change = 0;
        step = 0;
	end
    
    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0, test_bench);
    end

	always begin
		if(rst == 1)
			#10 rst = 0;
		else
			#10 osc = ~osc;
	end
	
    initial begin
        //change = 0;
        #50
        change = 1;
        #10
        step = 1;
        change = 0;
        #10
        step = 0;
        #10
        step = 1;
        #2
        change = 1;
        #1
        change = 0;
        #30
        change = 1;
        #250
        $finish;
    end

    pipeline mips_mod(
        .clock(osc),
        .reset(rst),
        .change(change),
        .step(step)
    );

endmodule
