
module control_tb();
	logic clk;
	logic reset;
	logic [5:0] opD, functD;
	logic flushE;
	logic [31:0] srca2D, srcb2D;
	
	logic pcsrcD, alusrcE, scalarE;

	logic [1:0] branchD;
	logic regdstE,
			regwriteE, regwriteM, regwriteW, VregwriteW,
			jumpD;
	logic [2:0] alucontrolE;
	logic memwriteM, memdataM, memsrcM;
	logic memtoregE, memtoregM, memtoregW;
	
	// instantiate device to be tested
	control dut(
		clk, reset, 
		opD, functD, 
		srca2D, srcb2D,
		flushE,
		jumpD,
		branchD, 
		pcsrcD, alusrcE, scalarE,
		alucontrolE,
		regdstE,
		memwriteM, memdataM, memsrcM,
		regwriteE, regwriteM, regwriteW, VregwriteW,
		memtoregE, memtoregM, memtoregW	
	);
	// initialize test
	initial
	begin
		reset <= 1; # 11; reset <= 0;
		flushE <= 0;
		functD <= 6'b000000;
		opD <= 6'b000000; #50
		functD <= 6'b000001;#50
		opD <= 6'b010000;
		functD <= 6'b000000;#50
		opD <= 6'b000100;		
		functD <= 6'b000100;#50
		functD <= 6'b000110;#50
		opD <= 6'b001100;
		functD <= 6'b100100;#50
		functD <= 6'b100110;#50
		functD <= 6'b110000;#50
		opD <= 6'b010001; #50;
		opD <= 6'b010010; #50;
		opD <= 6'b010101; #50;
		opD <= 6'b010110; #50;
		opD <= 6'b011101; #50;
		opD <= 6'b011110; #50;
		opD <= 6'b100000; #50;
		opD <= 6'b100001; #50;
		opD <= 6'b100010; #50;
		opD <= 6'b111111; #50;
		functD <= 6'b100101;#50
		opD <= 6'b110010; #50;
		opD <= 6'b110001; #50;
		
		          
	end
	
	// generate clock to sequence tests
	always
	begin
		clk <= 1; # 5; clk <= 0; # 5;
	end
	
	// check results
	always @(negedge clk)
	begin
		
	end
	
endmodule
