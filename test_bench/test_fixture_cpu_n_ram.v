`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:37:38 08/25/2014
// Design Name:   test_cpu_n_ram
// Module Name:   D:/GDL/SC/Lab/multi_cpu_converted/test_fixture_cpu_n_ram.v
// Project Name:  multi_cpu_converted
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: test_cpu_n_ram
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_fixture_cpu_n_ram;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [31:0] pc;
	wire [31:0] inst;
	wire [4:0] state;

	// Instantiate the Unit Under Test (UUT)
	test_cpu_n_ram uut (
		.clk(clk), 
		.reset(reset), 
		.pc(pc), 
		.inst(inst), 
		.state(state)
	);

	integer i;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
      fork
			forever #10 clk = ~clk;
			begin
				#10
				for(i = 0; i < 1000; i = i + 1) begin
					#20;
					case(i)
						5: reset = 1;
						10: reset = 0;
					endcase
				end
			end
		join
		// Add stimulus here

	end
      
endmodule

