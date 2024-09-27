module ALU_vec_aux_tb;

    localparam WIDTH = 8;  // Ancho de datos en bits

    reg signed [WIDTH-1:0] a, b, c;
    reg [2:0] opcode;
    int instance_num;
    wire signed [WIDTH-1:0] result;
    wire [3:0] flags;

    // Instanciar el módulo ALU_vec_aux con el parámetro WIDTH
    ALU_vec_aux #(.WIDTH(WIDTH)) dut (
        .data_a(a),
        .data_b(b),
        .data_c(c),
        .opcode(opcode),
        .instance_num(instance_num),
        .result(result),
        .flags(flags)
    );

    initial begin
        c = {WIDTH{1'b0}};
        instance_num = 0;

        // Test de suma
        a = 50;
        b = 25;
        opcode = 3'b010; // Suma
        #10;
        $display("Add: %0d + %0d = %0d", a, b, result); // Resultado esperado: 75
        $display("Flags: %b", flags);
        // Afirmación para verificar el resultado de la suma
        assert(result == 75 && flags == 4'b0000) else $error("Error en suma: %0d + %0d != %0d, se esperaba %0d\nFlags esperados: %b", a, b, result, 75, 4'b0000);

        // Test de suma con desbordamiento
        a = 100;
        b = 50;
        opcode = 3'b010; // Suma
        #10;
        $display("\nAdd: %0d + %0d = %0d", a, b, result); // Resultado esperado: -106 (desbordamiento)
        $display("Flags: %b", flags);
        // La bandera de desbordamiento debe estar activada
        assert(result == -106 && flags == 4'b1100) else $error("Error en suma con desbordamiento: %0d + %0d != %0d, se esperaba %0d\nFlags esperados: %b", a, b, result, -106, 4'b1100);

        // Test de resta
        a = 50;
        b = 25;
        opcode = 3'b001; // Resta
        #10;
        $display("\nSub: %0d - %0d = %0d", a, b, result); // Resultado esperado: 25
        $display("Flags: %b", flags);
        assert(result == 25 && flags == 4'b0000) else $error("Error en resta: %0d - %0d != %0d, se esperaba %0d\nFlags esperados: %b", a, b, result, 25, 4'b0000);

        // Test de resta con resultado negativo
        a = 25;
        b = 50;
        opcode = 3'b001; // Resta
        #10;
        $display("\nSub: %0d - %0d = %0d", a, b, result); // Resultado esperado: -25
        $display("Flags: %b", flags);
        assert(result == -25 && flags == 4'b0100) else $error("Error en resta con resultado negativo: %0d - %0d != %0d, se esperaba %0d\nFlags esperados: %b", a, b, result, -25, 4'b0100);

        // Test de multiplicación
        a = 10;
        b = 12;
        opcode = 3'b000; // Multiplicación
        #10;
        $display("\nMult: %0d * %0d = %0d", a, b, result); // Resultado esperado: 120
        $display("Flags: %b", flags);
        assert(result == 120 && flags == 4'b0000) else $error("Error en multiplicación: %0d * %0d != %0d, se esperaba %0d\nFlags esperados: %b", a, b, result, 120, 4'b0000);

        // Test de multiplicación con desbordamiento
        a = 50;
        b = 3;
        opcode = 3'b000; // Multiplicación
        #10;
        $display("\nMult: %0d * %0d = %0d", a, b, result); // Resultado esperado: -106 (desbordamiento)
        $display("Flags: %b", flags);
        // La bandera de desbordamiento debe estar activada
        assert(result == -106 && flags[3]) else $error("Error en multiplicación con desbordamiento: %0d * %0d != %0d, se esperaba %0d\nFlags esperados: %b", a, b, result, -106, flags);

        // Test de multiplicación con resultado negativo
        a = -20;
        b = 3;
        opcode = 3'b000; // Multiplicación
        #10;
        $display("\nMult: %0d * %0d = %0d", a, b, result); // Resultado esperado: -60
        $display("Flags: %b", flags);
        assert(result == -60 && flags == 4'b0100) else $error("Error en multiplicación con resultado negativo: %0d * %0d != %0d, se esperaba %0d\nFlags esperados: %b", a, b, result, -60, 4'b0100);

        // Test de operación 'set'
        c = 42;
        opcode = 3'b111; // Operación 'set'
        #10;
        $display("\nSet: result = %0d", result); // Resultado esperado: 42
        $display("Flags: %b", flags);
        assert(result == 42 && flags == 4'b0000) else $error("Error en operación 'set': result = %0d, se esperaba %0d\nFlags esperados: %b", result, 42, 4'b0000);

        // Test de operación 'set' con valor negativo
        c = -50;
        opcode = 3'b111; // Operación 'set'
        #10;
        $display("\nSet: result = %0d", result); // Resultado esperado: -50
        $display("Flags: %b", flags);
        assert(result == -50 && flags == 4'b0100) else $error("Error en operación 'set' con valor negativo: result = %0d, se esperaba %0d\nFlags esperados: %b", result, -50, 4'b0100);
    end
endmodule
