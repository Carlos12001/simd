module sum(
    input logic [255:0] bus_in,
    output logic [15:0] sum_out
);
    // Intermediate sums for each stage
    logic [15:0] stage1_sums[7:0];
    logic [15:0] stage2_sums[3:0];
    logic [15:0] stage3_sums[1:0];
    
    // Stage 1: Pairwise addition
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin : STAGE1
            assign stage1_sums[i] = bus_in[i*32+15:i*32] + bus_in[i*32+31:i*32+16];
        end
    endgenerate
    
    // Stage 2: Summing results of Stage 1
    generate
        for (i = 0; i < 4; i++) begin : STAGE2
            assign stage2_sums[i] = stage1_sums[i*2] + stage1_sums[i*2+1];
        end
    endgenerate
    
    // Stage 3: Summing results of Stage 2
    generate
        for (i = 0; i < 2; i++) begin : STAGE3
            assign stage3_sums[i] = stage2_sums[i*2] + stage2_sums[i*2+1];
        end
    endgenerate
    
    // Final Stage: Summing results of Stage 3 for final output
    assign sum_out = stage3_sums[0] + stage3_sums[1];

endmodule
