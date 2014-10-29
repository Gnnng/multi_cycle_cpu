`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    21:23:00 08/27/2014
// Design Name:
// Module Name:    vga_dev_io
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
module vga_dev_io(clk, reset, rgb_out, hsync, vsync, vga_rdn, vram_out, vga_addr, GPIOf0, blink_clk);
input					clk;
input					reset;
input		[10:0]	vram_out;
input		[21:0]	GPIOf0;
input				blink_clk;

output	[12:0]	vga_addr;
output	[7:0]		rgb_out;
output				vga_rdn;
output				hsync, vsync;

wire		[10:0]	x,y;
wire					blank;
wire		[2:0]		char_x, char_y;
wire		[7:0]		char_index;
wire		[6:0]		col;
wire		[5:0]		row;
wire		[7:0]		rgb_data, rgb_text, rgb_image;
wire		[2:0]		rgb_in;

reg		[7:0]		rgb_out;

assign char_x = x[2:0];
assign char_y = y[2:0];
assign col = x[9:3];
assign row = y[8:3];
assign blink = (col == GPIOf0[6:0]) & (row == GPIOf0[13:8]);
assign char_index = vram_out[7:0];
assign rgb_in = vram_out[10:8];

assign vga_addr = {row[5:0], col[6:0]};
assign rgb_text = (blink & ~GPIOf0[16]) ? {8{blink_clk}} : rgb_data;
assign rgb_image = vram_out[7:0];

//assign rgb_out = blank ? 8'b0 : rgb_data;
assign vga_rdn = blank;

always @(posedge clk or posedge reset) begin
	if (reset)
		rgb_out <= 8'b0;
	else if (blank)
		rgb_out <= 8'b0;
	else
		rgb_out <= (GPIOf0[17] ? rgb_image : rgb_text);
end

vga_core U11(
.pixel_clock(clk),
.reset(reset),
.hsync(hsync),
.vsync(vsync),
.blank(blank),
.x(x),
.y(y)
);

vga_fonts fonts_table(
.char_x(char_x),
.char_y(char_y),
.char_index(char_index),
.rgb_in(rgb_in),
.rgb_data(rgb_data)
); 

endmodule

module vga_fonts(char_x, char_y, char_index, rgb_data, rgb_in);
input		[2:0]		char_x, char_y;
input		[7:0]		char_index;
input		[2:0]		rgb_in;

output	[7:0]		rgb_data;

wire		[2:0]		rgb_in;
reg		[0:7]		fonts[0:1023];
wire		[0:7]		char_row;
wire					char_pixel;
wire		[7:0]		char_rgb;
initial begin
	$readmemh("./coe/font.rom", fonts);
end

assign char_row = fonts[{char_index[6:0], char_y[2:0]}];
assign char_pixel = char_row[char_x[2:0]];
assign char_rgb = {rgb_in[2], rgb_in[2], rgb_in[2], rgb_in[1], rgb_in[1], rgb_in[1], rgb_in[0], rgb_in[0]};
//assign char_rgb = {rgb_in[2], 2'b00, rgb_in[1], 2'b00, rgb_in[1], 1'b0};

assign rgb_data[7:0] = char_pixel ? char_rgb : 8'h00;
//assign rgb_data[7:0] = {char_index[4:0], rgb_in[2:0]};

endmodule
