
module aludec
(
	input logic [5:0] opcode,
	input logic [5:0] funct,
	input logic [1:0] aluop,
	output logic [3:0] alucontrol
);

	logic check_funct;

	always_comb begin
		case(opcode)
			6'b000000, 6'b010000, 6'b000100, 6'b001100: check_funct = 1; //Opcodes Aritmeticos
			default: check_funct = 0;
      endcase
		  
		if (check_funct) begin
			case(aluop)
				2'b00: alucontrol = 4'b0010; // add
				2'b01: alucontrol = 4'b0110; // sub
				default: case(funct) // RTYPE
								6'b000000: alucontrol = 4'b0010; // add
								6'b000001: alucontrol = 4'b0110; // sub
								6'b000010: alucontrol = 4'b1000; // xor
								6'b000011: alucontrol = 4'b1001; // and
								6'b000101: alucontrol = 4'b1010; // sll
								6'b000111: alucontrol = 4'b1011; // srl
								6'b001000: alucontrol = 4'b1100; // mul
								
								6'b000100: alucontrol = 4'b0010; // add.fp
								6'b000110: alucontrol = 4'b0000; // mul.fp
								6'b100100: alucontrol = 4'b0010; // vadd.fp
								6'b100110: alucontrol = 4'b0000; // vmul.fp
								6'b110000: alucontrol = 4'b0011; // vsum.fp
								6'b100101: alucontrol = 4'b0111; // vset.fp
								
								default: alucontrol = 4'b0100; // Skip
							endcase
			endcase
		end
		else begin
			alucontrol = 3'b100; //Skip, operacion no aritmetica
		end
	end

endmodule