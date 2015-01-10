`timescale 1ns / 1ps
`include "../include/CONFIG_DEFINES.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:25:41 01/05/2015 
// Design Name: 
// Module Name:    ram 
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
module ram(clka, wea, addra, dina, douta);
input					clka, wea;
input		[31: 0]	addra;
input		[31: 0]	dina;
output	[31:0]	douta;

ram_block_temp U2_1(
	.clka(clka),
	.wea(wea),
	.addra(addra[13: 2]),
	.dina(dina),
	.douta(douta)
);
//
//ram_block U2_2(					// fake block
//	.clka(clka),
//	.wea(wea),
//	.addra(ram_addr),
//	.dina(ram_data_in),
//	.douta(ram_data_out)
//);

endmodule
