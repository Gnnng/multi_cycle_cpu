`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:25:45 08/24/2014 
// Design Name: 
// Module Name:    datapath 
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
module datapath(clk, reset, mio_ready, ctrl_signals, ALU_operation, PC, data2cpu, inst, data_out, m_addr, zero, overflow, Beq, Sign);
input					clk, mio_ready;
input					reset;
input		[15:0]	ctrl_signals;
input		[31:0]	data2cpu;
input		[3:0]		ALU_operation;
input					Beq;
input					Sign;

output	[31:0]	PC, inst, m_addr, data_out;
output				zero, overflow;


wire		[31:0]	PC = pc;
// unmodified
wire					zero;
reg		[31:0]	ALUout;

reg		[31:0]	IR;

wire		[1:0]		ALUsrcB, PCsource, MemtoReg, RegDst;
wire					PCWriteCond, PCWrite, IorD, MemRead, MemWrite, IRWrite, ALUsrcA, RegWrite;

assign {PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, RegDst, RegWrite, PCsource, ALUsrcA, ALUsrcB} = ctrl_signals;

// pc source
reg		[31:0]	pc;
wire		[31:0]	pc_new;
wire					pc_new_signal;

assign inst = IR;

assign pc_new_signal = PCWrite | (PCWriteCond & ((zero & Beq) | (~zero & ~Beq)));

always @(posedge clk or posedge reset) begin
	if (reset)
		pc <= 32'b0;
	else if (pc_new_signal)
		pc <= pc_new;
end

assign m_addr = IorD ? ALUout : pc;

reg		[31:0]	regA, regB;
assign data_out = regB;

// memory data register
reg		[31:0]	MDR;

// registers file
wire		[4:0]		rd;
wire		[31:0]	readData1, readData2, writeData;
//assign	rd = (RegDst ? IR[15:11] : IR[20:16]);
assign rd = 	(RegDst[1:0] == 2'b00) ? IR[20:16] :
					(RegDst[1:0] == 2'b01) ? IR[15:11] :
					(RegDst[1:0] == 2'b10) ? 5'd31 : 5'hx;
					
//assign	writeData = MemtoReg ? MDR : ALUout;
wire		[31:0]	upper_16 = {IR[15:0], 16'b0};
assign writeData = 	(MemtoReg[1:0] == 2'b00) ? ALUout :
							(MemtoReg[1:0] == 2'b01) ? MDR :
							(MemtoReg[1:0] == 2'b10) ? upper_16 : pc;

reg_file register_file(
	.clk(clk),
	.rs(IR[25:21]),
	.rt(IR[20:16]),
	.rd(rd),
	.writeData(writeData),
	.readData1(readData1),
	.readData2(readData2),
	.RegWrite(RegWrite)
);

// reg buffer
always @(posedge clk) begin
	regA <= readData1;
	regB <= readData2;
end

// ALU
wire					Sign;
wire		[31:0]	ext_32 = {{16{IR[15] & Sign}}, IR[15:0]}; 				// sign-extended

wire		[31:0]	ext_32_sl = {{14{IR[15]}}, IR[15:0], 2'b00}; // shift left by 2
wire		[31:0]	op1 = ALUsrcA ? regA : pc;
wire		[31:0]	op2 = 
							ALUsrcB == 2'b00 ? regB : 
							ALUsrcB == 2'b01 ? 32'h00000004 :
							ALUsrcB == 2'b10 ? ext_32 : ext_32_sl;

wire		[31:0]	result;

alu alu(
	.A(op1), 
	.B(op2), 
	.ALU_operation(ALU_operation), 
	.res(result), 
	.zero(zero), 
	.overflow(overflow),
	.shamt(IR[10:6])
);

// pc new
wire		[31:0]	pc_jump = {pc[31:28], IR[25:0], 2'b00};
assign	pc_new = 
					PCsource == 2'b00 ? (mio_ready ? result : pc_new) : // pc + 4
					PCsource == 2'b01 ? ALUout : // 
					PCsource == 2'b10 ? pc_jump : 32'b0; // jump

always @(posedge clk) begin
	if (IRWrite && mio_ready)
		IR <= data2cpu;
	else
		IR <= IR;
	if (mio_ready)
		MDR <= data2cpu;
		ALUout <= result;
end

endmodule
