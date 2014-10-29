`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:50:00 08/29/2014
// Design Name:   ram_block_temp
// Module Name:   D:/GDL/SC/Lab/multi_cpu_converted/test_ram_temp.v
// Project Name:  multi_cpu_converted
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ram_block_temp
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_ram_temp;

	// Inputs
	reg clka;
	reg [0:0] wea;
	reg [10:0] addra;
	reg [31:0] dina;

	// Outputs
	wire [31:0] douta;

	// Instantiate the Unit Under Test (UUT)
	ram_block_temp uut (
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
			forever #5 clka = ~clka;
			begin 
				for(i = 0; i < 1000; i = i + 1) begin
					#10;
					case(i)
						4: begin
							addra = 32'h2;
						end
						8: addra = 32'h8;
						10: begin
							addra = 32'h0;
							dina = 32'h12345678;
							wea = 1;
						end
					endcase
				end
			end
		join
		// Add stimulus here

	end
      
endmodule

