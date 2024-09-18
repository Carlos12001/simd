`timescale 1 ps / 1 ps
module general_tb();
	logic clk;
	logic reset;
	
	// instantiate device to be tested
	top dut(clk, reset);

	// Clock generation
    initial begin
        clk = 0;
        forever #10 clk = !clk; // 50MHz clock
    end
	
	// initialize test
	initial
	begin
		reset <= 1; # 22; reset <= 0;
	end
	
	
	
endmodule
