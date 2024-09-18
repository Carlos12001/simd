module PMC_unit (
    input logic clk,     // Señal de reloj
    input logic reset,   // Señal de reset
	 input logic pmc_en,  // Impulso para activar/desactivar el conteo
    input logic memWrite_in, memToReg_in, //Senales de control de mem y WB
	 input logic [2:0] aluControl_in,
    input logic [3:0 ]stall_in, //Habilitar contador de stalls
	 input logic [5:0] opcode_in, funct_in, // señales desde al menos execute en adelante
	 input logic jmp_in, // señal desde unidad de control
	 input logic [1:0] branch_in, // señal desde unidad de control
	 output logic [255:0] stall_count_out, 
    output logic [255:0] cycles_per_instruction_q78_out, // Out instr_cycle_count
    output logic [255:0] arith_count_out, // Out arith_count
	 output logic [255:0] mem_access_count_out  // Out mem_access_Count

);
	
	logic arith_enable; //Habilitar contadores de aritmetica y memoria 
	logic [31:0] CPI_numerator, CPI_denominator;
	logic [31:0] mem_read_count, mem_write_count;
	logic [31:0] ADD_count, SUB_count, ADDI_count, ADD_FP_count, MUL_FP_count, VADD_FP_count, VMUL_FP_count,
			VSUM_FP_count, VSET_FP_count, SW_count, LW_count, SW_FP_count, LW_FP_count, VST_count, VLD_count,
			BEQ_count, BLT_count, J_count;
			
	logic [31:0] stall_count, arith_count, mem_access_count;
	logic [15:0] cycles_per_instruction_q78;

	logic global_en;
	
	parameter ARITH_INSTRUCTION_CYCLES = 5; 
	parameter MEM_LD_INSTRUCTION_CYCLES = 5;   
	parameter MEM_STR_INSTRUCTION_CYCLES = 4;
	parameter BRANCH_INSTRUCTION_CYCLES = 2;
	
	
	always_ff @(posedge clk or posedge reset) begin
		if (reset) begin
			arith_enable <= 1'b0;

		end else begin
		
			// Logica para ignorar operaciones no aritmeticas y conter una vez por instruccion
			if (aluControl_in != 3'b100) begin
                arith_enable <= 1'b1;
            end else begin
                arith_enable <= 1'b0;
            end
		end
	end
	
	always_ff @(posedge pmc_en or posedge reset) begin
		if (reset) begin
			global_en <= 1'b0;
		end else begin
			global_en <= ~global_en;
		end
	end

   // Contador de Stalls:
   counter stall_counter (clk, reset, global_en & (stall_in[0] || stall_in[1] || stall_in[2] || stall_in[3]), stall_count);
	//======================================================================
	 
	//Contador de Operaciones Aritmeticas
	counter arithmetic_counter (clk, reset, global_en & arith_enable, arith_count);
	//======================================================================
	 
	//Contador de Accesos a Memoria
	counter memory_read_counter (clk, reset, global_en & memToReg_in, mem_read_count);
	counter memory_write_counter (clk, reset, global_en & memWrite_in, mem_write_count);
	assign mem_access_count = mem_read_count + mem_write_count;
	//======================================================================
	 
   // Contadores de Ciclos de Instruccion
	instr_counter instruction_counters(clk, reset, global_en, opcode_in, funct_in, jmp_in, branch_in,
		ADD_count, SUB_count, ADDI_count, ADD_FP_count, MUL_FP_count, VADD_FP_count, VMUL_FP_count,
		VSUM_FP_count, VSET_FP_count, SW_count, LW_count, SW_FP_count, LW_FP_count, VST_count, VLD_count,
		BEQ_count, BLT_count, J_count);
			
	 
	assign CPI_numerator = ((ADD_count + SUB_count + ADDI_count + ADD_FP_count + MUL_FP_count + VADD_FP_count + VMUL_FP_count +	VSUM_FP_count + VSET_FP_count) * ARITH_INSTRUCTION_CYCLES + 
		(LW_count + LW_FP_count + VLD_count) * MEM_LD_INSTRUCTION_CYCLES + (SW_count + SW_FP_count + VST_count) * MEM_STR_INSTRUCTION_CYCLES +
		(BEQ_count + BLT_count + J_count) * BRANCH_INSTRUCTION_CYCLES);
	assign CPI_denominator = (ADD_count + SUB_count + ADDI_count + ADD_FP_count + MUL_FP_count + VADD_FP_count + VMUL_FP_count +	VSUM_FP_count + VSET_FP_count + 
		LW_count + LW_FP_count + VLD_count + SW_count + SW_FP_count + VST_count +
		BEQ_count + BLT_count + J_count);
		
	divider division (CPI_numerator, CPI_denominator, cycles_per_instruction_q78);
	
	
	//Aumentar buses a tamano de vector
	assign stall_count_out = {224'b0, stall_count};
   assign cycles_per_instruction_q78_out = {240'b0, cycles_per_instruction_q78}; // Out instr_cycle_count
   assign arith_count_out = {224'b0, arith_count};// Out arith_count
	assign mem_access_count_out = {224'b0, mem_access_count};// Out mem_access_Count
    

	 
endmodule
