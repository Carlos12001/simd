
module branch_control
(
	input logic [31:0] srca2D, srcb2D,
	input logic [1:0] branchD,
	output logic pcsrcD
);
		
	always_comb
		case(branchD)
			2'b01: pcsrcD = (srca2D == srcb2D) ? 1'b1 : 1'b0; // Equal
			2'b10: pcsrcD = (srca2D < srcb2D) ? 1'b1 : 1'b0;  // Less than
			default: pcsrcD = 1'b0; // None
		endcase
	
endmodule
