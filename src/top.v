`timescale 1ns / 1ps
`include "../include/CONFIG_DEFINES.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:04:19 08/21/2014 
// Design Name: 
// Module Name:    top 
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
module top(
	clk, 
	//I/O
	sw, 
	btn, 
	led, 
	seg, an, 
	ps2_data, ps2_clk, 
	vgaRed, vgaGreen, vgaBlue, Hsync, Vsync,
	JD
	);
input					clk;
input		[4:0]		btn;
input		[7:0]		sw;
input					ps2_data, ps2_clk;
input	 	[7:0]		JD;

output	[2:0]		vgaRed, vgaGreen;
output	[2:1]		vgaBlue;
output				Hsync, Vsync;
output	[7:0]		led;
output	[7:0]		seg;
output	[3:0]		an;

wire					reset;
reg					auto_reset;
reg		[7:0]		reset_count;
wire		[7:0]		led_out;
wire		[7:0]		sw_out;
wire		[4:0]		btn_out;
wire		[31:0]	disp_num;

// clock
wire		[31:0]	clkdiv;
wire					clkcpu, clk_mem, clk_vga, clk_io;

// cpu
wire		[31:0]	pc, inst, cpu_addr;
wire		[4:0]		state;
wire					mem_w;
wire					cpu_wait;
// bus
wire					mio_ready;
reg		[31:0]	cpu_data4bus;
wire		[31:0]	cpu_data2bus;
wire		[31:0]	addr_bus;

// data ram
reg					ram_we;
reg		[31:0]	ram_data_in;
wire		[31:0]	ram_data_out;


// vram
reg					vram;
reg					ready;
reg					vram_write;
wire					vga_rdn, vram_we;
wire		[31:0]	vram_addr;
reg		[31:0]	cpu_vram_addr;
wire		[`VRAM_WIDTH - 1: 0] vram_out;
reg		[`VRAM_WIDTH - 1: 0]	vram_data_in;

// vga controller
wire		[31:0]	vga_addr;

// ps2
wire		[31:0]	key_d;
wire		[7:0]		key, ps2_key;
reg					ps2_rd;
wire					ps2_ready;

// int signal
wire 					INTsignal = ps2_ready;

// seven seg
reg		[31:0]	cpu2seven_seg;

initial begin
	auto_reset = 1;
	reset_count = 0;
end

assign led = {led_out[7] | clkcpu, led_out[6] | reset, led_out[5:0]};

assign clk_mem = clk; 				//modified

assign clk_io = ~clkcpu;

// reset signal, high active
//assign reset = btn_out[0] | auto_reset;
assign reset = btn[0] | auto_reset; // for simulation

always @(posedge clk) begin
	if (reset_count < 50)
		reset_count <= reset_count + 8'd1;
	if (reset_count == 20)
		auto_reset <= 1;
	if (reset_count == 40)
		auto_reset <= 0;
end

// bus
assign addr_bus = cpu_addr;
assign cpu_wait = vram ? vga_rdn & ready : 1'b1;

always @(posedge clk or posedge reset) begin
	if (reset)
		ready <= 1;
	else
		ready <= vga_rdn;
end

assign vram_we = vga_rdn && vram_write;
assign vram_addr = vga_rdn ? cpu_vram_addr[12:2] : vga_addr[12:2];
//assign vram_addr = vga_addr[12:2];

