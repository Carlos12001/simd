
module muxclock
(
	input logic clk_c, clk_b,
	input logic debug,
	output logic clk,
	input logic [31:0] pcF
);
												
	assign clk = debug || pcF > 60 ? clk_b : clk_c;
	
endmodule