`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:06:09 08/21/2014 
// Design Name: 
// Module Name:    anti_jitter 
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
module anti_jitter(clk, btn, sw, btn_out, sw_out);
input					clk;
input		[4:0]		btn;
input		[7:0]		sw;
output	[4:0]		btn_out;
output	[7:0]		sw_out;

reg	[4:0]		btn_out;
reg	[7:0]		sw_out;
reg	[31:0]	counter;

always @(posedge clk) begin
	if (counter > 0) begin
		if (counter < 100000) 
			counter <= counter + 1;
		else begin
			counter <= 32'b0;
			btn_out <= btn;
			sw_out <= sw;
		end
	end else
		if (btn > 0 || sw > 0)
			counter <= counter + 1;
end
endmodule
