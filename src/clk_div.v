`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:32:54 08/21/2014 
// Design Name: 
// Module Name:    clk_div 
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
module clk_div(clk, reset, speed_select, clkdiv, clkcpu);
input					clk, reset, speed_select;
output	[31:0]	clkdiv;
output				clkcpu;

reg	[31:0]	clkdiv;

always @(posedge clk or posedge reset) begin
	if (reset) begin
		clkdiv <= 0;
	end else begin
		clkdiv <= clkdiv + 1'b1;
	end
end
assign clkcpu = speed_select ? clkdiv[24] : clkdiv[1];

endmodule
