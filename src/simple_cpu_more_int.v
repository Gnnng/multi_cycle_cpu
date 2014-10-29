`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:31:54 08/21/2014 
// Design Name: 
// Module Name:    simple_cpu_more_int 
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
module simple_cpu_more_int(clk, reset, pc_out, inst_in, mem_w, addr_out, cpudata_out, cpudata_in, INT);
input					reset, INT, mem_w;
input		[31:0]	inst_in, cpudata_in;
output				pc_out;
output	[31:0]	addr_out, cpudata_out;


endmodule
