`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:42:08 08/21/2014 
// Design Name: 
// Module Name:    sw_btn_dev_io 
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
module sw_btn_dev_io(counter0_out, counter1_out, counter2_out, led_out, btn, sw, cpu_data4bus);
input		counter0_out, counter1_out, counter2_out;
input		[3:0]		btn;
input		[7:0]		sw, led_out;
output	[31:0]	cpu_data4bus = {counter0_out, counter1_out, counter2_out, 9'h0, led_out, btn, sw};

endmodule
