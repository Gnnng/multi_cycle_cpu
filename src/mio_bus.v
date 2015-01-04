`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:25:23 08/21/2014 
// Design Name: 
// Module Name:    mio_bus 
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

module mio_bus(
	clk,
	reset,
	btn,
	sw,
	vga_rdn,
	ps2_ready,
	mem_w,
	key,
	cpu_data2bus,
	addr_bus,
	vga_addr,
	ram_data_out,
	vram_out,
	led_out,
	counter_out,
	counter0_out,
	counter1_out,
	counter2_out,
	cpu_wait,
	cpu_data4bus,
	ram_data_in,
	ram_addr,
	vram_data_in,
	vram_addr,
	data_ram_we,
	vram_we,
	GPIOffffff00_we,
	GPIOfffffe00_we,
	counter_we,
	ps2_rd,
	peripheral_in,
	data_rom_we,
	rom_addr,
	rom_data_in,
	rom_data_out,
	JD
);

input					clk, reset;
input		[4:0]		btn;
input					ps2_ready, mem_w, vga_rdn;
input					counter0_out, counter1_out, counter2_out;

input		[7:0]		sw, led_out, key;
input		[31:0]	cpu_data2bus, ram_data_out, addr_bus, counter_out;
input		[18:0]	vram_out;
input		[12:0]	vga_addr;
input		[31:0]	rom_data_out;
input 	[7:0]		JD;

output				data_rom_we;
output	[11:0]	rom_addr;
output	[31:0]	rom_data_in;
output				cpu_wait, data_ram_we, vram_we, GPIOffffff00_we, GPIOfffffe00_we, counter_we, ps2_rd;
output	[31:0]	cpu_data4bus, ram_data_in, peripheral_in;
output	[10:0]	ram_addr;
output	[10:0]	vram_addr;
output	[18:0]	vram_data_in;


wire		[31:0]	counter_out;
reg					data_ram_we;
reg					vram_write, vram;
reg					counter_we = 0;
reg					GPIOffffff00_we, GPIOfffffe00_we;
reg					ps2_rd, ready;
reg		[10:0]	ram_addr;
reg		[10:0]	cpu_vram_addr;
reg		[31:0]	ram_data_in;
reg		[18:0]	vram_data_in;
reg		[31:0]	peripheral_in;
reg		[31:0]	cpu_data4bus;
reg		[11:0]	rom_addr;
reg		[31:0]	rom_data_in;
reg					data_rom_we;

assign cpu_wait = vram ? vga_rdn & ready : 1'b1;
always @(posedge clk or posedge reset)
	if (reset)
		ready <= 1;
	else
		ready <= vga_rdn;

assign vram_we = vga_rdn && vram_write;
assign vram_addr = ~vga_rdn ? vga_addr : cpu_vram_addr;

always @* begin
	vram = 0;
	data_ram_we = 0;
	vram_write = 0;
	counter_we = 0;
	GPIOffffff00_we = 0;
	GPIOfffffe00_we = 0;
	ps2_rd = 0;
	ram_addr = 0;
	cpu_vram_addr = 0;
	ram_data_in = 0;
	vram_data_in = 0;
	peripheral_in = 0;
	cpu_data4bus = 0;
	data_rom_we = 0;
	rom_data_in = 0;
	rom_addr = 0;
	casex(addr_bus[31:8])
		24'h0000xx: begin						// data ram: 00000000 ~ 0000ffff(00000ffc)
			if (addr_bus[15:2] < 14'h1000) begin
				data_rom_we = mem_w;
				rom_addr = addr_bus[13:2];
				rom_data_in = cpu_data2bus;
				cpu_data4bus = rom_data_out;
			end else begin
				data_ram_we = mem_w;				// mem_w = 0: read,  mem_w = 1: write
				ram_addr = addr_bus[14:2] - 13'h1000;		// 12 - 2 + 1 words = 2k words =  8KB
				ram_data_in = cpu_data2bus;
				cpu_data4bus = ram_data_out;
			end
		end 
		
		24'h100cxx: begin						// vram: 100c0000 ~ 100cffff
			vram_write = mem_w;
			vram = 1;
			cpu_vram_addr = addr_bus[12:2];//  row_addr = addr_bus[14:9], col_addr = addr_bus[8:2]
			vram_data_in = cpu_data2bus[18:0];	// content in lower 11 bit
			cpu_data4bus = vga_rdn ? {13'h0, vram_out[18:0]} : 32'hx;
		end
		
//		24'hffffdx: begin						// ps2: ffffd000 ~ ffffdfff
//			ps2_rd = ~mem_w;
//			peripheral_in = cpu_data2bus;
//			cpu_data4bus = {ps2_ready, 23'h0, key};
//		end
//		
//		24'hfffffe: begin						// 7 segement led: fffffe00 ~ fffffeff
//			GPIOfffffe00_we = mem_w;
//			peripheral_in = cpu_data2bus;
//			cpu_data4bus = counter_out;		
//		end
//		24'hffffff: begin						// LED: 		ffffff00 ~ fffffff0
//													// counter:	ffffff04 ~ fffffff4
//			if (addr_bus[2]) begin			// ffffff04  for addr of counter
//				counter_we = mem_w;
//				peripheral_in = cpu_data2bus;	// write counter value
//				cpu_data4bus = counter_out;	// read from counter
//			end else begin						// ffffff00
//				GPIOffffff00_we = mem_w;	  
//				peripheral_in = cpu_data2bus;// write counter set && init and ligt led
//				cpu_data4bus = {counter0_out, counter1_out, counter2_out, led_out, btn, JD, sw};
//			end
//		end
	endcase
end

endmodule

