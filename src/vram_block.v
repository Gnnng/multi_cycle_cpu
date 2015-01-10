`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:01:20 01/06/2015 
// Design Name: 
// Module Name:    vram_block 
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
module vram_block(clka, wea, addra, dina, douta);
input			clka, wea;
input		[10:0]	addra;
input		[18:0]	dina;
output	[18:0]	douta;

reg		[18:0]	douta;
reg		[18:0]	memory;

always @(posedge clka) begin
	if (wea)
		memory <= dina;
	else
		douta <= {3'b110, 16'h0061};
end

endmodule
