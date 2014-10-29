`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:06:39 08/21/2014 
// Design Name: 
// Module Name:    seven_seg_dev 
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
module seven_seg_dev(display_code, sw, scanning, seg, an);
input 	[31:0] 	display_code;
input 	[1:0]		sw;
input		[1:0]		scanning;
output	[7:0]		seg;
output	[3:0]		an;

reg	[3:0]		an;
reg	[3:0]		digit;
reg	[7:0]		digit_seg, image_seg;
wire	[15:0]	display;

assign seg = sw[0] ? digit_seg : image_seg;
assign display = sw[1] ? display_code[31:16] : display_code[15:0];

always @(*) begin
	case(scanning)
		0:	begin
			an = 4'b1110;
			digit = display[3:0];
			image_seg = {display_code[24], display_code[0], display_code[4], display_code[16],
							display_code[25], display_code[17], display_code[5], display_code[12]};
			end
		1:	begin
			an = 4'b1101;
			digit = display[7:4];
			image_seg = {display_code[26], display_code[1], display_code[6], display_code[18],
							display_code[27], display_code[19], display_code[7], display_code[13]};
			end
		2:	begin
			an = 4'b1011;
			digit = display[11:8];
			image_seg = {display_code[28], display_code[2], display_code[8], display_code[20],
							display_code[29], display_code[21], display_code[9], display_code[14]};
			end
		3:	begin
			an = 4'b0111;
			digit = display[15:12];
			image_seg = {display_code[30], display_code[3], display_code[10], display_code[22],
							display_code[31], display_code[23], display_code[11], display_code[15]};
			end
	endcase
	case(digit)
		4'b0000 : digit_seg <= 8'b11000000;		// 0
		4'b0001 : digit_seg <= 8'b11111001;		// 1
		4'b0010 : digit_seg <= 8'b10100100;		// 2
		4'b0011 : digit_seg <= 8'b10110000;		// 3
		4'b0100 : digit_seg <= 8'b10011001;		// 4
		4'b0101 : digit_seg <= 8'b10010010;		// 5
		4'b0110 : digit_seg <= 8'b10000010;		// 6
		4'b0111 : digit_seg <= 8'b11111000;		// 7
		4'b1000 : digit_seg <= 8'b10000000;		// 8
		4'b1001 : digit_seg <= 8'b10010000;		// 9
		4'b1010 : digit_seg <= 8'b10001000;		// A
		4'b1011 : digit_seg <= 8'b10000011;		// b
		4'b1100 : digit_seg <= 8'b11000110;		// C
		4'b1101 : digit_seg <= 8'b10100001;		// d
		4'b1110 : digit_seg <= 8'b10000110;		// E
		4'b1111 : digit_seg <= 8'b10001110;		// F
		default : digit_seg <= 8'b11111111;
	endcase
end

endmodule
