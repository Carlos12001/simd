module regfile_vec_tb;

    // Parametros
    reg clk;
    reg rst;
    reg vwe3;
    reg [4:0] vra1, vra2, vwa3;
    reg [255:0] vwd3;
    wire [255:0] vrd1, vrd2;

    // Instancia del modulo regfile_vec
    regfile_vec uut (
        .clk(clk),
        .rst(rst),
        .vwe3(vwe3),
        .vra1(vra1),
        .vra2(vra2),
        .vwa3(vwa3),
        .vwd3(vwd3),
        .vrd1(vrd1),
        .vrd2(vrd2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #10;
        rst = 0;
        vwe3 = 0;
        vra1 = 32'h10; // 0x10 => vrf0
        vra2 = 32'h11; // 0x11 => vrf1
        vwa3 = 32'h10;
        vwd3 = {32{8'hAA}};
        #10;
        vwe3 = 1;
        #10;
        vwe3 = 0;
        #10
        $finish;
    end

    // Monitoreo de las salidas
    always @(vrd1 or vrd2) begin
        $display("vrd1 = %h, vrd2 = %h", vrd1, vrd2);
    end

endmodule
