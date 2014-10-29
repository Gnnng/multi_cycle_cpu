`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:17:41 08/25/2014
// Design Name:   ram_block
// Module Name:   D:/GDL/SC/Lab/multi_cpu_converted/test_ram_block.v
// Project Name:  multi_cpu_converted
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ram_block
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_ram_block;

	// Inputs
	reg clka;
	reg [0:0] wea;
	reg [10:0] addra;
	reg [31:0] dina;

	// Outputs
	wire [31:0] douta;

	// Instantiate the Unit Under Test (UUT)
	ram_block uut (
		.clka(clka), 
		.wea(wea), 
		.addra(addra), 
		.dina(dina), 
		.douta(douta)
	);
	integer i;
	initial begin
		// Initialize Inputs
		clka = 0;
		wea = 0;
		addra = 0;
		dina = 0;

		// Wait 100 ns for global reset to finish
		#100;
      fork
			forever #10 clka = ~clka;
			for ( i = 0 ; i < 100; i = i + 1) begin
				#100;
				addra <= i;
			end
		join
		// Add stimulus here

	end   
endmodule

