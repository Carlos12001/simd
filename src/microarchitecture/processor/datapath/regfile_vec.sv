// Register file

module regfile_vec
(
	input logic clk,
	input logic rst,
	input logic vwe3,
	input logic [4:0] vra1, vra2, vwa3,
	input logic [255:0] vwd3,
	output logic [255:0] vrd1, vrd2,

	input logic [255:0] stall_count_out, 
	input logic [255:0] cycles_per_instruction_q78_out,
	input logic [255:0] arith_count_out,
	input logic [255:0] mem_access_count_out
);

	logic [255:0] vrf[23:16];
	
	// Writing on falling edge
	always_ff @(negedge clk) begin
		if(rst)  
			vrf[23:16] <= '{8{255'd0}};	//set all registers in zero
		if (vwe3)
			vrf[vwa3] <= vwd3;	// write register
	end


	// read registers
	always_comb begin
		case(vra1)
			5'b11000: vrd1 = stall_count_out;
			5'b11001: vrd1 = cycles_per_instruction_q78_out;
			5'b11010: vrd1 = arith_count_out; 
			5'b11011: vrd1 = mem_access_count_out; 
			default: vrd1 = vrf[vra1];
		endcase
	end

	always_comb begin
		case(vra2)
			5'b11000: vrd2 = stall_count_out;
			5'b11001: vrd2 = cycles_per_instruction_q78_out;
			5'b11010: vrd2 = arith_count_out; 
			5'b11011: vrd2 = mem_access_count_out; 
			default: vrd2 = vrf[vra2];
		endcase
	end
	
endmodule
