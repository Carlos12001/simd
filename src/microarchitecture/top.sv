
// Top level module

module top
(
	input logic clk_c, reset,
	input logic clk_b, debug,
	output logic [6:0] display1,    	//seven-segment display 1
	output logic [6:0] display2,    	//seven-segment display 2
	output logic [6:0] display3,    	//seven-segment display 3
	output logic [6:0] display4,    	//seven-segment display 4
	output logic [6:0] display5,    	//seven-segment display 5
	output logic [6:0] display6,    	//seven-segment display 6
	output logic clk_aux
);

	logic [31:0] writedata, dataadr;
	logic memwrite;
	logic clk;
	logic [31:0] pcF, instr;
	
	logic [13:0] address_RAM;
	logic [31:0] byteena_RAM;
	logic [255:0] readData_RAM;
	logic [255:0] writeData_RAM;
	logic rden_RAM, wren_RAM;
	
	assign clk_aux = clk;

	muxclock mux_clock 
	(
		clk_c, 
		clk_b, 
		debug,
		clk,
		pcF
	);
	
	muxout mux_out 
	(
		debug, 
		pcF, 
		display1, 
		display2, 
		display3, 
		display4, 
		display5, 
		display6
	);
	
	simd_processor processor
	(
		clk, 
		reset, 
		pcF, 
		instr, 

		address_RAM,
		byteena_RAM,
		readData_RAM,
		writeData_RAM,
		rden_RAM, wren_RAM
	);

	
	imem imem 
	(
		pcF[7:2], 
		instr
	);
	

	dmem data_mem
	(
		address_RAM,
		byteena_RAM,
		clk,
		writeData_RAM,
		rden_RAM, wren_RAM,
		readData_RAM
	);
	
endmodule
