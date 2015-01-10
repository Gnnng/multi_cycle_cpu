`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:48:11 05/27/2014 
// Design Name: 
// Module Name:    cpu 
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
module multi_cycle_cpu(
	clk,
	reset,
	mio_ready,
	pc_out,		// test
	inst,			// test
	mem_w,
	addr_out,
	data_out,
	data_in,
	state,
	INTsignal
);

input					clk;
input					reset;
input					mio_ready;
input		[31:0]	data_in;
input 				INTsignal;

output	[31:0]	pc_out;
output	[31:0]	inst;
output				mem_w;
output	[31:0]	addr_out, data_out;
output	[4:0]		state;

wire		[31:0]	PC;
wire		[4:0]		state;

wire					zero, overflow;

// int_ctrl_signals
wire		[1:0]		PCint;
wire					EPCWrite, INTenable, INTdisable, CP0RegWrite, RegWriteSource;
wire		[31:0]	INTcause;
wire 					_INTsignal;

assign _INTsignal = INTsignal & INTable;

//assign int_signals = {PCint, EPCWrite, INTenable, INTWrite, INTsyscall, CP0RegWrite, RegWriteSource};		

`define int_ctrl_signals {PCint, EPCWrite, INTenable, INTdisable, CP0RegWrite, RegWriteSource}
								
// control signals
wire		[3:0]		ALU_operation;
wire		[1:0]		ALUsrcB, PCsource, RegDst, MemtoReg;
wire					MemRead, MemWrite, IorD, IRWrite, RegWrite, ALUsrcA, PCWrite, PCWriteCond, Beq, Sign;

`define cpu_ctrl_signals {PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, RegDst, RegWrite, PCsource, ALUsrcA, ALUsrcB}
wire					INTable;

datapath U2(
	.clk(clk),
	.reset(reset),
	.mio_ready(mio_ready),
	.ALU_operation(ALU_operation),
	.ctrl_signals(`cpu_ctrl_signals),
	.PC(PC),
	.data2cpu(data_in),
	.inst(inst),
	.data_out(data_out),
	.m_addr(addr_out),
	.zero(zero),
	.overflow(overflow),
	.Beq(Beq),
	.Sign(Sign),
	.int_signals(`int_ctrl_signals),
	.INTcause(INTcause),
	.INTable(INTable)
);

ctrl U1(
	.clk(clk),
	.reset(reset),
	.inst(inst),
	.zero(zero),
	.overflow(overflow),
	.mio_ready(mio_ready),
	.state_out(state),
	.ctrl_signals(`cpu_ctrl_signals),
	.ALUop(ALU_operation),
	.Beq(Beq),
	.Sign(Sign),
	.INTsignal(_INTsignal), //TODO: not good design
	.int_signals(`int_ctrl_signals),
	.INTcause(INTcause)
);



assign mem_w = MemWrite && ~MemRead && ~clk;
assign pc_out = PC;

endmodule
