module ALU_vec_aux (
	input [15:0] data_a,		// first operand
	input [15:0] data_b,		// second operand
	input [15:0] data_c,		// used to set value
	input [2:0] opcode,			// code for operation
	input flag_scalar,			// flag that indicates if its vectorial or scalar operation
	input int instance_num,		// ALU ID
	output reg [15:0] result,	
	output reg [3:0] flags		//Carry(0), Zero(1), Negative(2), Overflow(3)
);

	// Internal signals
	logic [15:0] high, mid, low, a_mult, b_mult, a_comp, b_comp, result_temp, result_comp;
	logic [16:0] extended_result;

	// two-complement of the operands
	two_complement #(.N(16)) tc_a (
		.data_in(data_a),
		.data_out(a_comp)
	);

	two_complement #(.N(16)) tc_b (
		.data_in(data_b),
		.data_out(b_comp)
	);

	always @* begin
		// multiplication partial result signals
		high = 16'b0;
		mid = 16'b0;
		low = 16'b0;

		// two-complement if signed bit in 1
		a_mult = data_a[15] ? a_comp : data_a;
		b_mult = data_b[15] ? b_comp : data_b;

		if ( (flag_scalar == 1'b1 && instance_num == 0) || (flag_scalar == 1'b0) ) begin
			case (opcode)
				3'b000: // FP multiplication
					begin
						high = a_mult[14:8] * b_mult[14:8]; //multiply integer parts
						mid = (a_mult[14:8] * b_mult[7:0]) + (b_mult[14:8] * a_mult[7:0]); // (a integer * b decimal) + (b integer * a decimal)
						low = a_mult[7:0] * b_mult[7:0]; //multiply decimal part

						result_temp = (high << 8) + mid + (low >> 8);
						result_comp = ~result_temp + 1'b1; // two-complement of the result
						
						result = (data_a[15] ^ data_b[15]) ? result_comp : result_temp; //set sign 

						flags[0] = 1'bx;	//Carry flag
						flags[3] = (high > 16'hFF); 	//Overflow flag
					end

				3'b001: begin // FP substraction
					extended_result = {1'b0, data_a} + {1'b0, b_comp};
					result = extended_result[15:0];

					flags[0] = extended_result[16]; 	// Carry flag for add
					flags[3] = (data_a[15] ^ result[15]) && ~(data_a[15] ^ data_b[15] ^ opcode[0]); // Overflow flag for add
				end

				3'b010: begin // FP add
					extended_result = {1'b0, data_a} + {1'b0, data_b};
					result = extended_result[15:0];

					flags[0] = extended_result[16]; 	// Carry flag for add
					flags[3] = (data_a[15] ^ result[15]) && ~(data_a[15] ^ data_b[15] ^ opcode[0]); // Overflow flag for add
				end

				3'b111: begin // FP set
					result = data_c;
					flags[0] = 1'b0;
					flags[3] = 1'b0;
				end

				default: // Operacion no valida
					result = 16'b0;  
			
			endcase
		end 
		else begin
			result = 16'bx;
		end
	end


	// Flags
	always @* begin
		flags[1] = (result == 16'b0);			// Zero flag
		flags[2] = result[15]; 					// Negative flag
	end

	endmodule

module two_complement #(parameter N = 16)(
	input [N-1:0] data_in,
	output [N-1:0] data_out
);
	assign data_out = ~data_in + 1'b1;
endmodule