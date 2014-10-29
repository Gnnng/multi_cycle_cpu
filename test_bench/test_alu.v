`timescale 1ns / 1ps
`include "ALU_OPERATION_DEFINES.v"
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:41:43 08/23/2014
// Design Name:   alu
// Module Name:   D:/GDL/SC/Lab/multi_cpu_converted/test_alu.v
// Project Name:  multi_cpu_converted
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_alu;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;
	reg [3:0]  ALU_operation;
	reg [4:0]  shamt;
	
	// Outputs
	wire [31:0] res;
	wire zero;
	wire overflow;
	wire carry;

	// Instantiate the Unit Under Test (UUT)
	alu uut (
		.A(A), 
		.B(B), 
		.ALU_operation(ALU_operation), 
		.res(res), 
		.zero(zero), 
		.shamt(shamt),
		.overflow(overflow),
		.carry(carry)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		ALU_operation = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		// test AND
		A = 32'hffff0000;
		B = 32'haaaaaaaa;
		ALU_operation = `AND;
		#20;
		
		// test OR
		A = 32'hffff0000;
		B = 32'haaaaaaaa;
		ALU_operation = `OR;
		#20;
		
		// test ADD
		A = 32'h7fffffff;
		B = 32'h1;
		ALU_operation = `ADD;
		#20
		
		A = 32'hffffffff;
		B = 32'hffffffff;
		ALU_operation = `ADD;
		#20;
		
		A = 32'h80000000;
		B = 32'hffffffff;
		ALU_operation = `ADD;
		#20;
		
		// test SUB
		A = 32'h7fffffff;
		B = 32'hffffffff;
		ALU_operation = `SUB;
		#20
		
		A = 32'h80000000;
		B = 32'h1;
		ALU_operation = `SUB;
		#20;
		
		// test ADDU;
		A = 32'hffffffff;
		B = 32'h1;
		ALU_operation = `ADDU;
		#20;
		
		A = 32'h1;
		B = 32'h1;
		ALU_operation = `ADDU;
		#20;
		
		// test SUBU;
		A = 32'h0;
		B = 32'h1;
		ALU_operation = `SUBU;
		#20;
		
		// test SLT & SLTU
		
		A = 32'hffffffff;
		B = 32'h1;
		ALU_operation = `SLT;
		#20;
		
		ALU_operation = `SLTU;
		#20;
		
		A = 32'h80000000;
		B = 32'h1;
		ALU_operation = `SLT;
		#20;
		
		ALU_operation = `SLTU;
		#20;
		
		// test SLL
		B = 32'hffffffff;
		ALU_operation = `SLL;
		shamt = 1;
		#20;
		
		shamt = 2;
		#20;
		
		shamt = 31;
		#20;
		
		// test SRA & SRL
		B = 32'hffff0000;
		ALU_operation = `SRL;
		shamt = 1;
		#20;
		
		shamt = 2;
		#20;
		
		shamt = 3;
		#20;
		
		ALU_operation = `SRA;
		shamt = 1;
		#20;

		shamt = 2;
		#20;
		
		shamt = 3;
		#20;
		
	end
      
endmodule

