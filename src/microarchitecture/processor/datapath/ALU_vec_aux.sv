module ALU_vec_aux #(
    parameter WIDTH = 8  // Data width in bits
)(
    input signed [WIDTH-1:0] data_a,    // First operand
    input signed [WIDTH-1:0] data_b,    // Second operand
    input signed [WIDTH-1:0] data_c,    // Value for the 'set' operation
    input [2:0] opcode,                 // Operation code
    input int instance_num,             // ALU ID
    output reg signed [WIDTH-1:0] result,    
    output reg [3:0] flags              // Carry(0), Zero(1), Negative(2), Overflow(3)
);

    // Internal signals
    reg signed [2*WIDTH-1:0] mult_result;
    reg signed [WIDTH:0] extended_result;

    always @* begin
        case (opcode)
            3'b000: // Signed multiplication
                begin
                    mult_result = data_a * data_b;
                    result = mult_result[WIDTH-1:0]; // Take the lower WIDTH bits
                    
                                            // Set flags
                    flags[0] = 1'b0; // Carry flag is not used in multiplication
                    flags[1] = (result == 0); // Zero flag
                    flags[2] = result[WIDTH-1]; // Negative flag
                    // Overflow if higher bits are not a sign extension
                    flags[3] = (mult_result[2*WIDTH-1:WIDTH] != {WIDTH{mult_result[WIDTH-1]}});
                end

            3'b001: // Signed subtraction (data_a - data_b)
                begin
                    extended_result = {data_a[WIDTH-1], data_a} - {data_b[WIDTH-1], data_b};
                    result = extended_result[WIDTH-1:0];
                    // Set flags
                    flags[0] = 1'b0; // Carry flag (Borrow in subtraction)
                    flags[1] = (result == 0); // Zero flag
                    flags[2] = result[WIDTH-1]; // Negative flag
                    // Overflow if unexpected sign change
                    flags[3] = (data_a[WIDTH-1] != data_b[WIDTH-1]) && (result[WIDTH-1] != data_a[WIDTH-1]);
                end

            3'b010: // Signed addition (data_a + data_b)
                begin
                    extended_result = {data_a[WIDTH-1], data_a} + {data_b[WIDTH-1], data_b};
                    result = extended_result[WIDTH-1:0];
                    // Set flags
                    flags[0] = extended_result[WIDTH]; // Carry flag
                    flags[1] = (result == 0); // Zero flag
                    flags[2] = result[WIDTH-1]; // Negative flag
                    // Overflow if result sign differs from operands
                    flags[3] = (data_a[WIDTH-1] == data_b[WIDTH-1]) && (result[WIDTH-1] != data_a[WIDTH-1]);
                                        end

            3'b111: // 'Set' operation
                begin
                    result = data_c;
                    // Set flags
                    flags[0] = 1'b0; // Carry flag
                    flags[1] = (result == 0); // Zero flag
                    flags[2] = result[WIDTH-1]; // Negative flag
                    flags[3] = 1'b0; // Overflow flag
                end

            default: // Invalid operation
                begin
                    result = {WIDTH{1'b0}};
                    flags = 4'b0000;
                end
        endcase
    end
endmodule
