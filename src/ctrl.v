`timescale 1ns / 1ps
`include "ALU_OPERATION_DEFINES.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:35:15 08/24/2014 
// Design Name: 
// Module Name:    ctrl 
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
module ctrl(clk, reset, inst, zero, overflow, mio_ready, state_out, cpu_mio, ctrl_signals, ALUop, Beq, Sign);
input					clk, reset, zero, overflow, mio_ready;
input		[31:0]	inst;

output	[4:0]		state_out;
output				cpu_mio;	//not used
output	[15:0]	ctrl_signals;
output	[3:0]		ALUop;
output				Beq;
output				Sign;

wire		[5:0]		op = inst[31:26];
wire		[5:0]		func = inst[5:0];
reg		[3:0]		ALUop;
reg					Beq;
reg					Sign;
/*
	nencessary informatin. DO NOT DELETE.
reg		[1:0]		ALUsrcB, PCsource, MemtoReg, RegDst;
reg					PCWriteCond, PCWrite, IorD, MemRead, 
						MemWrite, IRWrite, ALUsrcA, RegWrite;
wire	[13:0]	ctrl = {PCWriteCond, PCWrite, IorD, 
						MemRead, MemWrite, MemtoReg, IRWrite, 
						RegDst, RegWrite, PCsource, ALUsrcA, ALUsrcB};
*/
reg		[4:0]		status;

reg		[15:0]	ctrl;
reg		[15:0]	signal[0:31];
reg					cpu_mio_arr[0:30];

assign state_out = status;
assign ctrl_signals = signal[status];
//assign cpu_mio = signal[status];
// r-type 	000000 add, sub, slt, and, or, xor, nor
// beq		000100
// lw			100011
// sw			101011
// j			000010
// 
// NEW INSTRUCTION
// r-type	000000 sll, srl, sra (1-bit), jr		done!
// addi 		001000		done!
// bne		000101   	done!
// lui		001111		done!
// jal		000011		done!
//	andi		001100		done!
//	ori		001101		done!
//	xori		001110		done!
// slti		001010		done!

`define	START		5'D31
`define	ERROR		5'D30
`define	IF			5'D0
`define	ID			5'D1
`define	ADDR		5'D2
`define	MEM_R		5'D3
`define	MEMREG	5'D4
`define	MEM_W		5'D5
`define	RTYPE		5'D6
`define	ALUREG	5'D7
`define	BEQ		5'D8
`define	J			5'D9
`define	BNE		5'D10
`define	JR			5'D11
`define	LUI		5'D12
`define	JAL		5'D13
`define	ALUREGI	5'D14
initial begin
	status <= `START;
	signal[0] 	<= 16'b0101000100000001;
	signal[1] 	<= 16'b0000000000000011;
	signal[2] 	<= 16'b0000000000000110;
	signal[3] 	<= 16'b0011000000000110;	// ALUsrcA/B derived from signal[2]
	signal[4]	<= 16'b0000001000100000;
	signal[5] 	<= 16'b0010100000000110;	// ALUsrcA/B derived from signal[2]
	signal[6] 	<= 16'b0000000000000100;
	signal[7] 	<= 16'b0000000001100000;
	signal[8] 	<= 16'b1000000000001100;
	signal[9] 	<= 16'b0100000000010000;
	signal[10]	<= 16'b1000000000001100;
	signal[11]	<= 16'b0100000000001000;
	signal[12]	<= 16'b0000010000100000;
	signal[13]	<= 16'b0100011010110000;
	signal[14]	<= 16'b0000000000100000;
//	cpu_mio_arr[`IF]				<= 1'b1;			not correct
//	cpu_mio_arr[`ID]				<= 1'b0;
//	cpu_mio_arr[`ADDR]			<= 1'b0;
//	cpu_mio_arr[`MEM_R]			<= 1'b1;
//	cpu_mio_arr[`MEMREG]			<= 1'b0;
//	cpu_mio_arr[`MEM_W]			<= 1'b1;
//	cpu_mio_arr[`RTYPE]			<= 1'b0;
//	cpu_mio_arr[`ALUREG]			<= 1'b0;
//	cpu_mio_arr[`BEQ]				<= 1'b0;
//	cpu_mio_arr[`J]				<= 1'b0;
//	cpu_mio_arr[`BNE]				<= 1'b0;
//	cpu_mio_arr[`JR]				<= 1'b0
//	cpu_mio_arr[`LUI]				<= 1'b0;
//	cpu_mio_arr[`JAR]				<= 1'b0;
//	cpu_mio_arr[`ALUREGI]		<= 1'b0;
//	cpu_mio_arr[`START]			<= 1'b0;
//	cpu_mio_arr[`ERROR]			<= 1'b1;
end

/*
wire	[13:0]	ctrl = {PCWriteCond, PCWrite, IorD, 
					MemRead, MemWrite, MemtoReg, IRWrite, 
					RegDst, RegWrite, PCsource, ALUsrcA, ALUsrcB};
*/

