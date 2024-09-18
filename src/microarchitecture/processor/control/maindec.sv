
module maindec
(
	input logic [5:0] op,
	output logic regWrite, VregWrite,
	output logic memtoReg, memWrite, memData, memSrc,
	output logic ALUSrc, scalar, regDst, 
	output logic [1:0] branch, 
	output logic jump,
	output logic [1:0] aluop,
	output logic pmc_en
);

	logic [14:0] controls;
	assign {regWrite, VregWrite, memtoReg, memWrite, memData, memSrc,   ALUSrc, scalar, regDst,   branch, jump, aluop, pmc_en} = controls;
	
	always_comb
		case(op)
			6'b000000: controls = 15'b_10_0000_001_00_0_10_0; // add, sub
			6'b010000: controls = 15'b_10_0000_100_00_0_00_0; // addi
			6'b000100: controls = 15'b_01_0000_011_00_0_10_0; // add.fp, mul.fp
			6'b001100: controls = 15'b_01_0000_001_00_0_10_0; // vadd.fp, vmul.fp, vsum.fp
			6'b010001: controls = 15'b_00_0100_100_00_0_00_0; // sw
			6'b010010: controls = 15'b_10_1000_100_00_0_00_0; // lw
			6'b010101: controls = 15'b_00_0110_100_00_0_00_0; // sw.fp
			6'b010110: controls = 15'b_01_1010_100_00_0_00_0; // lw.fp
			6'b011101: controls = 15'b_00_0101_100_00_0_00_0; // vst
			6'b011110: controls = 15'b_01_1001_100_00_0_00_0; // vld
			6'b100000: controls = 15'b_00_0000_000_01_0_00_0; // beq
			6'b100001: controls = 15'b_00_0000_000_10_0_00_0; // blt
			6'b100010: controls = 15'b_00_0000_000_00_1_00_0; // j
			6'b111111: controls = 15'b_01_0000_100_00_0_01_0; // vset.fp
			6'b110010: controls = 15'b_00_0000_000_00_0_00_1; // start
			6'b110001: controls = 15'b_00_0000_000_00_0_00_1; // close
			  default: controls = 15'b_00_0000_000_00_0_00_0; // ??
			  
		endcase
	
endmodule
