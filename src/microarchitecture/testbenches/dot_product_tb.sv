module dot_product_tb;

    localparam WIDTH_V = 128;
    localparam BITS_INDEX = 8;
    localparam MATRIX_SIZE = 4;
    localparam NUM_ELEMENTS = WIDTH_V / BITS_INDEX; // Should be 16 for 128-bit vectors with 8-bit elements

    reg [WIDTH_V-1:0] a, b;
    wire [WIDTH_V-1:0] result;

    // Instantiate the dot_product module
    dot_product #(
        .WIDTH_V(WIDTH_V),
        .BITS_INDEX(BITS_INDEX)
    ) dut (
        .a(a),
        .b(b),
        .result(result)
    );

    // Expected result vector
    reg [WIDTH_V-1:0] expected_result;

    initial begin
        // Simplified matrices:
        // Let's use matrices where all elements are '2' for 'a' and '3' for 'b'

        // Build 'a' vector (all elements are 2)
        a = {NUM_ELEMENTS{8'd2}};

        // Build 'b' vector (all elements are 3)
        b = {NUM_ELEMENTS{8'd3}};

        // Calculate the expected result
        // Each element in the result matrix will be:
        // sum = (2*3) + (2*3) + (2*3) + (2*3) = 24 (since MATRIX_SIZE = 4)
        // So, the expected result vector will have all elements as 24 modulo 256
        expected_result = {NUM_ELEMENTS{8'd24}};

        #10; // Wait for computation to complete
        // Display input matrices and the result
        $display("Matrix a:");
        display_matrix(a, "a");

        $display("Matrix b:");
        display_matrix(b, "b");

        $display("Expected Result Matrix:");
        display_matrix(expected_result, "expected_result");

        $display("Obtained Result Matrix:");
        display_matrix(result, "result");

        // Compare 'result' with 'expected_result'
        if (result !== expected_result) begin
            $error("Dot product calculation error.");
            $display("Expected result: %h", expected_result);
            $display("Obtained result: %h", result);
        end else begin
            $display("Dot product calculation successful.");
            $display("Result: %h", result);
        end

        // Build 'a' vector
        /*
        a=
          [[2 4 2 5]
          [1 5 2 6]
          [8 5 3 2]
          [0 1 3 6]]
        */
        a = {
            8'd2, 8'd1, 8'd8, 8'd0,    // Col 1
            8'd4, 8'd5, 8'd5, 8'd1,   // Col 2
            8'd2, 8'd2, 8'd3, 8'd3,   // Col 3
            8'd5, 8'd6, 8'd2, 8'd6   // Col 4
        };

        // Build 'b' vector
        /*
        b=
          [[1 0 1 0]
          [0 1 0 1]
          [4 1 4 1]
          [2 2 2 2]]
        */
        b = {
            8'd1, 8'd0, 8'd4, 8'd2,    // Col 1
            8'd0, 8'd1, 8'd1, 8'd2,   // Col 2
            8'd1, 8'd0, 8'd4, 8'd2,   // Col 3
            8'd0, 8'd1, 8'd1, 8'd2   // Col 4
        };

        // Build the expected result vector (flattened row-wise from top to bottom)
        /*
        result=
          [[20 16 20 16]
          [21 19 21 19]
          [24 12 24 12]
          [24 16 24 16]]
        */

        expected_result = {
            8'd20, 8'd21, 8'd24, 8'd24,    // Col 1 
            8'd16, 8'd19, 8'd12, 8'd16,   // Col 2
            8'd20, 8'd21, 8'd24, 8'd24,   // Col 3
            8'd16, 8'd19, 8'd12, 8'd16   // Col 4
        };

        // Wait for the computation to complete
        #10;

        // Display input matrices and the result
        $display("Matrix a:");
        display_matrix(a, "a");

        $display("Matrix b:");
        display_matrix(b, "b");

        $display("Expected Result Matrix:");
        display_matrix(expected_result, "expected_result");

        $display("Obtained Result Matrix:");
        display_matrix(result, "result");

        // Assert that the obtained result matches the expected result
        assert(result === expected_result) else begin
            $error("Dot product calculation error.");
            $display("Expected result: %h", expected_result);
            $display("Obtained result: %h", result);
        end

        $display("Dot product calculation successful.");

    end

  task display_matrix(input [WIDTH_V-1:0] vec, input string name);
        integer i, j;
        reg [BITS_INDEX-1:0] element;
        begin
            $display("%s:", name);
            for (i = 0; i < MATRIX_SIZE; i = i + 1) begin
                $write("[ ");
                for (j = 0; j < MATRIX_SIZE; j = j + 1) begin
                    element = vec[BITS_INDEX * (NUM_ELEMENTS - ((i * MATRIX_SIZE) + j)) - 1 -: BITS_INDEX];
                    $write("%0d ", element);
                end
                $write("]\n");
            end
        end
  endtask

endmodule
