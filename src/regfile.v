`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:16 05/27/2014 
// Design Name: 
// Module Name:    regfile 
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
module reg_file(
	clk,
	rs,
	rt,
	rd,
	writeData,
	readData1,
	readData2,
	RegWrite
//	, watch1, watch2
);
input					clk;
input		[4:0]		rs, rt, rd;
input		[31:0]	writeData;
input					RegWrite;
output	[31:0]	readData1, readData2;

//reg		[31:0]	readData1, readData2;
reg 		[31:0]	regs[31:0];

integer i;

initial begin
	for(i = 0; i < 32; i = i + 1)
		regs[i] <= 0;
end

//always @(posedge clk) begin
//	readData1 <= (rs == 0) ? 0 : regs[rs];
//	readData2 <= (rt == 0) ? 0 : regs[rt];
//end
assign readData1 = (rs == 0) ? 0 : regs[rs];
assign readData2 = (rt == 0) ? 0 : regs[rt];

always @(negedge clk) begin
	
	if (RegWrite)
		regs[rd] = writeData;
	regs[0] = 0;
end

endmodule
