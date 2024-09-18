// Register file

module regfile
(
	input logic clk,
	input logic rst,
	input logic we3,
	input logic [4:0] ra1, ra2, wa3,
	input logic [31:0] wd3,
	output logic [31:0] rd1, rd2
);

	logic [31:0] rf[31:0];
	
	// Writing on falling edge
	always_ff @(negedge clk) begin
		if(rst)
			rf[31:0] <= '{32{32'd0}};	// set initial value
		
		if (we3 && wa3 != 4'b0) 
			rf[wa3] <= wd3;	// write register value (ignore if trying to write $zero)
	end
	
	assign rd1 = rf[ra1];	// read register 1
	assign rd2 = rf[ra2];	// read register 2
	
endmodule
 