module dot_product #(
    parameter WIDTH_V = 128,
    parameter BITS_INDEX = 8
)(
    input  wire [WIDTH_V-1:0] a,       // Input vector a
    input  wire [WIDTH_V-1:0] b,       // Input vector b
    output wire [WIDTH_V-1:0] result   // Output vector result
);

    // Local parameters
    localparam NUM_ELEMENTS = WIDTH_V / BITS_INDEX; // Total number of elements (16)
    localparam MATRIX_SIZE = 4;                     // Assuming 4x4 matrices

    // Internal arrays to hold matrix elements
    wire [BITS_INDEX-1:0] a_matrix [0:NUM_ELEMENTS-1];
    wire [BITS_INDEX-1:0] b_matrix [0:NUM_ELEMENTS-1];
    reg  [BITS_INDEX-1:0] result_matrix [0:NUM_ELEMENTS-1];

    // Unpack input vectors into arrays
    genvar idx;
    generate
        for (idx = 0; idx < NUM_ELEMENTS; idx = idx + 1) begin : UNPACK
            assign a_matrix[idx] = a[BITS_INDEX*(NUM_ELEMENTS - idx) - 1 -: BITS_INDEX];
            assign b_matrix[idx] = b[BITS_INDEX*(NUM_ELEMENTS - idx) - 1 -: BITS_INDEX];
        end
    endgenerate

    // Perform matrix multiplication
    integer i, j, k;
    always @(*) begin
        for (i = 0; i < MATRIX_SIZE; i = i + 1) begin
            for (j = 0; j < MATRIX_SIZE; j = j + 1) begin
                reg [BITS_INDEX + $clog2(MATRIX_SIZE):0] sum; // Extra bits to hold intermediate sum
                sum = 0;
                for (k = 0; k < MATRIX_SIZE; k = k + 1) begin
                    sum = sum + (a_matrix[i*MATRIX_SIZE + k] * b_matrix[k*MATRIX_SIZE + j]);
                end
                // Apply modulo operation to keep within BITS_INDEX bits
                result_matrix[i*MATRIX_SIZE + j] = sum[BITS_INDEX-1:0]; // Keep lower BITS_INDEX bits
            end
        end
    end

    // Pack result_matrix into result vector
    generate
        for (idx = 0; idx < NUM_ELEMENTS; idx = idx + 1) begin : PACK
            assign result[BITS_INDEX*(NUM_ELEMENTS - idx) - 1 -: BITS_INDEX] = result_matrix[idx];
        end
    endgenerate

endmodule
