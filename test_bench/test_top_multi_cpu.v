`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:10:19 08/25/2014
// Design Name:   top_multi_cpu_converted
// Module Name:   D:/GDL/SC/Lab/multi_cpu_converted/test_top_multi_cpu.v
// Project Name:  multi_cpu_converted
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_multi_cpu_converted
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_top_multi_cpu;

	// Inputs
	reg clk;
	reg [7:0] sw;
	reg [4:0] btn;

	// Outputs

	// Instantiate the Unit Under Test (UUT)
	top_multi_cpu_converted uut (
		.clk(clk), 
		.sw(sw), 
		.btn(btn)
	);
	initial begin
		// Initialize Inputs
		clk = 0;
		sw = 8'b000000001;
		btn = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
      fork
			forever #5 clk = ~clk;
		join
		// Add stimulus here

	end
      
endmodule

