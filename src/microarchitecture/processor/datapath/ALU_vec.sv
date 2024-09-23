module ALU_vec #(parameter WIDTH_V = 128, parameter BITS_INDEX = 8)(
    input [WIDTH_V-1:0] a,        // vector register operand A
    input [WIDTH_V-1:0] b,        // vector register operand B
    input [BITS_INDEX-1:0] c,     // scalar register operand (for 'set' instruction)
    input [2:0] opcode,
    output reg [WIDTH_V-1:0] result,
    output reg [(WIDTH_V/BITS_INDEX)*4-1:0] flags  // Carry(0), Zero(1), Negative(2), Overflow(3) for each element
);

    logic [WIDTH_V-1:0] result_alu;
    logic [WIDTH_V-1:0] result_dot;

    localparam NUM_INSTANCES = WIDTH_V / BITS_INDEX;    // Total number of instances
    localparam FLAGS_INDEX = 4;                         // Number of flags per element

    // ALU_vec_aux instances generation
    genvar i;
    generate
        for (i = 0; i < NUM_INSTANCES; i = i + 1) begin : alu_instance

            ALU_vec_aux #(.WIDTH(BITS_INDEX)) alu (
                .data_a(a[BITS_INDEX*(i+1)-1 : BITS_INDEX*i]),
                .data_b(b[BITS_INDEX*(i+1)-1 : BITS_INDEX*i]),
                .data_c(c),
                .opcode(opcode), 
                .instance_num(i),
                .result(result_alu[BITS_INDEX*(i+1)-1 : BITS_INDEX*i]),
                .flags(flags[FLAGS_INDEX*(i+1)-1 : FLAGS_INDEX*i])
            );
        end
    endgenerate

    // Aqui agregar modulo de producto punto (si es necesario)
    dot_product #(.WIDTH_V(WIDTH_V), .BITS_INDEX(BITS_INDEX)) dot_product_uff
    (
        .a(a),
        .b(b),
        .result(result_dot)
    );

    assign result = (opcode == 3'b011) ? result_dot : result_alu;

endmodule
