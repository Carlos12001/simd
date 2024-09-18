
module hazard
(
	input logic [4:0] rsD, rtD, rsE, rtE,
	input logic [4:0] writeregE, writeregM, writeregW,
	input logic regwriteE, regwriteM, VregwriteM, regwriteW, VregwriteW,
	input logic memtoregE, memtoregM, busy,
	input logic [1:0] branchD,
	output logic forwardaD, forwardbD,
	output logic [1:0] forwardaE, forwardbE, VforwardaE, VforwardbE,
	output logic stallF, stallD, stallE, stallM, stallW, flushE
);


	logic lwstallD, branchstallD;
	
	// forwarding sources to D stage (branch equality)
	assign forwardaD = (rsD !=0 & rsD == writeregM & regwriteM);
	assign forwardbD = (rtD !=0 & rtD == writeregM & regwriteM);
	
	// forwarding sources to E stage (ALU)
	always_comb
	begin
		forwardaE = 2'b00; 
		forwardbE = 2'b00;

		VforwardaE = 2'b00; 
		VforwardbE = 2'b00; 
		
		if (rsE != 0) begin
			if (rsE == writeregM && regwriteM) begin
				forwardaE = 2'b10;
			end else if (rsE == writeregW && regwriteW) begin
				forwardaE = 2'b01;
			end

			if (rsE == writeregM && VregwriteM) begin
				VforwardaE = 2'b10;
			end else if (rsE == writeregW && VregwriteW) begin
				VforwardaE = 2'b01;
			end
		end
		
		if (rtE != 0) begin
			if (rtE == writeregM && regwriteM) begin
				forwardbE = 2'b10;
			end else if (rtE == writeregW && regwriteW) begin
				forwardbE = 2'b01;
			end

			if (rtE == writeregM && VregwriteM) begin
				VforwardbE = 2'b10;
			end else if (rtE == writeregW && VregwriteW) begin
				VforwardbE = 2'b01;
			end
		end
	end

	
	
	// stalls
	assign lwstallD = memtoregE & (rtE == rsD | rtE == rtD);
	assign branchstallD = (branchD[0] | branchD[1]) & (regwriteE & (writeregE == rsD | writeregE == rtD) | 
							memtoregM & (writeregM == rsD | writeregM == rtD));
	assign stallF = stallD;
	assign stallD = lwstallD | branchstallD | busy;
	assign stallE = busy;
	assign stallM = busy;
	assign stallW = busy;
	assign flushE = stallD & ~busy;
	
endmodule
