module counter (
    input logic clk,       // Señal de reloj
    input logic reset,     // Señal de reset
    input logic enable,    // Señal de control del contador
    output logic [31:0] count  // Contador de 32 bits
);


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
        end else if (enable) begin
            count <= count + 1;  // Incrementa el contador si enable está activo
        end
    end

endmodule