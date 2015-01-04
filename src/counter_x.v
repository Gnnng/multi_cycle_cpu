`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:24:58 08/21/2014 
// Design Name: 
// Module Name:    counter_x 
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
module counter_x(clk, reset, clk0, clk1, clk2, counter_we, counter_val, counter_ch,
	counter0_out, counter1_out, counter2_out, counter_out);
input					clk, reset, clk0, clk1, clk2, counter_we;
input		[31:0]	counter_val;
input		[1:0]		counter_ch;
output				counter0_out, counter1_out, counter2_out;
output	[31:0]	counter_out;

reg		[31:0]	counter_out;
reg					counter0_out, counter1_out, counter2_out;
reg		[31:0]	counter0, counter1, counter2;
reg					c0_we;
reg					c0_ready;

//always @(posedge clk or posedge reset) begin
//	if (reset) begin
//		c0_we <= 0;
//		counter_out <= 0;
//	end if (counter_we) begin
//		case(counter_ch)
//			0: c0_we <= 1;
//		endcase
//	end
//	if (c0_ready)
//		c0_we <= 0;
//	case(counter_ch)
//		0: counter_out <= counter0;
////		1: counter_out <= counter1;
////		2: counter_out <= counter2;
//	endcase
//	counter0_out <= (counter0 == 0);
////	counter1_out <= (counter1 == 0);
////	counter2_out <= (counter2 == 0);
//end
//
//always @(posedge clk0 or posedge reset) begin
//	if (reset) begin
//		c0_ready <= 0;
//	end else if (c0_we) begin
//		counter0 <= counter_val;
//		c0_ready <= 1;
//	end else
//		counter0 <= counter0 - 1;
//end

//always @(posedge clk1 or posedge counter_we) begin
//	if (counter_ch == 1 && counter_we) begin
//		counter1 <= counter_val;
//	end else begin
//		counter1 <= counter1 - 1;
////		counter1_out <= (counter1 == 0);
//	end
//end
//
//always @(posedge clk2 or posedge counter_we) begin
//	if (counter_ch == 2 && counter_we) begin
//		counter2 <= counter_val;
//	end else begin
//		counter2 <= counter2 - 1;
////		counter2_out <= (counter2 == 0);
//	end
//end
//



endmodule
