module muxout (
    input logic debug,
    input logic [31:0] pcF,
    output logic [6:0] display1,
    output logic [6:0] display2,
    output logic [6:0] display3,
    output logic [6:0] display4,
    output logic [6:0] display5,
    output logic [6:0] display6
);

	logic [3:0] aux_out = 4'b0000;

	// Instance of displayconverter modules
	displayconverter converter1(.number(debug ? pcF[3:0] : aux_out), .segment(display1));
	displayconverter converter2(.number(debug ? pcF[7:4] : aux_out), .segment(display2));
	displayconverter converter3(.number(debug ? pcF[11:8] : aux_out), .segment(display3));
	displayconverter converter4(.number(debug ? pcF[15:12] : aux_out), .segment(display4));
	displayconverter converter5(.number(debug ? pcF[19:16] : aux_out), .segment(display5));
	displayconverter converter6(.number(debug ? pcF[23:20] : aux_out), .segment(display6));
	
endmodule