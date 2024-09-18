
module ALU #(parameter N = 32)
(
	input logic [N-1:0] a, b,
	input logic [2:0] alucontrol,
	output logic [N-1:0] result,
	output logic [3:0] flags
);
				
	logic neg, zero, _carry, overflow;
	logic [N-1:0] condinvb;
	logic [N:0] sum;
	//logic [5:0] shamt; 
	
	//assign shamt = b[10:6];
	
	assign condinvb = alucontrol[2] ? ~b : b;
	assign sum = a + condinvb + alucontrol[2];	
	
	always_comb
		casex (alucontrol)
			3'b000: result = a & b;
			3'b001: result = a | b;
			3'b?10: result = sum[31:0];
			3'b111: result = sum[31];  // SLT
			//3'b010: result = a >> shamt;
			//3'b011: result = a << shamt;
			default: result = 0;
		endcase
		
	assign neg = result[31];
	assign zero = (result == 0);
	assign _carry = (alucontrol[1] == 1'b0) & sum[32];
	assign overflow = (alucontrol[1] == 1'b0) & ~(a[31] ^ b[31] ^ alucontrol[0]) & (a[31] ^ sum[31]);
	assign flags = {neg, zero, _carry, overflow};
	
endmodule
