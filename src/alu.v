`timescale 1ns / 1ps
`include "../include/ALU_OPERATION_DEFINES.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:33:58 08/21/2014 
// Design Name: 
// Module Name:    alu 
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
module alu(A, B, ALU_operation, res, zero, overflow, carry, shamt);
input		[31:0]	A, B;
input		[3:0]		ALU_operation;
input		[4:0]		shamt;

output	[31:0]	res;
output				zero, overflow, carry;

wire signed 	[31:0]	A, B;
wire 		[32:0] 	Au, Bu;
wire		[32:0]	resu;
wire signed		[32:0]	shift_res;

assign Au[32:0] = {1'b0, A[31:0]};
assign Bu[32:0] = {1'b0, B[31:0]};

assign resu = 
				(ALU_operation == `ADDU) ? Au + Bu :
				(ALU_operation == `SUBU) ? Au - Bu : 33'hx;

assign shift_res = B >>> shamt;

assign res = 	
				(ALU_operation == `AND) 	? A & B :
				(ALU_operation == `OR) 		? A | B :
				(ALU_operation == `ADD) 	? A + B :
				(ALU_operation == `SUB) 	? A - B :
				(ALU_operation == `SLT) 	? A < B :
				(ALU_operation == `XOR) 	? A ^ B :
				(ALU_operation == `SLL) 	? B << shamt :
				(ALU_operation == `SRL) 	? B >> shamt :
				(ALU_operation == `SRA) 	? shift_res :
				(ALU_operation == `NOR)		? ~(A | B) :
				(ALU_operation == `ADDU)	? resu[31:0] :
				(ALU_operation == `SUBU)	? resu[31:0] :
				(ALU_operation == `SLTU)	? Au < Bu : 32'hx;

assign zero = ~(|res[31:0]);
assign overflow = (ALU_operation == `ADD && ~A[31] && ~B[31] && res[31]) || // A > 0, B > 0, A + B < 0
						(ALU_operation == `ADD && A[31] && B[31] && ~res[31])  || // A < 0, B < 0, A + B > 0
						(ALU_operation == `SUB && ~A[31] && B[31] && res[31])  || // A > 0, B < 0, A - B < 0
						(ALU_operation == `SUB && A[31] && ~B[31] && ~res[31]);   // A < 0, B > 0, A - B > 0
assign carry = (ALU_operation == `ADDU && resu[32]) ||
					(ALU_operation == `SUBU && Au < Bu);

endmodule
