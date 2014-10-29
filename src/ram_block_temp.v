`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:43:50 08/29/2014 
// Design Name: 
// Module Name:    ram_block_temp 
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
module ram_block_temp(clka, wea, addra, dina, douta);
input 				clka;
input 	[0:0] 	wea;
input 	[11:0] 	addra;
input 	[31:0] 	dina;
output 	[31:0] 	douta;

reg		[31:0]	douta;
reg		[31:0]	memory[0:4095];

initial begin
	$readmemb("./coe/test_ram_temp.ram", memory);
end

always @(posedge clka) begin
	if (wea)
		memory[addra[11:0]] <= dina;
	else
		douta <= memory[addra[11:0]];
end

endmodule