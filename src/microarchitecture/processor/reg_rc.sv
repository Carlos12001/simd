//N bit register with reset

module reg_rc #(parameter N = 32)
(
	input logic clk, reset, clear,
	input logic [N-1:0] reg_in,
	output logic [N-1:0] reg_out
);

	always_ff @(posedge clk, posedge reset)
		if (reset) reg_out <= 0;
		else if (clear) reg_out <= 0;
		else reg_out <= reg_in;
		
endmodule
