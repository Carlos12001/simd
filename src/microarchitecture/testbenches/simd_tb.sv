
module simd_tb();
	logic clk;
	logic reset;
	
	logic [31:0] writedata, dataadr;
	logic memwrite;
	logic [31:0] pcF, instr, readdata;
	logic src_sel;
	logic [255:0] w_data_b;
	logic [15:0] q_a;
	logic [255:0] q_b;
	
	// instantiate device to be tested
	simd_processor dut (clk, reset, pcF, instr, memwrite, src_sel, dataadr, writedata, readdata, w_data_b, q_b);
	// initialize test
	initial
	begin
		reset <= 1; # 11; reset <= 0;
		          
	end
	
	// generate clock to sequence tests
	always
	begin
		clk <= 1; # 5; clk <= 0; # 5;
	end
	
	// check results
	always @(negedge clk)
	begin
		
	end
	
endmodule
