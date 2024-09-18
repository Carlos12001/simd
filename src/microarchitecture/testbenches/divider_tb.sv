module divider_tb;

    // Definir los puertos y señales del testbench
    logic [31:0] numerator;
    logic [31:0] denominator;

    logic [15:0] result;

    // Instanciar el módulo de división de enteros
    divider division(
        numerator,
        denominator,
        result
    );

    // Inicializar los valores de entrada
    initial begin
        numerator = 111; // Numerador
        denominator = 5; // Denominador

        // Esperar un tiempo suficiente para que la división se complete
        #10;

        

        // Terminar la simulación
    end

endmodule
