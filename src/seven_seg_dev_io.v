`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:14:06 08/21/2014 
// Design Name: 
// Module Name:    seven_seg_dev_io 
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
module seven_seg_dev_io(clk, reset, GPIOfffffe00_we, test_select, cpu_data,
	test_data7, test_data1, test_data2, test_data3, test_data4,
	test_data5, test_data6, disp_num
    );
input					clk, reset, GPIOfffffe00_we;
input		[2:0]		test_select;
input		[31:0]	cpu_data, test_data7, test_data1, test_data2, test_data3, 
						test_data4, test_data5, test_data6;
output	[31:0]	disp_num;
reg		[31:0]	disp_num;

always @(negedge clk or posedge reset) begin
	if (reset)
		disp_num <= 32'h12345678;
	else begin
		case(test_select)
			0: begin
				if (GPIOfffffe00_we)										
					disp_num <= cpu_data;                         
				else
					disp_num <= disp_num;
				end
			1: disp_num <= {2'b00, test_data1[31:2]};				//PC
			2: disp_num <= test_data2;									//counter
			3: disp_num <= test_data3;									//inst
			4: disp_num <= test_data4;									//cpu_addr
			5: disp_num <= test_data5;									//cpu_data2bus
			6: disp_num <= test_data6;									//state
			7: disp_num <= test_data7;									//ps2
		endcase
	end
end

endmodule
