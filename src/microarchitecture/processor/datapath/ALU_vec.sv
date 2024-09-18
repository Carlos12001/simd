 module ALU_vec (
	input [255:0] a,		// vector register operand A
	input [255:0] b,		// vector register operand B
	input [15:0] c,			// scalar register operand (for vset_fp instruction)
	input [2:0] opcode,
	input flag_scalar,		// flag to use only first element of vector to operate
	output reg [255:0] result,
	output reg [63:0] flags
);

	logic [255:0] result_alu;
	logic [15:0] sum_out;

	localparam NUM_INSTANCES = 16;	// Total amount of instances 
	localparam bits_index = 16;		// Index to access to required bits for A and B
	localparam flags_index = 4; 	// Index to access to required flags bits 

	// ALU_vec_aux instances generation
	genvar i;
	generate
		for (i = 0; i < NUM_INSTANCES; i = i + 1) begin : alu_instance

			ALU_vec_aux alu (
				.data_a(a[15 + bits_index*i : 0 + bits_index*i]),
				.data_b(b[15 + bits_index*i : 0 + bits_index*i]),
				.data_c(c),
				.opcode(opcode), 
				.flag_scalar(flag_scalar),
				.instance_num(i),
				.result(result_alu[15 + bits_index*i : 0 + bits_index*i]),
				.flags(flags[3 + flags_index*i : 0 + flags_index*i])
			);
		end
	endgenerate

	sum alu_sum(a, sum_out);

	assign result = (opcode == 3'b011) ? {240'b0, sum_out} : result_alu;

endmodule
