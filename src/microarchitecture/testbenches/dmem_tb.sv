`timescale 1 ps / 1 ps
module dmem_tb();
	
	
	logic clk, reset;
	logic	[13:0]  address;
	logic	[31:0]  byteena;
	logic	[255:0]  data;
	logic	rden, wren;
	logic	[255:0]  q;
	
	
	// instantiate device to be tested
	dmem data_mem
	(
		address,
		byteena,
		clk,
		data,
		rden,
		wren,
		q
	);

	
	// Clock generation
    initial begin
        clk = 0;
        forever #10 clk = !clk; // 50MHz clock
    end
	
	// initialize test
	initial
	begin
		reset <= 1; 
		
		byteena <= 32'd35;
		data <= 256'd0;
		rden <= 1'd0;
		wren <= 1'd0;
		address <= 14'd0;
		
		# 22; 
		
		reset <= 0;
		
		wait (~clk);
		wait (clk);
		
		data <= 256'h0180_0140_0380_0180_0080_0300_0140_0455_5611_0011_0100_DDDD_AAAA_FFFF_FFFF_FFFF;
		wren <= 1'd1;
		
		wait (~clk);
		wait (clk);
		byteena <= 32'd1;
		address <= 14'd0;
		data <= 256'h0180_0140_0380_0180_0080_0300_0140_0455_5611_0011_0100_DDDD_AAAA_2222_2222_2222;
		wren <= 1'd1;
		
		
	end
	
endmodule
