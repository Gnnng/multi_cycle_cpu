`timescale 1ns / 1ps
`include "../include/CONFIG_DEFINES.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:30:36 01/05/2015 
// Design Name: 
// Module Name:    vram 
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
module vram(clka, wea, addra, dina, douta);
input					clka, wea;
input		[31: 0]	addra;
input		[31: 0]	dina;
output	[31: 0]	douta;

wire		[`VRAM_WIDTH - 1: 0] data_out;

assign 	douta = {13'b0, data_out};

vram_block U3(
	.clka(clka),
	.wea(wea),
	.addra(addra[`VRAM_DEEPTH - 1 + 2:2]),
	.dina(dina[`VRAM_WIDTH - 1: 0]),
	.douta(data_out)
);

endmodule
