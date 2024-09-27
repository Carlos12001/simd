`timescale 1 ns / 1 ps

module dmem_tb();
    localparam WIDTH_V = 256;
    localparam BYTENNA_SIZE= WIDTH_V / 8;  // 128 / 8 = 16
    // Declaración de señales
    logic clk, reset;
    logic [13:0] address;
    logic [BYTENNA_SIZE-1:0] byteena;
    logic [WIDTH_V-1:0] data;
    logic rden, wren;
    logic [WIDTH_V-1:0] q;
    
    // Instanciación del módulo de memoria
    dmem data_mem (
        .address(address),
        .byteena(byteena),
        .clock(clk),
        .data(data),
        .rden(rden),
        .wren(wren),
        .q(q)
    );
    
    // Generación de reloj: 10 ns de periodo (100 MHz)
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Cambia cada 5 ns para un periodo de 10 ns
    end
    
    // Bloque inicial para realizar las operaciones de escritura y lectura
    initial begin
        // Inicialización de señales
        reset <= 1; 
        byteena <= {BYTENNA_SIZE{1'b0}};;
        data <=  {WIDTH_V{1'b0}};
        rden <= 1'd0;
        wren <= 1'd0;
        address <= 14'd0;
        
        // Tiempo para reset
          @(negedge clk);
        reset <= 0;
        
        // Espera al siguiente flanco de reloj
          @(negedge clk);
        
        // 1. Escribir en dirección 0 con 0xCCCCCCCC...CC
        address <= 14'd0;
        byteena <= {BYTENNA_SIZE{1'b1}}; // Habilita todos los bytes
        data <= 256'hCCCC_CCCC_CCCC_CCCC_CCCC_CCCC_CCCC_CCCC_CCCC_CCCC_CCCC_CCCC_CCCC_CCCC_CCCC_CCCC;
        wren <= 1'd1;
        rden <= 1'd0;
          @(negedge clk);
        wren <= 1'd0; // Deshabilita escritura
        
        // Espera un ciclo de reloj
          @(negedge clk);
        
        // 2. Escribir en dirección 5 con 0x55555555...55
        address <= 14'd5;
        byteena <= {BYTENNA_SIZE{1'b1}}; // Habilita todos los bytes
        data <= 256'h5555_5555_5555_5555_5555_5555_5555_5555_5555_5555_5555_5555_5555_5555_5555_5555;
        wren <= 1'd1;
        rden <= 1'd0;
        @(negedge clk);
        wren <= 1'd0; // Deshabilita escritura
        
        // Espera un ciclo de reloj
        @(negedge clk);
        
        // 3. Escribir en dirección 8 en la tercera palabra (bytes [11:8]) con 0xBACADECA
        address <= 14'd8;
        byteena <= 32'b0000___0000_____0000_____0000_____1111_____0000_____0000; // Habilita bytes 8,9,10,11
        // Preparar el dato: solo la tercera palabra (bits [127:96]) contiene 0xBACADECA
        data <= 256'h00000000_BABABABA_00000000_00000000_BACADECA_00000000_00000000;
        wren <= 1'd1;
        rden <= 1'd0;
        @(negedge clk);
				data <= {WIDTH_V{1'b0}};
				address <= 14'd0;
        wren <= 1'd0; // Deshabilita escritura
				byteena <=  {BYTENNA_SIZE{1'b1}}; // Habilita bytes 8,9,10,11
        
        // Espera un ciclo de reloj
          @(negedge clk);
        
        // 4. Lectura de las primeras 10 posiciones de memoria
        rden <= 1'd1;
        for (integer i = 0; i < 10; i = i + 1) begin
            address <= i;
              @(negedge clk);
            // Mostrar el contenido leído
            $display("Lectura en dirección %0d: %h", i, q);
        end
        rden <= 1'd0;
        
        // Finalizar la simulación
				$finish;

    end
    
    // Monitor para observar cambios en q
    initial begin
        $monitor("Dirección: %d | Byteena: %h | Datos: %h | q: %h",
                  address, byteena, data, q);
    end
    
endmodule
