
module vector_load_store_unit
(
	// processor signals
	input logic clk, reset,
	input logic memtoRegM, memWriteM, memSrcM,
	input logic [31:0] address,
	input logic [15:0] scalarDataIn, 
	input logic [255:0] vectorDataIn,
	output logic busy,
	output logic [31:0] scalarDataOut,
	output logic [255:0] vectorDataOut,
	
	// ip_ram signals
	input logic [255:0] readData,
	output logic rden, wren,
	output logic [13:0] ip_address,
	output logic [31:0] byteena,
	output logic [255:0] writeData
);
	
	logic [1:0] count;
	logic ready;
	logic aligned;
	logic [31:0] shamt, prev_shamt;

	logic [255:0] wr_data_part1, wr_data_part2, 
				  rd_data_part1, rd_data_part2,
				  rd_data_scalar;


	assign shamt = {27'd0, address[4:0]};
	assign aligned = (shamt == 0);
	
	
	assign ip_address = (count) ? address[18:5] + 14'd1 : address[18:5];	// align to 256 bits
	assign wr_data_part1 = vectorDataIn << shamt*8;
	assign wr_data_part2 = vectorDataIn >> 256 - shamt*8;
	assign rd_data_part2 = readData << 256 - prev_shamt*8;
	assign rd_data_scalar = readData >> prev_shamt*8; 

	assign wren = memWriteM;
	assign rden = memtoRegM;


	always_ff @ (posedge clk) 
	begin
		if (reset) begin
			count <= 2'b0;
		end
		else 
		begin	
			count <= (~ready) ? count + 2'b1 : 2'b0;
			prev_shamt = shamt;

			rd_data_part1 <= readData >> prev_shamt*8;
		end
		
	end

	// Write logic
	always_comb 
	begin
		if (memSrcM && ~aligned) 
		begin
			writeData = (count) ? wr_data_part2 : wr_data_part1;
			byteena = (count) ? 32'hFFFF_FFFF >> 32-shamt : 32'hFFFF_FFFF << shamt;
		end
		else if (memSrcM && aligned)
		begin
			writeData = vectorDataIn;
			byteena = 32'hFFFF_FFFF;
		end
		else
		begin
			writeData = { 240'd0, scalarDataIn } << shamt*8;
			byteena = 32'd3 << shamt;
		end
	end

	// Read logic
	always_comb 
	begin
		if (memSrcM && ~aligned) 
		begin
			scalarDataOut = 32'd0;
			vectorDataOut = rd_data_part2 | rd_data_part1;
		end
		else if (memSrcM && aligned)
		begin
			scalarDataOut = 32'd0;
			vectorDataOut = readData;
		end
		else
		begin
			scalarDataOut = rd_data_scalar[31:0];
			vectorDataOut = 256'd0;
		end
	end

	// busy, ready and count logic
	always_comb
	begin
		if (memWriteM)
		begin
			if (memSrcM)
				ready = (~aligned && count > 0) || aligned;
			else
				ready = 1'b1;
		end
		else if (memtoRegM)
		begin
			if (memSrcM && ~aligned) 
				ready = (count > 1);
			else
				ready = (count > 0);
		end
		else 
			ready = 1'b1;
	end

	assign busy = ~ready;
	
endmodule
