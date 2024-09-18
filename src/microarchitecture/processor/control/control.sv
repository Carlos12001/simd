// Processor's Controller

module control
(
	input logic clk, reset,
	input logic [5:0] opD, functD, 
	output logic [5:0] opM, functM,
	input logic [31:0] srca2D, srcb2D,
	input logic flushE,

	output logic jumpD,
	output logic [1:0] branchD,
	output logic pcsrcD, alusrcE, scalarE,
	output logic [2:0] alucontrolE,
	output logic regdstE,
	output logic memwriteE, memwriteM, memdataM, memsrcM,
	output logic regwriteE, regwriteM, VregwriteM, regwriteW, VregwriteW,
	output logic memtoregE, memtoregM, memtoregW,

	input logic stallE, stallM, stallW,

	output logic pmc_en
);


	logic [1:0] aluopD;
	logic memtoregD, memwriteD, alusrcD, scalarD, 
			regdstD, regwriteD, VregwriteD, memdataD;
	logic [2:0] alucontrolD;
	logic memdataE, memsrcD, memsrcE;
	logic VregwriteE, VmemtoregM;
	logic [5:0] opE, functE;
	
	maindec md
	(
		opD,
		regwriteD, VregwriteD, 
		memtoregD, memwriteD, memdataD, memsrcD,
		alusrcD, scalarD, regdstD, 
		branchD,
		jumpD,	
		aluopD,
		pmc_en
	);
	
	aludec ad(opD, functD, aluopD, alucontrolD);
	
	branch_control _bc (srca2D, srcb2D, branchD, pcsrcD);
	
	
	
	// pipeline registers
	reg_rcen #(24) regE
	(
		clk, reset, ~stallE, flushE,
		{memtoregD, memwriteD, memdataD, memsrcD, alusrcD, scalarD, regdstD, regwriteD, VregwriteD, alucontrolD, opD, functD},
		{memtoregE, memwriteE, memdataE, memsrcE, alusrcE, scalarE, regdstE, regwriteE, VregwriteE, alucontrolE, opE, functE}
	);

	reg_ren #(18) regM (clk, reset, ~stallM,
		{memtoregE, memwriteE, memdataE, memsrcE, regwriteE, VregwriteE, opE, functE}, 
		{memtoregM, memwriteM, memdataM, memsrcM, regwriteM, VregwriteM, opM, functM});
	
	reg_ren #(3) regW (clk, reset, ~stallW,
		{memtoregM, regwriteM, VregwriteM}, 
		{memtoregW, regwriteW, VregwriteW});
	
endmodule
