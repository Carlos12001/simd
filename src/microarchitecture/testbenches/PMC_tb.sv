
module PMC_tb();
	 logic clk;     // Señal de reloj
    logic reset;   // Señal de reset
	 logic pmc_en;
    logic memWrite_in, memToReg_in; //Senales de control
	 logic [2:0] aluControl_in;
    logic [3:0]stall_enable; //Habilitar contador de stalls
	 logic [5:0] opcode_in, funct_in; // señales desde al menos execute en adelante
	 logic jmp_in; // señal desde unidad de control
	 logic [1:0] branch_in; // señal desde unidad de control
	 
	 
	 logic [255:0] stall_count; // Out stall_count
    logic [255:0] cycles_per_instruction_q78; // Out instr_cycle_count
    logic [255:0] arith_count; // Out arith_count
	 logic [255:0] mem_access_count;  // Out mem_access_Count
	 
	// instantiate device to be tested
	PMC_unit dut(
	 clk, reset,
	 pmc_en,
    memWrite_in, memToReg_in, 
	 aluControl_in,
    stall_enable, //Habilitar contador de stalls
	 opcode_in, funct_in, // señales desde al menos execute en adelante
	 jmp_in, // señal desde unidad de control
	 branch_in,
	 stall_count,// Out stall_count
    cycles_per_instruction_q78, // Out instr_cycle_count
    arith_count, // Out arith_count
	 mem_access_count // Out mem_access_Count
	 
	);
	// initialize test
	initial
	begin
		reset <= 1;
		
		memWrite_in<=0; 
		memToReg_in<=0;
		stall_enable<=0;
		aluControl_in <=3'b100;
		opcode_in<=6'b000000;
		funct_in<=6'b000000; 
		jmp_in<=0; 
		branch_in<=2'b00;
		# 10; 
		reset <= 0;
		#10
		pmc_en <=1;
		#10
		pmc_en <=0;
		for (int i = 0; i < 10; i++) begin
			//ADD
			memWrite_in<=0; 
			memToReg_in<=0;
			stall_enable<=0;
			aluControl_in <=3'b010;
			opcode_in<=6'b000000;
			funct_in<=6'b000000; 
			jmp_in<=0; 
			branch_in<=2'b00;
			#10
			//SUB
			memWrite_in<=0; 
			memToReg_in<=0;
			stall_enable<=0;
			aluControl_in <=3'b110;
			opcode_in<=6'b000000;
			funct_in<=6'b000001; 
			jmp_in<=0; 
			branch_in<=2'b00;
			#10
			//ADDI
			memWrite_in<=0; 
			memToReg_in<=0;
			stall_enable<=0;
			aluControl_in <=3'b010;
			opcode_in<=6'b010000;
			funct_in<=6'b000000; 
			jmp_in<=0; 
			branch_in<=2'b00;
			#10
			//ADD.FP
			memWrite_in<=0; 
			memToReg_in<=0;
			stall_enable<=0;
			aluControl_in <=3'b010;
			opcode_in<=6'b000100;
			funct_in<=6'b000100; 
			jmp_in<=0; 
			branch_in<=2'b00;
			#10
			//MUL.FP
			memWrite_in<=0; 
			memToReg_in<=0;
			stall_enable<=0;
			aluControl_in <=3'b000;
			opcode_in<=6'b000100;
			funct_in<=6'b000110; 
			jmp_in<=0; 
			branch_in<=2'b00;
			#10
			//VADD.FP
			memWrite_in<=0; 
			stall_enable <= 4'b0010;
			memToReg_in<=0;
			aluControl_in <=3'b010;
			opcode_in<=6'b001100;
			funct_in<=6'b100100; 
			jmp_in<=0; 
			branch_in<=2'b00;
			#10
			//VMUL.FP
			memWrite_in<=0; 
			stall_enable <= 4'b0100;
			memToReg_in<=0;
			aluControl_in <=3'b000;
			opcode_in<=6'b001100;
			funct_in<=6'b100110; 
			jmp_in<=0; 
			branch_in<=2'b00;
			#10
			//vSUM.FP
			stall_enable <= 4'b1000;
			memWrite_in<=0; 
			memToReg_in<=0;
			aluControl_in <=3'b011;
			opcode_in<=6'b001100;
			funct_in<=6'b110000; 
			jmp_in<=0; 
			branch_in<=2'b00;
			#10
			//SW
			memWrite_in<=1; 
			memToReg_in<=0;
			stall_enable<=0;
			aluControl_in <=3'b100;
			opcode_in<=6'b010001;
			funct_in<=6'b110101; 
			jmp_in<=0; 
			branch_in<=2'b00;
			#10
			//LW
			memWrite_in<=0; 
			memToReg_in<=1;
			stall_enable<=0;
			aluControl_in <=3'b100;
			opcode_in<=6'b010010;
			funct_in<=6'b110101; 
			jmp_in<=0; 
			branch_in<=2'b00;
			#10
			//SW.FP
			memWrite_in<=1; 
			memToReg_in<=0;
			stall_enable<=0;
			aluControl_in <=3'b100;
			opcode_in<=6'b010101;
			funct_in<=6'b000000; 
			jmp_in<=0; 
			branch_in<=2'b00;
			#10
			//LW.FP
			memWrite_in<=0; 
			memToReg_in<=1;
			stall_enable<=0;
			aluControl_in <=3'b100;
			opcode_in<=6'b010110;
			funct_in<=6'b110101; 
			jmp_in<=0; 
			branch_in<=2'b00;
			#10
			//VST
			memWrite_in<=1; 
			memToReg_in<=0;
			stall_enable<=0;
			aluControl_in <=3'b100;
			opcode_in<=6'b011101;
			funct_in<=6'b110101; 
			jmp_in<=0; 
			branch_in<=2'b00;
			#10
			//VLD
			memWrite_in<=0; 
			memToReg_in<=1;
			stall_enable<=0;
			aluControl_in <=3'b100;
			opcode_in<=6'b011110;
			funct_in<=6'b110101; 
			jmp_in<=0; 
			branch_in<=2'b00;	
			#10
			//BEQ
			memWrite_in<=0; 
			memToReg_in<=0;
			stall_enable<=0;
			aluControl_in <=3'b100;
			opcode_in<=6'b100000;
			funct_in<=6'b110101; 
			jmp_in<=0; 
			branch_in<=2'b01;
			#10
			//BLT
			memWrite_in<=0; 
			memToReg_in<=0;
			stall_enable<=0;
			aluControl_in <=3'b100;
			opcode_in<=6'b100001;
			funct_in<=6'b110101; 
			jmp_in<=0; 
			branch_in<=2'b10;	
			#10
			//JUMP
			memWrite_in<=0; 
			memToReg_in<=0;
			stall_enable<=0;
			aluControl_in <=3'b100;
			opcode_in<=6'b100010;
			funct_in<=6'b110101; 
			jmp_in<=1; 
			branch_in<=2'b00;
			#10
			//VSET
			memWrite_in<=0; 
			memToReg_in<=0;
			stall_enable<=0;
			aluControl_in <=3'b111;
			opcode_in<=6'b111111;
			funct_in<=6'b110101; 
			jmp_in<=0; 
			branch_in<=2'b00;
			#10
			memWrite_in<=0; 
			memToReg_in<=0;
			stall_enable<=0;
			aluControl_in <=3'b100;
			opcode_in<=6'b000011;
			funct_in<=6'b110101; 
			jmp_in<=0; 
			branch_in<=2'b00;
		end
		#30
		reset <= 1;
		
		
		
		
		
	end
	
	// generate clock to sequence tests
	always
	begin
		clk <= 1; # 5; clk <= 0; # 5;
	end

	
endmodule