always @* begin
	cpu_data4bus = 0;

	ram_we = 0;
	ram_data_in = 0;

	vram = 0;
	vram_write = 0;

	cpu_vram_addr = 0;
	
	ps2_rd = 0;
	
	case(addr_bus[31:16])
		16'h0000: begin
			ram_we = mem_w;			// mem_w = 0: read,  mem_w = 1: write
			ram_data_in = cpu_data2bus;
			cpu_data4bus = ram_data_out;
		end
		16'h1000: begin
			vram_write = mem_w;
			vram = 1;
			cpu_vram_addr = addr_bus[12:0];
			vram_data_in = cpu_data2bus[`VRAM_WIDTH - 1:0];
			cpu_data4bus = vga_rdn ? {13'h0, vram_out[`VRAM_WIDTH - 1:0]} : 32'hx;
		end
		16'hffff: begin
			case(addr_bus[15:8])
			8'h00: begin 
				//TODO: VGA io interface
			end
			8'h01: begin
				ps2_rd = ~mem_w;
				cpu_data4bus = {ps2_ready, 23'h0, key};
			end
			8'h02: begin
				cpu_data4bus = cpu2seven_seg;
				cpu2seven_seg = cpu_data2bus;
			end
			default: begin
				cpu_data4bus = 32'he1f1e1f1;
			end
			endcase
		end
	endcase
//	if (addr_bus < 32'h1000_0000) begin
//		ram_we = mem_w;			// mem_w = 0: read,  mem_w = 1: write
//		ram_data_in = cpu_data2bus;
//		cpu_data4bus = ram_data_out;
//	end else if (addr_bus < 32'hffff_0000) begin
//		vram_write = mem_w;
//		vram = 1;
//		cpu_vram_addr = addr_bus[12:0];
//		vram_data_in = cpu_data2bus[18:0];
//		cpu_data4bus = vga_rdn ? {13'h0, vram_out[18:0]} : 32'hx;
//	end// else if (addr_bus[31:16] == 16'hffff) begin
//
//	//end
	
//		24'hffffdx: begin						// ps2: 
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
end

multi_cycle_cpu U1(
	.clk(clkcpu),
	.reset(reset),
	.mio_ready(cpu_wait),
	.pc_out(pc),		// test
	.inst(inst),			// test
	.mem_w(mem_w),
	.addr_out(cpu_addr),
	.data_out(cpu_data2bus),
	.data_in(cpu_data4bus),
	.state(state),
	.INTsignal(INTsignal)
);

ram U2(
	.clka(clk_mem),
	.wea(ram_we),
	.addra(addr_bus),
	.dina(ram_data_in),
	.douta(ram_data_out)
);

vram_block U3(
	.clka(clk_mem),
	.wea(vram_we),
	.addra(vram_addr),
	.dina(vram_data_in),
	.douta(vram_out)
);

seven_seg_dev_io U5(
	.clk(clk_io),
	.reset(reset),
	.GPIOfffffe00_we(GPIOfffffe00_we),
	.test_select(sw[7:5]),			// for simulation
	.cpu_data(cpu2seven_seg),
	.test_data1(pc),
	.test_data2(32'h22222222),		// TODO
	.test_data3(inst),
	.test_data4(cpu_addr),
	.test_data5(key_d),
	.test_data6({27'b0, state}),
	.test_data7(32'h77777777),				// TODO
	.disp_num(disp_num)
);

// segment display
seven_seg_dev U6(
	.display_code(disp_num),
	//.sw(sw_out[1:0]), 
	.sw(sw[1:0]),							// for simulation
	.scanning(clkdiv[19:18]), 
	.seg(seg), 
	.an(an)
);

// clock divider
clk_div U8(
	.clk(clk), 
	.reset(reset), 
	//.speed_select(sw[2]), 
	.speed_select(sw[2]),   // for simulation
	.clkdiv(clkdiv), 
	.clkcpu(clkcpu)
);


// anti button jitter
//anti_jitter U9(clk, btn, sw, btn_out, sw_out);

BUFG VGA_CLOCK_BUF(.O(clk_vga), .I(clkdiv[1]));

vga_dev_io U11(
	.clk(clk_vga),
	.reset(reset),
	.rgb_out({vgaRed[2:0], vgaGreen[2:0], vgaBlue[2:1]}),
	.vga_addr(vga_addr),
	.vram_out(vram_out),
	.hsync(Hsync),
	.vsync(Vsync),
	.vga_rdn(vga_rdn),
	.blink_clk(clkdiv[25])
);

ps2_dev_io U12(
	.clk_io(clk_io),
	.clk_ps2(clkdiv[1]), 
	.reset(reset), 
	.ps2_clk(ps2_clk), 
	.ps2_data(ps2_data),
	.ps2_rd(ps2_rd),
	.key(key),
	.ps2_ready(ps2_ready),
	.key_d(key_d)
);

endmodule
