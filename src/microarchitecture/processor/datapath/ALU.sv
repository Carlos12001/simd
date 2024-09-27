
module ALU #(parameter N = 32)
(
	input logic [N-1:0] a, b,
	input logic [3:0] alucontrol,
	output logic [N-1:0] result,
	output logic [3:0] flags
);
				
	logic neg, zero, _carry, overflow;
	logic [N-1:0] condinvb;
	logic [N:0] sum;
	//logic [5:0] shamt;
	
	//assign shamt = b[10:6];
	
	assign condinvb = alucontrol[3] ? ~b : b;
	assign sum = a + condinvb + alucontrol[3];	
	
	always_comb
		casex (alucontrol)
			4'b0110: result = a - b; // sub
			4'b0010: result = a + b; // add
			4'b1000: result = a ^ b; // xor
			4'b1001: result = a & b; // and
			4'b1010: result = a << b; // sll
			4'b1011: result = a >> b; // srl
			4'b1100: result = a * b; // mul


			4'b??10: result = sum[31:0];
			4'b0111: result = sum[31];  // SLT
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
