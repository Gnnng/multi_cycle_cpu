`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:57:44 08/24/2014
// Design Name:   counter_x
// Module Name:   D:/GDL/SC/Lab/multi_cpu_converted/test_counter_x.v
// Project Name:  multi_cpu_converted
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: counter_x
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_counter_x;

	// Inputs
	reg clk;
	reg reset;
	reg clk0;
	reg clk1;
	reg clk2;
	reg counter_we;
	reg [31:0] counter_val;
	reg [1:0] counter_ch;

	// Outputs
	wire counter0_out;
	wire counter1_out;
	wire counter2_out;
	wire [31:0] counter_out;

	// Instantiate the Unit Under Test (UUT)
	counter_x uut (
		.clk(clk), 
		.reset(reset), 
		.clk0(clk0), 
		.clk1(clk1), 
		.clk2(clk2), 
		.counter_we(counter_we), 
		.counter_val(counter_val), 
		.counter_ch(counter_ch), 
		.counter0_out(counter0_out), 
		.counter1_out(counter1_out), 
		.counter2_out(counter2_out), 
		.counter_out(counter_out)
	);

	integer i;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		clk0 = 0;
		clk1 = 0;
		clk2 = 0;
		counter_we = 0;
		counter_val = 0;
		counter_ch = 0;
		i = 0;
		// Wait 100 ns for global reset to finish
		#100;
		
		fork
			forever #10 clk = ~clk;
			forever #40 clk0 = ~clk0;
			forever #60 clk1 = ~clk1;
			forever #100 clk2 = ~clk2;
			forever 
			begin 
				#20;
				i <= i + 1;
				case(i)
				1: reset <= 1;
				2: reset <= 0;
				3: begin 
					counter_we <= 1;
					counter_val <= 5;
					counter_ch <= 1;
				end
				4: begin
					counter_we <= 0;
				end
				5: begin
					counter_we <= 1;
					counter_val <= 3;
					counter_ch <= 0;
				end
				6: begin
					counter_we <= 0;
				end
				7: begin
					counter_we <= 1;
					counter_val <= 10;
					counter_ch <= 2;
				end
				8: counter_we <= 0;
				endcase
			end
		join
	end  
endmodule

