`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:23:05 08/21/2014 
// Design Name: 
// Module Name:    led_dev_io 
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
module led_dev_io(clk, reset, GPIOffffff00_we, peripheral_in, counter_set, led_out, GPIOf0);
input					clk, reset, GPIOffffff00_we;
input		[31:0]	peripheral_in;
output	[1:0]		counter_set;
output	[7:0]		led_out;
output	[21:0]	GPIOf0;

wire		[7:0]		led_out;
reg		[1:0]		counter_set;
reg		[7:0]		led;
reg		[21:0]	GPIOf0;

assign led_out = led;
always @(negedge clk or posedge reset) begin
	if (reset) begin
		led <= 8'h00;
		counter_set <= 2'b00;
	end else begin
		if (GPIOffffff00_we)
			//{GPIOf0[21:0], led, counter_set} <= peripheral_in;
			{led, counter_set, GPIOf0[21:0]} <= peripheral_in;
		else begin
			led <= led;
			counter_set <= counter_set;
		end
	end
end
endmodule
