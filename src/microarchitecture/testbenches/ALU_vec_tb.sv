module ALU_vec_tb;

    // Parameters
    localparam WIDTH_V = 128;
    localparam BITS_INDEX = 8;
    localparam NUM_INSTANCES = WIDTH_V / BITS_INDEX;  // 128 / 8 = 16

    // Signals
    reg [WIDTH_V-1:0] a, b;
    reg [BITS_INDEX-1:0] c;
    reg [2:0] opcode;
    wire [WIDTH_V-1:0] result;
    wire [(NUM_INSTANCES*4)-1:0] flags;

    // Instantiate the ALU_vec module
    ALU_vec #(
        .WIDTH_V(WIDTH_V),
        .BITS_INDEX(BITS_INDEX)
    ) dut (
        .a(a),
        .b(b),
        .c(c),
        .opcode(opcode),
        .result(result),
        .flags(flags)
    );

    initial begin
        // Initialize signals
        c = 8'd0;  // Not used in these operations

        // Test 1: Addition
        opcode = 3'b010;  // Operation code for addition

        // Assign the same value to all elements of 'a' and 'b'
        a = {NUM_INSTANCES{8'd10}};  // All elements are 10
        b = {NUM_INSTANCES{8'd20}};  // All elements are 20

        #10;  // Wait for results to propagate

        $display("Addition Test:");
        $display("a = %h", a);
        $display("b = %h", b);
        $display("result = %h", result);

        // Verify that the result is as expected (30 in all elements)
        assert(result === {NUM_INSTANCES{8'd30}}) else $error("Addition Test Failed.");

        // Test 2: Subtraction
        opcode = 3'b001;  // Operation code for subtraction

        // Assign the same value to all elements of 'a' and 'b'
        a = {NUM_INSTANCES{8'd50}};  // All elements are 50
        b = {NUM_INSTANCES{8'd20}};  // All elements are 20

        #10;  // Wait for results to propagate

        $display("\nSubtraction Test:");
        $display("a = %h", a);
        $display("b = %h", b);
        $display("result = %h", result);

        // Verify that the result is as expected (30 in all elements)
        assert(result === {NUM_INSTANCES{8'd30}}) else $error("Subtraction Test Failed.");

        // Test 3: Multiplication
        opcode = 3'b000;  // Operation code for multiplication

        // Assign the same value to all elements of 'a' and 'b'
        a = {NUM_INSTANCES{8'sd5}};   // All elements are 5
        b = {NUM_INSTANCES{8'sd6}};   // All elements are 6

        #10;  // Wait for results to propagate

        $display("\nMultiplication Test:");
        $display("a = %h", a);
        $display("b = %h", b);
        $display("result = %h", result);

        // Verify that the result is as expected (30 in all elements)
        assert(result === {NUM_INSTANCES{8'sd30}}) else $error("Multiplication Test Failed.");

        // Test 4: 'set' Operation
        opcode = 3'b111;  // Operation code for 'set'
        c = 8'd42;        // Value to set

        // 'a' and 'b' are not relevant in this operation
        a = {WIDTH_V{1'b0}};
        b = {WIDTH_V{1'b0}};

        #10;  // Wait for results to propagate

        $display("\n'set' Operation Test:");
        $display("c = %d", c);
        $display("result = %h", result);

        // Verify that the result is as expected (c in all elements)
        assert(result === {NUM_INSTANCES{c}}) else $error("'set' Operation Test Failed.");

        // End the simulation
        $display("\nAll tests have been completed.");
    end

endmodule
