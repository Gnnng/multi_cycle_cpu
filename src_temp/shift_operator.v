`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:05:57 10/29/2014 
// Design Name: 
// Module Name:    shift_operator 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module shift_operator(B, shamt, res);

input 	[31:0]	B;
input		[4:0]		shamt;
output 	[31:0]	res;

wire	signed [31:0]	 B;


assign 	res = B >>> shamt;

endmodule
