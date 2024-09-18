// Instructions memory

module imem
(
	input logic [5:0] a,
	output logic [31:0] rd
);

	logic [31:0] RAM[63:0];
	
	initial
	begin
		$readmemb("memory/meminstr.dat",RAM);
	end
	
	assign rd = RAM[a]; // word aligned
	
endmodule
