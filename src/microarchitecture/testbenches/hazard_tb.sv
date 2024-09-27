`timescale 1ns/1ps

module hazard_tb;

    // Declaración de señales de entrada como reg
    reg [4:0] rsD, rtD, rsE, rtE;
    reg [4:0] writeregE, writeregM, writeregW;
    reg regwriteE, regwriteM, VregwriteM, regwriteW, VregwriteW;
    reg memtoregE, memtoregM, busy;
    reg [1:0] branchD;

    // Declaración de señales de salida como wire
    wire forwardaD, forwardbD;
    wire [1:0] forwardaE, forwardbE, VforwardaE, VforwardbE;
    wire stallF, stallD, stallE, stallM, stallW, flushE;

    // Instanciación del módulo hazard
    hazard uut (
        .rsD(rsD),
        .rtD(rtD),
        .rsE(rsE),
        .rtE(rtE),
        .writeregE(writeregE),
        .writeregM(writeregM),
        .writeregW(writeregW),
        .regwriteE(regwriteE),
        .regwriteM(regwriteM),
        .VregwriteM(VregwriteM),
        .regwriteW(regwriteW),
        .VregwriteW(VregwriteW),
        .memtoregE(memtoregE),
        .memtoregM(memtoregM),
        .busy(busy),
        .branchD(branchD),
        .forwardaD(forwardaD),
        .forwardbD(forwardbD),
        .forwardaE(forwardaE),
        .forwardbE(forwardbE),
        .VforwardaE(VforwardaE),
        .VforwardbE(VforwardbE),
        .stallF(stallF),
        .stallD(stallD),
        .stallE(stallE),
        .stallM(stallM),
        .stallW(stallW),
        .flushE(flushE)
    );

    // Inicialización de señales y apertura de archivo de registro
    initial begin
        // Mostrar encabezados en la consola
        $display("Time | rsD rtD rsE rtE | writeregE writeregM writeregW | regwriteE regwriteM VregwriteM regwriteW VregwriteW | memtoregE memtoregM busy | branchD | forwardaD forwardbD | forwardaE forwardbE VforwardaE VforwardbE | stallF stallD stallE stallM stallW flushE");
        $display("-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
        
        // Monitorear todas las señales para imprimir en cada cambio
        $monitor("%0t | %b %b %b %b | %b %b %b | %b %b %b %b %b | %b %b %b | %b | %b %b | %b %b %b %b | %b %b %b %b %b %b",
            $time,
            rsD, rtD, rsE, rtE,
            writeregE, writeregM, writeregW,
            regwriteE, regwriteM, VregwriteM, regwriteW, VregwriteW,
            memtoregE, memtoregM, busy,
            branchD,
            forwardaD, forwardbD,
            forwardaE, forwardbE, VforwardaE, VforwardbE,
            stallF, stallD, stallE, stallM, stallW, flushE
        );

        // Inicialización de todas las señales a cero
        rsD = 5'd0; rtD = 5'd0; rsE = 5'd0; rtE = 5'd0;
        writeregE = 5'd0; writeregM = 5'd0; writeregW = 5'd0;
        regwriteE = 1'b0; regwriteM = 1'b0; VregwriteM = 1'b0;
        regwriteW = 1'b0; VregwriteW = 1'b0;
        memtoregE = 1'b0; memtoregM = 1'b0; busy = 1'b0;
        branchD = 2'b00;

        // Esperar 10ns antes de comenzar las pruebas
        #10;

        // **Caso 1: No hay hazard**
        $display("\n=== Caso 1: No hay hazard ===");
        rsD = 5'd1; rtD = 5'd2; rsE = 5'd3; rtE = 5'd4;
        writeregE = 5'd5; writeregM = 5'd6; writeregW = 5'd7;
        regwriteE = 1'b0; regwriteM = 1'b0; VregwriteM = 1'b0;
        regwriteW = 1'b0; VregwriteW = 1'b0;
        memtoregE = 1'b0; memtoregM = 1'b0; busy = 1'b0;
        branchD = 2'b00;
        #10;

        // **Caso 2: Forwarding desde M stage para rsE**
        $display("\n=== Caso 2: Forwarding desde M stage para rsE ===");
        rsD = 5'd1; rtD = 5'd2; rsE = 5'd5; rtE = 5'd4;
        writeregE = 5'd5; writeregM = 5'd6; writeregW = 5'd7;
        regwriteE = 1'b0; regwriteM = 1'b1; VregwriteM = 1'b1;
        regwriteW = 1'b1; VregwriteW = 1'b1;
        memtoregE = 1'b0; memtoregM = 1'b0; busy = 1'b0;
        branchD = 2'b00;
        #10;

        // **Caso 3: Forwarding desde W stage para rsE**
        $display("\n=== Caso 3: Forwarding desde W stage para rsE ===");
        rsD = 5'd1; rtD = 5'd2; rsE = 5'd7; rtE = 5'd4;
        writeregE = 5'd5; writeregM = 5'd6; writeregW = 5'd7;
        regwriteE = 1'b0; regwriteM = 1'b1; VregwriteM = 1'b0;
        regwriteW = 1'b1; VregwriteW = 1'b1;
        memtoregE = 1'b0; memtoregM = 1'b0; busy = 1'b0;
        branchD = 2'b00;
        #10;

        // **Caso 4: Load-Use Hazard causando stall**
        $display("\n=== Caso 4: Load-Use Hazard causando stall ===");
        rsD = 5'd1; rtD = 5'd2; rsE = 5'd3; rtE = 5'd2;
        writeregE = 5'd4; writeregM = 5'd5; writeregW = 5'd6;
        regwriteE = 1'b1; regwriteM = 1'b1; VregwriteM = 1'b1;
        regwriteW = 1'b1; VregwriteW = 1'b1;
        memtoregE = 1'b1; memtoregM = 1'b0; busy = 1'b0;
        branchD = 2'b00;
        #10;

        // **Caso 5: Branch Hazard con regwriteE**
        $display("\n=== Caso 5: Branch Hazard con regwriteE ===");
        rsD = 5'd1; rtD = 5'd2; rsE = 5'd4; rtE = 5'd5;
        writeregE = 5'd1; writeregM = 5'd6; writeregW = 5'd7;
        regwriteE = 1'b1; regwriteM = 1'b0; VregwriteM = 1'b0;
        regwriteW = 1'b1; VregwriteW = 1'b1;
        memtoregE = 1'b0; memtoregM = 1'b0; busy = 1'b0;
        branchD = 2'b01; // branchD[0] activo
        #10;

        // **Caso 6: Branch Hazard con memtoregM**
        $display("\n=== Caso 6: Branch Hazard con memtoregM ===");
        rsD = 5'd1; rtD = 5'd2; rsE = 5'd3; rtE = 5'd4;
        writeregE = 5'd5; writeregM = 5'd2; writeregW = 5'd7;
        regwriteE = 1'b0; regwriteM = 1'b1; VregwriteM = 1'b1;
        regwriteW = 1'b1; VregwriteW = 1'b1;
        memtoregE = 1'b0; memtoregM = 1'b1; busy = 1'b0;
        branchD = 2'b10; // branchD[1] activo
        #10;

        // **Caso 7: Busy activo**
        $display("\n=== Caso 7: Busy activo ===");
        rsD = 5'd1; rtD = 5'd2; rsE = 5'd3; rtE = 5'd4;
        writeregE = 5'd5; writeregM = 5'd6; writeregW = 5'd7;
        regwriteE = 1'b1; regwriteM = 1'b1; VregwriteM = 1'b1;
        regwriteW = 1'b1; VregwriteW = 1'b1;
        memtoregE = 1'b0; memtoregM = 1'b0; busy = 1'b1;
        branchD = 2'b00;
        #10;

        // **Caso 8: flushE activo cuando stallD está activo y busy está desactivado**
        $display("\n=== Caso 8: flushE activo cuando stallD está activo y busy está desactivado ===");
        rsD = 5'd1; rtD = 5'd2; rsE = 5'd4; rtE = 5'd5;
        writeregE = 5'd1; writeregM = 5'd6; writeregW = 5'd7;
        regwriteE = 1'b1; regwriteM = 1'b0; VregwriteM = 1'b0;
        regwriteW = 1'b1; VregwriteW = 1'b1;
        memtoregE = 1'b0; memtoregM = 1'b0; busy = 1'b0;
        branchD = 2'b01; // branchD activo
        #10;

        // **Caso 9: Multiple Hazards simultáneos**
        $display("\n=== Caso 9: Multiple Hazards simultáneos ===");
        rsD = 5'd2; rtD = 5'd3; rsE = 5'd5; rtE = 5'd2;
        writeregE = 5'd2; writeregM = 5'd3; writeregW = 5'd4;
        regwriteE = 1'b1; regwriteM = 1'b1; VregwriteM = 1'b1;
        regwriteW = 1'b1; VregwriteW = 1'b1;
        memtoregE = 1'b1; memtoregM = 1'b1; busy = 1'b0;
        branchD = 2'b11; // Ambos bits de branchD activos
        #10;

        // **Caso 10: Reset a valores iniciales**
        $display("\n=== Caso 10: Reset a valores iniciales ===");
        rsD = 5'd0; rtD = 5'd0; rsE = 5'd0; rtE = 5'd0;
        writeregE = 5'd0; writeregM = 5'd0; writeregW = 5'd0;
        regwriteE = 1'b0; regwriteM = 1'b0; VregwriteM = 1'b0;
        regwriteW = 1'b0; VregwriteW = 1'b0;
        memtoregE = 1'b0; memtoregM = 1'b0; busy = 1'b0;
        branchD = 2'b00;
        #10;

        // Finalizar la simulación
        $finish;
    end

endmodule
