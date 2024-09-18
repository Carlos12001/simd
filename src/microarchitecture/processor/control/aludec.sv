
module aludec
(
	input logic [5:0] opcode,
	input logic [5:0] funct,
	input logic [1:0] aluop,
	output logic [2:0] alucontrol
);

	logic check_funct;

	always_comb begin
		case(opcode)
			6'b000000, 6'b010000, 6'b000100, 6'b001100: check_funct = 1; //Opcodes Aritmeticos
			default: check_funct = 0;
      endcase
		  
		if (check_funct) begin
			case(aluop)
				2'b00: alucontrol = 3'b010; // add
				2'b01: alucontrol = 3'b110; // sub
				default: case(funct) // RTYPE
								6'b000000: alucontrol = 3'b010; // add
								6'b000001: alucontrol = 3'b110; // sub
								6'b000100: alucontrol = 3'b010; // add.fp
								6'b000110: alucontrol = 3'b000; // mul.fp
								6'b100100: alucontrol = 3'b010; // vadd.fp
								6'b100110: alucontrol = 3'b000; // vmul.fp
								6'b110000: alucontrol = 3'b011; // vsum.fp
								6'b100101: alucontrol = 3'b111; // vset.fp
								
								default: alucontrol = 3'b100; // Skip
							endcase
			endcase
		end
		else begin
			alucontrol = 3'b100; //Skip, operacion no aritmetica
		end
	end

endmodule