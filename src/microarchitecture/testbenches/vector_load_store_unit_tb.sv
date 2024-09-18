
`timescale 1 ps / 1 ps
module vector_load_store_unit_tb();
	
	
	logic clk, reset;
    logic memtoRegM, memWriteM, memSrcM;
    logic [31:0] address;
    logic [15:0] scalarDataIn; 
    logic [255:0] vectorDataIn;
    logic busy;
    logic [15:0] scalarDataOut;
    logic [255:0] vectorDataOut;
    
    // ip_ram signals
    logic [255:0] readData;
    logic rden, wren;
    logic [13:0] ip_address;
    logic [31:0] byteena;
    logic [255:0] writeData;
		
	// instantiate device to be tested
	vector_load_store_unit vlsu
    (
        clk, reset,
        memtoRegM, memWriteM, memSrcM,
        address,
        scalarDataIn, 
        vectorDataIn,
        busy,
        scalarDataOut,
        vectorDataOut,
    
        readData,
        rden, wren,
        ip_address,
        byteena,
        writeData
    );
	
	// instantiate device to be tested
	dmem data_mem
	(
		ip_address,
		byteena,
		clk,
		writeData,
		rden,
		wren,
		readData
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
		
        address <= 32'd0;
        scalarDataIn <= 16'd0;
		vectorDataIn <= 256'd0;
		memtoRegM <= 1'd0;
		memWriteM <= 1'd0;
        memSrcM <= 1'd0;

		# 22; 
		reset <= 0;
		
		wait (~clk);
		wait (clk);
		

        // WRITE TEST

        address <= 32'd0;
		vectorDataIn <= 256'h0180_0140_0380_0180_0080_0300_0140_0455_5611_0011_0100_D5D4_A2AA_4532_FFBC_FFAA;
		memWriteM <= 1'd1;
        memSrcM <= 1'd1;
		
        #2;
		wait (~busy);
        wait (~clk);
		wait (clk);

		address <= 32'd2;
		vectorDataIn <= 256'hFFFF_EEEE_DDDD_CCCC_BBBB_AAAA_9999_8888_7777_6666_5555_4444_3333_2222_1111_0000;
		memWriteM <= 1'd1;
        memSrcM <= 1'd1;
		
        #2;
		wait (~busy);
        wait (~clk);
		wait (clk);

        address <= 32'd35;
		vectorDataIn <= 256'h0180_0140_0380_0180_0080_0300_0140_0455_5611_0011_0100_D5D4_A2AA_4532_FFBC_FFAA;
		memWriteM <= 1'd1;
        memSrcM <= 1'd1;

        #2;
        wait (~busy);
        wait (~clk);
		wait (clk);

        address <= 32'd8;
		vectorDataIn <= 256'd0;
        scalarDataIn <= 16'hFFFF;
		memWriteM <= 1'd1;
        memSrcM <= 1'd0;


        #2;
        wait (~busy);
        wait (~clk);
		wait (clk);

        address <= 32'd68;
		vectorDataIn <= 256'd0;
        scalarDataIn <= 16'hFFFF;
		memWriteM <= 1'd1;
        memSrcM <= 1'd0;


        // READ TEST

        #2;
        wait (~busy);
        wait (~clk);
		wait (clk);

        address <= 32'd32;
		memWriteM <= 1'd0;
        memtoRegM <= 1'd1;
        memSrcM <= 1'd1;

        #2;
        wait (~busy);
        wait (~clk);
		wait (clk);

        address <= 32'd8;
        memtoRegM <= 1'd1;
        memSrcM <= 1'd1;

        #2;
        wait (~busy);
        wait (~clk);
		wait (clk);

        address <= 32'd68;
        memtoRegM <= 1'd1;
        memSrcM <= 1'd0;

        #2;
        wait (~busy);
        wait (~clk);
		wait (clk);

        address <= 32'd32;
        memtoRegM <= 1'd1;
        memSrcM <= 1'd0;


        #2;
        wait (~busy);
        wait (~clk);
		wait (clk);

        address <= 32'd0;
        memtoRegM <= 1'd0;
        memSrcM <= 1'd0;

	end
	
endmodule

