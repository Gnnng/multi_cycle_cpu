`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:07:45 08/30/2014 
// Design Name: 
// Module Name:    ps2_dev_io 
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
module ps2_dev_io(clk_io, clk_ps2, reset, ps2_rd, key, key_d, ps2_clk, ps2_data, ps2_ready);
input					clk_ps2, reset, ps2_clk, ps2_data, ps2_rd, clk_io;
output	[31:0]	key_d;
output	[7:0]		key;
output				ps2_ready;

reg		[31:0]	key_d;
reg 					ps2_rdn;
wire 		[7:0]		ps2_key;
wire 					ps2_ready;
 
always @(posedge clk_io or posedge reset) begin
	if (reset) begin
		ps2_rdn <= 1;
		key_d <= 0;
	end else if (ps2_rd && ps2_ready) begin
		key_d <= {key_d[23:0], ps2_key};
		ps2_rdn <= ~ps2_rd | ~ps2_ready;
	end else
		ps2_rdn <= 1;
end;

assign key = (ps2_rd && ps2_ready) ? ps2_key : 8'haa;

ps2 U12(
.clk(clk_ps2),
.reset(reset),
.rdn(ps2_rdn),
.ps2_clk(ps2_clk),
.ps2_data(ps2_data),
.data(ps2_key),
.ready(ps2_ready),
.overflow(overflow)
);

endmodule
