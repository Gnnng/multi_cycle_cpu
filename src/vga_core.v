`timescale 1ns / 1ps
`include "../include/SVGA_DEFINES.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:01:30 08/22/2014 
// Design Name: 
// Module Name:    vga_core 
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
module vga_core(pixel_clock, reset, x, y, hsync, vsync, blank);
input						pixel_clock;
input						reset;

output					hsync, vsync;
output	[10:0]		x, y;
output					blank;

reg						hsync, vsync;
//wire signed	[10:0]		x_raw, y_raw;
reg		[10:0]		pixel_count, line_count;
reg						blank_v, blank_h, blank;
reg		[10:0]		x, y;

always @(posedge pixel_clock or posedge reset) begin
	if (reset) begin
		pixel_count <= 11'd0;
	end else begin
		if (pixel_count == `H_TOTAL - 1)
			pixel_count <= 11'd0;
		else
			pixel_count <= pixel_count + 11'd1;
	end
end

always @(posedge pixel_clock or posedge reset) begin
	if (reset) begin
		line_count <= 11'd0;
	end else begin
		if (pixel_count == `H_TOTAL - 1)
			if (line_count == `V_TOTAL - 1)
				line_count <= 11'd0;
			else
				line_count <= line_count + 11'd1;
	end
end

always @(posedge pixel_clock or posedge reset) begin
	if (reset) begin
		blank_h <= 1'b1;
	end else if (pixel_count == (`H_SYNCH + `H_BACK_PORCH - 2))
		blank_h <= 1'b0;
	else if (pixel_count == (`H_TOTAL - `H_FRONT_PORCH - 2))
		blank_h <= 1'b1;
end

always @(posedge pixel_clock or posedge reset) begin
	if (reset) begin
		blank_v <= 1'b1;
	end else if (line_count == (`V_SYNCH + `V_BACK_PORCH - 2))
		blank_v <= 1'b0;
	else if(line_count == (`V_TOTAL - `V_FRONT_PORCH - 2))
		blank_v <= 1'b1;
end

always @(posedge pixel_clock or posedge reset) begin
	if (reset) begin
		blank <= 1'b1;
	end else if (blank_v || blank_h) begin
		blank <= 1'b1;
	end else
		blank <= 1'b0;
end

always @(posedge pixel_clock or posedge reset) begin
	if (reset) begin
		hsync <= 1'b0;
	end else if (pixel_count == `H_SYNCH - 1)
		hsync <= 1'b1;
	else if (pixel_count == `H_TOTAL - 1)
		hsync <= 1'b0;
end

always @(posedge pixel_clock or posedge reset) begin
	if (reset) begin
		vsync <= 1'b0;
	end else if (line_count == `V_SYNCH - 1)
		vsync <= 1'b1;
	else if (line_count == `V_TOTAL - 1)
		vsync <= 1'b0;
end

always @(posedge pixel_clock or posedge reset) begin
	if (reset) begin
		x <= 0;
	end else if (pixel_count >= (`H_SYNCH + `H_BACK_PORCH - 1) && pixel_count < (`H_SYNCH + `H_BACK_PORCH + `H_ACTIVE - 1))
		x <= pixel_count - (`H_SYNCH + `H_BACK_PORCH - 1);
	else
		x <= 0;
end

always @(posedge pixel_clock or posedge reset) begin
	if (reset) begin
		y <= 0;
	end else if (line_count >= (`V_SYNCH + `V_BACK_PORCH - 1) && line_count < (`V_SYNCH + `V_BACK_PORCH + `V_ACTIVE - 1))
		y <= line_count - (`V_SYNCH + `V_BACK_PORCH - 1);
	else
		y <= 0;
end
//
//assign x_raw = pixel_count - (`H_SYNCH + `H_BACK_PORCH);
//assign y_raw = line_count - (`V_SYNCH + `V_BACK_PORCH);
//assign x = (x_raw >= 0 && x_raw < `H_ACTIVE) ? x_raw : 0;
//assign y = (y_raw >= 0 && y_raw < `V_ACTIVE) ? y_raw : 0;
//
//assign hsync = (pixel_count >= `H_SYNCH) ? 1'b1 : 1'b0;
//assign vsync = (line_count >= `V_SYNCH) ? 1'b1 : 1'b0;

//assign blank = (pixel_count < `H_SYNCH + `H_BACK_PORCH || pixel_count >= `H_TOTAL - `H_FRONT_PORCH - 1) ||
//					(line_count < `V_SYNCH + `V_BACK_PORCH || line_count >= `V_TOTAL - `V_FRONT_PORCH - 1);

endmodule
