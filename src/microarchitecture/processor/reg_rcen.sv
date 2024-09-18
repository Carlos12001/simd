//N bit register with reset, clear and enable

module reg_rcen #(parameter N = 32)
(
	input logic clk, reset, en, clear, 
	input logic [N-1:0] d,
	output logic [N-1:0] q
);
	
	always_ff @(posedge clk, posedge reset)
		if (reset) q <= 0;
		else if (clear) q <= 0;
		else if (en) q <= d;
		else q <= q;
		
endmodule