always @(posedge clk or posedge reset) begin
	if (reset) begin
		status <= `START;
	end 
	else
		case (status)
		`ERROR: status <= `ERROR;
		`START, `MEMREG, `ALUREG, `ALUREGI, 
		`J, `BEQ, `BNE, `JR, `LUI, `JAL: begin
			status <= `IF;
			ALUop <= `ADD;
			Sign <= 1'b1;
		end
		
		`IF: begin
			if (mio_ready) begin
				status <= `ID;
				ALUop <= `ADD;
			end else
				status <= `IF;
				ALUop <= `ADD;
				Sign <= 1'b1;
		end
		
		`ID:
		case(op[5:0])
			6'b000000: begin								// R-type
				case(func[5:0])
					6'b100000: ALUop <= `ADD;
					6'b100010: ALUop <= `SUB;
					6'b100100: ALUop <= `AND;
					6'b100101: ALUop <= `OR;
					6'b100110: ALUop <= `XOR;
					6'b101010: ALUop <= `SLT;
					6'b000000: ALUop <= `SLL;
					6'b000010: ALUop <= `SRL;
					6'b000011: ALUop <= `SRA;
					6'b100111: ALUop <= `NOR;
					6'b001000: ALUop <= `ADD;			// jr
				endcase
				case(func[5:0])
					6'b100000,
					6'b100010,
					6'b100100,
					6'b100101,
					6'b100110,
					6'b101010,
					6'b000000,
					6'b000010,
					6'b000011,
					6'b100111,
					6'b001000:
						status <= `RTYPE;
					default:
						status <= `ERROR;
				endcase
			end
			6'b000010: begin								// j
				status <= `J;
			end
			6'b000100: begin								// beq
				status <= `BEQ;
				ALUop <= `SUB;
				Beq <= 1;
			end
			6'b000101: begin								// bne
				status <= `BNE;
				ALUop <= `SUB;
				Beq <= 0;
			end
			6'b100011, 6'b101011: begin				// lw/sw
				status <= `ADDR;
				ALUop <= `ADD;
			end
			6'b001000: begin								// addi
				status <= `ADDR;
				ALUop <= `ADD;
			end
			6'b001100: begin								// andi
				status <= `ADDR;
				ALUop <= `AND;
				Sign <= 1'b0;
			end
			6'b001101: begin								// ori
				status <= `ADDR;
				ALUop <= `OR;
				Sign <= 1'b0;
			end
			6'b001110: begin								// xori
				status <= `ADDR;
				ALUop <= `XOR;
				Sign <= 1'b0;
			end
			6'b001010: begin								// slti
				status <= `ADDR;
				ALUop <= `ADD;
			end
//			6'b100011, 										// lw
//			6'b101011, 										// sw
//			6'b001000, 										// addi
//			6'b001100, 										// andi
//			6'b001101, 										// ori
//			6'b001110, 										// xori
//			6'b001010: begin								// slti
//				status <= `ADDR;
//				case(op[5:0])
//					6'b100011, 
//					6'b101011, 
//					6'b001000: ALUop <= `ADD;
//					6'b001100: ALUop <= `AND;
//					6'b001101: ALUop <= `OR;
//					6'b001110: ALUop <= `XOR;
//					6'b001010: ALUop <= `SLT;
//				endcase
//			end
			6'b000011: begin
				status <= `JAL;							// jal
			end
			6'b001111: begin
				status <= `LUI;							// lui
			end
			default: begin
				ALUop <= `ADD;
				Beq <= 0;
				status <= `ERROR;
			end
		endcase

		`ADDR: begin
			case(op[5:0])
				6'b100011: status <= `MEM_R;
				6'b101011: status <= `MEM_W;
				6'b001000, 
				6'b001100, 
				6'b001101, 
				6'b001110, 
				6'b001010: status <= `ALUREGI;
				default: begin
					ALUop <= `ADD;
					Beq <= 0;
					status <= `ERROR;
				end
			endcase
		end
		
		`MEM_R: begin
			if (mio_ready)
				status <= `MEMREG;
			else
				status <= `MEM_R;
		end
		
		`MEM_W: begin
			if (mio_ready) begin
				status <= `IF;
				ALUop <= `ADD;
				Sign <= 1'b1;
			end else
				status <= `MEM_W;
		end
		
		`RTYPE: begin
			case(func[5:0])
				6'b100000,
				6'b100010,
				6'b100100,
				6'b100101,
				6'b100110,
				6'b101010,
				6'b000000,
				6'b000010,
				6'b000011,
				6'b100111: begin
					status <= `ALUREG;
				end
				6'b001000:
					status <= `JR;
				default: begin
					status <= `ERROR;
					ALUop <= `ADD;
					Beq <= 0;
				end
			endcase
		end
	endcase
end

endmodule

