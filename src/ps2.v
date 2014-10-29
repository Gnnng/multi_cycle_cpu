`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:02:41 08/22/2014 
// Design Name: 
// Module Name:    ps2 
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
module ps2(clk, reset, ps2_clk, ps2_data, rdn, data, ready, overflow);
input					clk, ps2_clk, ps2_data, rdn, reset;
output	[7:0]		data;
output				ready;
output				overflow;

reg		[9:0]		buffer;
reg		[7:0]		queue[7:0];
reg		[3:0]		count;
reg		[2:0]		head, tail;
reg		[1:0]		negedge_detect;
reg					overflow;
wire					sampling;


// for simulation
initial begin
//	head <= 3;
//	tail <= 0;
//	queue[0] <= 8'h1c;
//	queue[1] <= 8'hf0;
//	queue[2] <= 8'h1c;
end

always @(posedge clk) begin
	negedge_detect <= {negedge_detect[0], ps2_clk};
end

assign sampling = negedge_detect[1] & (~negedge_detect[0]);

always @(posedge clk) begin
	if (reset) begin
		count <= 0;
		head <= 0;
		tail <= 0;
		overflow <= 0;
	end else if (sampling) begin
		if (count == 10) begin
			if (buffer[0] == 0 && ps2_data && (^buffer[9:1])) begin
				if (head + 3'b1 != tail) begin
					queue[head] <= buffer[8:1];
					head <= head + 3'b1;
				end else begin
					overflow <= 1;
				end
			end
			count <= 0;
		end else begin
			buffer[count] <= ps2_data;
			count <= count + 4'b1;
		end
	end
	if (!rdn && ready) begin
		tail <= tail + 3'b1;
		overflow <= 0;
	end	
end

assign ready = (head != tail);
assign data = queue[tail];

endmodule
