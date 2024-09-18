`timescale 1 ps / 1 ps
module sum_tb;

    // Testbench signals
    logic clk;
    reg [255:0] bus_in;
    wire [15:0] sum_out;

    // Instantiate the DUT (Device Under Test)
    sum dut (
        .bus_in(bus_in),
        .sum_out(sum_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = !clk; // 50MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize input
        bus_in = 0;
        #10;

        // Test case 1: Sum of first two 16-bit numbers (rest are zeros)
        bus_in = {224'h0, 16'd3, 16'd2}; // 240 bits of zeros, then two 16-bit numbers
        #10;

        // Expected sum: 5
        $display("Test Case 1: Input = 0x%h, Sum = %d", bus_in, sum_out);
        assert(sum_out == 16'h0005) else $error("Expected Sum = 5");
        
        // Test case 2: All 16
        bus_in = {16{16'h0010}};
        #10;

        $display("Test Case 2: Input = 0x%h, Sum = %d", bus_in, sum_out);
        assert(sum_out == 16'h0100) else $error("Expected Sum = 0x100");

        #10;
        $finish;
    end

endmodule
