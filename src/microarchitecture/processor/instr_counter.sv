module instr_counter(
    input logic clk,       // Señal de reloj
    input logic reset,     // Señal de reset
	input logic global_en,
    input logic [5:0] opcode_in,
	 input logic [5:0] funct_in,
	 input logic jmp_in,
	 input logic [1:0] branch_in,
    output logic [31:0] ADD_count,
	 output logic [31:0] SUB_count,
	 output logic [31:0] ADDI_count,
	 output logic [31:0] ADD_FP_count,
	 output logic [31:0] MUL_FP_count,
	 output logic [31:0] VADD_FP_count,
	 output logic [31:0] VMUL_FP_count,
	 output logic [31:0] VSUM_FP_count,
	 output logic [31:0] VSET_FP_count,
	 output logic [31:0] SW_count,
	 output logic [31:0] LW_count,
	 output logic [31:0] SW_FP_count,
	 output logic [31:0] LW_FP_count,
	 output logic [31:0] VST_count,
	 output logic [31:0] VLD_count,
	 output logic [31:0] BEQ_count,
	 output logic [31:0] BLT_count,
	 output logic [31:0] J_count
);


	always @(posedge clk or posedge reset) begin
	  if (reset) begin
			ADD_count <= 0;
			SUB_count <= 0;
			ADDI_count <= 0;
			ADD_FP_count <= 0;
			MUL_FP_count <= 0;
			VADD_FP_count <= 0;
			VMUL_FP_count <= 0;
			VSUM_FP_count <= 0;
			VSET_FP_count <= 0;
			SW_count <= 0;
			LW_count <= 0;
			SW_FP_count <= 0;
			LW_FP_count <= 0;
			VST_count <= 0;
			VLD_count <= 0;
			BEQ_count <= 0;
			BLT_count <= 0;
			J_count <= 0;
			
	  end else if (global_en) begin	
			
			case(opcode_in) 
				6'b000000 : begin //OPERACION ARITMETICA CON INTS
					case (funct_in) 
						6'b000000 : ADD_count <= ADD_count + 1;
						6'b000001 : SUB_count <= SUB_count + 1;
					endcase
				end
				6'b010000 : begin //OPERACION ARITMETICA CON INTS
					case (funct_in) 
						6'b000000 : ADDI_count <= ADDI_count + 1;
					endcase
				end
				
				6'b000100 : begin //OPERACION ARITMETICA CON FLOATING POINT
					case (funct_in) 
						6'b000100 : ADD_FP_count <= ADD_FP_count + 1;
						6'b000110 : MUL_FP_count <= MUL_FP_count + 1;
					endcase
				end
				6'b001100 : begin //OPERACION ARITMETICA CON VECTORES DE FLOATING POINT
					case (funct_in) 
						6'b100100 : VADD_FP_count <= VADD_FP_count + 1;
						6'b100110 : VMUL_FP_count <= VMUL_FP_count + 1;
						6'b110000 : VSUM_FP_count <= VSUM_FP_count + 1;
					endcase
				end
				6'b010001 : SW_count <= SW_count + 1;
				6'b010010 : LW_count <= LW_count + 1;
				6'b010101 : SW_FP_count <= SW_FP_count + 1;
				6'b010110 : LW_FP_count <= LW_FP_count + 1;
				6'b011101 : VST_count <= VST_count + 1;
				6'b011110 : VLD_count <= VLD_count + 1;
				6'b111111 : VSET_FP_count <= VSET_FP_count + 1;
			endcase
			
			if (jmp_in) begin
				J_count <= J_count + 1;
			end
			if (branch_in[1]) begin
				BLT_count <= BLT_count + 1;
			end
			if (branch_in[0]) begin
				BEQ_count <= BEQ_count + 1;
			end
			
	  end
	end


endmodule