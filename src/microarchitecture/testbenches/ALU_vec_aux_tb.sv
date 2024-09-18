module ALU_vec_aux_tb;

	reg [15:0] a, b, c;
	reg [2:0] opcode;
	reg flag_scalar;
	int instance_num;
	wire [15:0] result;
	wire [3:0] flags;

	// Instantiate ALU_vec module
	ALU_vec_aux dut (
		.data_a(a),
		.data_b(b),
		.data_c(c),
		.opcode(opcode),
		.flag_scalar(flag_scalar),
		.instance_num(instance_num),
		.result(result),
		.flags(flags)
	);

	initial begin
		flag_scalar = 1'b0;
		c = 16'h0000;
		
		// FP Q7.8 add test
		a = 16'h0280; //2.5
		b = 16'h0280; //2.5
		opcode = 3'b010;
		#10;
		$display("Add: %h + %h = %h", a, b, result); // expected result = 0500 (5)
		$display("Flags: %b", flags);
		// Assert to verify the add operation result
		assert(result == 16'h0500 && flags == 4'b0000) else $error("Add error: %h + %h != %h, expected %h\nFlags expected: %b", a, b, result, 16'h0500, 4'b0000);
		
		a = 16'h01c0; //1.75
		b = 16'h00e0; //0.875
		opcode = 3'b010;
		#10;
		$display("\nAdd: %h + %h = %h", a, b, result); // expected result = 02a0 (2.625)
		$display("Flags: %b", flags);
		// Assert to verify the add operation result
		assert(result == 16'h02a0 && flags == 4'b0000) else $error("Add error: %h + %h != %h, expected %h\nFlags expected: %b", a, b, result, 16'h02a0, 4'b0000);

		a = 16'hfc80; //-3.5
		b = 16'h0500; //5.0
		opcode = 3'b010;
		#10;
		$display("\nAdd: %h + %h = %h", a, b, result); // expected result = 0180 (1,5)
		$display("Flags: %b", flags);
		// Assert to verify the add operation result
		assert(result == 16'h0180 && flags == 4'b0001) else $error("Add error: %h + %h != %h, expected %h\nFlags expected: %b", a, b, result, 16'h0180, 4'b0001);
		
		//Test overflow
		a = 16'h7F00; //127.0
		b = 16'h0200; //2.0
		opcode = 3'b010;
		#10;
		$display("\nAdd: %h + %h = %h", a, b, result); // expected result = 8100
		$display("Flags: %b", flags);
		// Assert to verify the add operation result
		assert(result == 16'h8100 && flags == 4'b1100) else $error("Add error: %h + %h != %h, expected %h\nFlags expected: %b", a, b, result, 16'h8100, 4'b1100);

		//FP Q7.8 substraction test
		a = 16'h0F00; //15.0
		b = 16'h0800; //8.0
		opcode = 3'b001;
		#10;
		$display("\nSub: %h - %h = %h", a, b, result); // expected result = 0700
		$display("Flags: %b", flags);
		// Assert to verify the sub operation result
		assert(result == 16'h0700 && flags == 4'b0001) else $error("Sub error: %h - %h != %h, expected %h\nFlags expected: %b", a, b, result, 16'h0700, 4'b0001);

		a = 16'h0180; //1.5
		b = 16'h01C0; //1.75
		opcode = 3'b001;
		#10;
		$display("\nSub: %h - %h = %h", a, b, result); // expected result = FFC0 (-0,25)
		$display("Flags: %b", flags);
		// Assert to verify the sub operation result
		assert(result == 16'hFFC0 && flags == 4'b0100) else $error("Sub error: %h - %h != %h, expected %h\nFlags expected: %b", a, b, result, 16'hFFC0, 4'b0100);
		
		a = 16'h00C0; //0.75
		b = 16'hFFA0; //-0.375
		opcode = 3'b001;
		#10;
		$display("\nSub: %h - %h = %h", a, b, result); // expected result = 0120 (1,125)
		$display("Flags: %b", flags);
		// Assert to verify the sub operation result
		assert(result == 16'h0120 && flags == 4'b0000) else $error("Sub error: %h - %h != %h, expected %h\nFlags expected: %b", a, b, result, 16'h0120, 4'b0000);
		
		a = 16'hFF40; //-0,75
		b = 16'h0040; //0.25
		opcode = 3'b001;
		#10;
		$display("\nSub: %h - %h = %h", a, b, result); // expected result = FF00 (-1,0)
		$display("Flags: %b", flags);
		// Assert to verify the sub operation result
		assert(result == 16'hFF00 && flags == 4'b0101) else $error("Sub error: %h - %h != %h, expected %h\nFlags expected: %b", a, b, result, 16'hFF00, 4'b0101);

		//FP Q7.8 multiplication test
		a = 16'h0180; //1.5
		b = 16'hFE40; //-1.75
		opcode = 3'b000;
		#10;
		$display("\nMult: %h * %h = %h", a, b, result); // expected result = FD60 (-2,625)
		$display("Flags: %b", flags);
		// Assert to verify the sub operation result
		assert(result == 16'hFD60) else $error("Mult error: %h * %h != %h, expected %h\nFlags expected: %b", a, b, result, 16'hFD60, 4'b010x);
		
		a = 16'h0140; //1.25
		b = 16'h0180; //1.5
		opcode = 3'b000;
		#10;
		$display("\nMult: %h * %h = %h", a, b, result); // expected result = 01E0 (1.875)
		$display("Flags: %b", flags);
		// Assert to verify the sub operation result
		assert(result == 16'h01E0) else $error("Mult error: %h * %h != %h, expected %h\nFlags expected: %b", a, b, result, 16'h01E0, 4'b000x);
		
		a = 16'hFD00; //-3.0
		b = 16'h0080; //0.5
		opcode = 3'b000;
		#10;
		$display("\nMult: %h * %h = %h", a, b, result); // expected result = FE80 (-1.5)
		$display("Flags: %b", flags);
		// Assert to verify the sub operation result
		assert(result == 16'hFE80) else $error("Mult error: %h * %h != %h, expected %h\nFlags expected: %b", a, b, result, 16'hFE80, 4'b010x);

		//Test overflow
		a = 16'h7F00; //127
		b = 16'h7F00; //127
		opcode = 3'b000;
		#10;
		$display("\nMult: %h * %h = %h", a, b, result); // expected result = 0100 (has overflow)
		$display("Flags: %b", flags);
		// Assert to verify the sub operation result
		assert(result == 16'h0100 && flags[3]) else $error("Mult error: %h * %h != %h, expected %h\nFlags expected: %b", a, b, result, 16'hFE80, 4'b100x);
	
		//Test vset operation
		opcode = 3'b111;
		#10;
		$display("\nSet: result = %h", result); // expected result = 0000
		$display("Flags: %b", flags);
		// Assert to verify the sub operation result
		assert(result == 16'h0000) else $error("Set error: %h, expected %h", result, 16'h0000);
		
		//Test vset operation
		c = 16'hFF00;
		opcode = 3'b111;
		#10;
		$display("\nSet: result = %h", result); // expected result = FF00
		$display("Flags: %b", flags);
		// Assert to verify the sub operation result
		assert(result == 16'hFF00) else $error("Set error: %h, expected %h", result, 16'hFF00);
	end
endmodule
