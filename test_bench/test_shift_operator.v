`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:07:31 10/29/2014
// Design Name:   shift_operator
// Module Name:   C:/Users/Gnnng/Documents/ZJU/SC/Lab/multi_cpu_converted/test_shift_operator.v
// Project Name:  multi_cpu_converted
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: shift_operator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_shift_operator;

	// Inputs
	reg [31:0] B;
	reg [4:0] shamt;

	wire [31:0]	res;
	// Instantiate the Unit Under Test (UUT)
	shift_operator uut (
		.B(B), 
		.shamt(shamt),
		.res(res)
	);

	initial begin
		// Initialize Inputs
		B = 0;
		shamt = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		B = 32'h80000000;
		shamt = 3;
		#20;
	end
      
endmodule

