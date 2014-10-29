`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:12:46 05/27/2014 
// Design Name: 
// Module Name:    ins_decode 
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
module ins_decode(
	reset,
	clk,
	op,
	ctrl,
	status
    );
input					reset, clk;
input		[5:0]		op;
output	[15:0]	ctrl;
output				status;

reg		[1:0]		ALUop, ALUsrcB, PCsource;
reg					PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUsrcA, RegWrite, RegDst;
reg		[7:0]		status;
reg		[15:0]	signal[0:9];
//wire		[15:0]	ctrl = {PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, RegDst, RegWrite, PCsource, ALUsrcA, ALUsrcB, ALUop};
reg		[15:0]	ctrl;

initial begin
	ALUop <= 0;
	ALUsrcA <= 0;
	ALUsrcB <= 0;
	PCsource <= 0;
	PCWriteCond <= 0;
	PCWrite <= 0;
	IorD <= 0;
	MemRead <= 0;
	MemWrite <= 0;
	MemtoReg <= 0;
	IRWrite <= 0;
	RegDst <= 0;
	RegWrite <= 0;
end

// r-type 	000000
// addi 		001000
// beq		000100
// lw			100011
// sw			101011
// j			000010
//

initial begin
	signal[0] <= 16'b0101001000000100;
	signal[1] <= 16'b0000000000001100;
	signal[2] <= 16'b0000000000011000;
	signal[3] <= 16'b0011000000000000;
	signal[4] <= 16'b0000010010000000;
	signal[5] <= 16'b0010100000000000;
	signal[6] <= 16'b0000000000010010;
	signal[7] <= 16'b0000000110000000;
	signal[8] <= 16'b1000000000110001;
	signal[9] <= 16'b0100000001000000;
end

always @(posedge clk or posedge reset) begin
	if (reset)
		status <= 255;
	else
	case (status)
	255, 4, 5, 7, 9: begin
//		MemRead <= 1;
//		IorD <= 0;
//		IRWrite <= 1;
//		ALUsrcA <= 0;
//		ALUsrcB <= 2'b01;
//		ALUop <= 2'b00;
//		PCsource <= 2'b00;
//		PCWrite <= 1'b1;
		ctrl <= signal[0];
		status <= 0;
	end
	0: begin
//		ALUsrcA <= 0;
//		ALUsrcB <= 2'b11;
//		ALUop <= 2'b00;
		ctrl <= signal[1];
		status <= 1;
	end
	1: begin
		if (op == 6'b000000) begin // r-type
//			ALUsrcA <= 1;
//			ALUsrcB <= 2'b00;
//			ALUop <= 2'b10;
			ctrl <= signal[6];
			status <= 6;
		end else if(op == 6'b000010) begin // j
//			PCWrite <= 1;
//			PCsource <= 2'b10;
			ctrl <= signal[9];
			status <= 9;
		end else if(op == 6'b000100) begin // beq
//			ALUsrcA <= 1;
//			ALUsrcB <= 2'b00;
//			ALUop <= 2'b01;
//			PCWriteCond <= 1;
//			PCsource <= 2'b01;			
			ctrl <= signal[8];
			status <= 8;
		end else if (op == 6'b100011 || op == 6'b101011) begin// lw\sw
//			ALUsrcA <= 1;
//			ALUsrcB <= 2'b10;
//			ALUop <= 2'b00;	
			ctrl <= signal[2];
			status <= 2;
		end
	end
	2: begin
		if (op[3]) begin // sw
//			MemWrite <= 1;
//			IorD <= 1;			
			status <= 5;
			ctrl <= signal[5];
		end else begin // lw
//			MemRead <= 1;
//			IorD <= 1;
			status <= 3;
			ctrl <= signal[3];
		end
	end
	3: begin
//		RegWrite <= 1;
//		MemtoReg <= 1;
//		RegDst <= 0;
		ctrl <= signal[4];
		status <= 4;
	end
	6: begin
//		RegDst <= 1;
//		RegWrite <= 1;
//		MemtoReg <= 0;
		ctrl <= signal[7];
		status <= 7;
	end
	8: begin
		ctrl <= signal[0];
		status <= 0;
	end
	endcase
end

endmodule
