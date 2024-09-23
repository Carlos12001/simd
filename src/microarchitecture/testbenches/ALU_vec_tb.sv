module ALU_vec_tb;

    // Parámetros
    localparam WIDTH_V = 128;
    localparam bits_index = 8;
    localparam NUM_INSTANCES = WIDTH_V / bits_index;  // 128 / 8 = 16

    // Señales
    reg [WIDTH_V-1:0] a, b;
    reg [bits_index-1:0] c;
    reg [2:0] opcode;
    wire [WIDTH_V-1:0] result;
    wire [(NUM_INSTANCES*4)-1:0] flags;

    // Instanciar el módulo ALU_vec
    ALU_vec #(
        .WIDTH_V(WIDTH_V),
        .bits_index(bits_index)
    ) dut (
        .a(a),
        .b(b),
        .c(c),
        .opcode(opcode),
        .flag_scalar(flag_scalar),
        .result(result),
        .flags(flags)
    );

    initial begin
        // Inicializar señales
        flag_scalar = 1'b0;
        c = 8'd0;  // No se usa en estas operaciones

        // Test 1: Suma
        opcode = 3'b010;  // Código de operación para suma

        // Asignar el mismo valor a todos los elementos de 'a' y 'b'
        a = {NUM_INSTANCES{8'd10}};  // Todos los elementos son 10
        b = {NUM_INSTANCES{8'd20}};  // Todos los elementos son 20

        #10;  // Esperar a que los resultados se propaguen

        $display("Prueba de Suma:");
        $display("a = %h", a);
        $display("b = %h", b);
        $display("result = %h", result);

        // Verificar que el resultado es el esperado (30 en todos los elementos)
        if (result === {NUM_INSTANCES{8'd30}}) begin
            $display("Prueba de Suma Exitosa.");
        end else begin
            $display("Prueba de Suma Fallida.");
        end

        // Test 2: Resta
        opcode = 3'b001;  // Código de operación para resta

        // Asignar el mismo valor a todos los elementos de 'a' y 'b'
        a = {NUM_INSTANCES{8'd50}};  // Todos los elementos son 50
        b = {NUM_INSTANCES{8'd20}};  // Todos los elementos son 20

        #10;  // Esperar a que los resultados se propaguen

        $display("\nPrueba de Resta:");
        $display("a = %h", a);
        $display("b = %h", b);
        $display("result = %h", result);

        // Verificar que el resultado es el esperado (30 en todos los elementos)
        if (result === {NUM_INSTANCES{8'd30}}) begin
            $display("Prueba de Resta Exitosa.");
        end else begin
            $display("Prueba de Resta Fallida.");
        end

        // Test 3: Multiplicación
        opcode = 3'b000;  // Código de operación para multiplicación

        // Asignar el mismo valor a todos los elementos de 'a' y 'b'
        a = {NUM_INSTANCES{8'sd5}};   // Todos los elementos son 5
        b = {NUM_INSTANCES{8'sd6}};   // Todos los elementos son 6

        #10;  // Esperar a que los resultados se propaguen

        $display("\nPrueba de Multiplicación:");
        $display("a = %h", a);
        $display("b = %h", b);
        $display("result = %h", result);

        // Verificar que el resultado es el esperado (30 en todos los elementos)
        if (result === {NUM_INSTANCES{8'sd30}}) begin
            $display("Prueba de Multiplicación Exitosa.");
        end else begin
            $display("Prueba de Multiplicación Fallida.");
        end

        // Test 4: Operación 'set'
        opcode = 3'b111;  // Código de operación para 'set'
        c = 8'd42;        // Valor a establecer

        // 'a' y 'b' no son relevantes en esta operación
        a = {WIDTH_V{1'b0}};
        b = {WIDTH_V{1'b0}};

        #10;  // Esperar a que los resultados se propaguen

        $display("\nPrueba de Operación 'set':");
        $display("c = %d", c);
        $display("result = %h", result);

        // Verificar que el resultado es el esperado (c en todos los elementos)
        if (result === {NUM_INSTANCES{c}}) begin
            $display("Prueba de Operación 'set' Exitosa.");
        end else begin
            $display("Prueba de Operación 'set' Fallida.");
        end

        // Finalizar la simulación
        $display("\nTodas las pruebas han sido completadas.");
        $finish;
    end

endmodule
