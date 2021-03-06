`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:12:51 08/25/2014 
// Design Name: 
// Module Name:    cpu_n_ram 
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
module cpu_n_ram(clk, reset, pc, inst, state, INTsignal);
input					clk;
input					reset;
input 				INTsignal;

output	[31:0]	pc;
output	[31:0]	inst;
output	[4:0]		state;

wire					clkcpu, clk_mem, wea;
wire		[31:0]	cpu_addr;
wire		[31:0]	cpu_data2bus, cpu_data4bus;

clk_div U8(
.clk(clk), 
.reset(reset), 
.speed_select(1'b0), 
.clkcpu(clkcpu)
);

assign clk_mem = ~clk;

multi_cycle_cpu U1(
	.clk(clkcpu),
	.reset(reset),
	.mio_ready(1'b1),
	.pc_out(pc),		// test
	.inst(inst),			// test
	.mem_w(mem_w),
	.addr_out(cpu_addr),
	.data_out(cpu_data2bus),
	.data_in(cpu_data4bus),
	.state(state),
	.INTsignal(INTsignal)
);

ram_block_temp U2(
	.clka(clk_mem),
	.wea(mem_w),
	.addra(cpu_addr[13:2]),
	.dina(cpu_data2bus),
	.douta(cpu_data4bus)
);



endmodule
