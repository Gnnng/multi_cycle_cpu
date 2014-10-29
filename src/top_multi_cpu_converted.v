`timescale 1ns / 1ps
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
module top_multi_cpu_converted(
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

wire		[31:0]	clkdiv;
wire					clkcpu, clk_mem, clk_vga, clk_io;

wire		[31:0]	pc, inst, cpu_addr;
wire		[4:0]		state;

wire					mio_ready;
wire					cpu_mio;
wire				 	mem_w;
wire		[31:0]	cpu_data4bus, cpu_data2bus;

wire					data_ram_we;
wire		[10:0]	ram_addr;
wire		[31:0]	ram_data_in, ram_data_out;

wire					data_rom_we;
wire		[11:0]	rom_addr;
wire		[31:0]	rom_data_in, rom_data_out;

wire					vga_rdn;
wire		[10:0]	vram_out, vram_data_in;
wire		[12:0]	vram_addr, vga_addr;

wire		[31:0]	key_d;
wire		[7:0]		key, ps2_key;
wire					ps2_rd;

wire		[21:0]	GPIOf0;
wire		[31:0]	counter_out, peripheral_in;
wire					counter_out0, counter_out1, counter_out2;
wire		[1:0]		counter_set;
wire					GPIOffffff00_we, GPIOfffffe00_we, counter_we;


initial begin
	auto_reset = 1;
	reset_count = 0;
end

assign led = {led_out[7] | clkcpu, led_out[6:0]};

//assign clk_mem = ~clk;
assign clk_mem = clk; 				//modified

assign clk_io = ~clkcpu;

// reset signal, high active
//assign reset = btn_out[0] | auto_reset;
assign reset = btn[0] | auto_reset; // for simulation

always @(posedge clk) begin
	if (reset_count < 50)
		reset_count <= reset_count + 1;
	if (reset_count == 20)
		auto_reset <= 1;
	if (reset_count == 40)
		auto_reset <= 0;
end


multi_cycle_cpu U1(
	.clk(clkcpu),
	.reset(reset),
	.mio_ready(mio_ready),
	.pc_out(pc),		// test
	.inst(inst),			// test
	.mem_w(mem_w),
	.addr_out(cpu_addr),
	.data_out(cpu_data2bus),
	.data_in(cpu_data4bus),
	.cpu_mio(cpu_mio),
	.state(state)
);


//ram_block U2(						// real block

ram_block_temp U2_1(
	.clka(clk_mem),
	.wea(data_rom_we),
	.addra(rom_addr),
	.dina(rom_data_in),
	.douta(rom_data_out)
);

ram_block U2_2(					// fake block
	.clka(clk_mem),
	.wea(data_ram_we),
	.addra(ram_addr),
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

mio_bus U4(
	.clk(clk),
	.reset(reset),
//	.btn(btn_out[4:0]),
	.btn(btn[4:0]),						// for simulation
//	.sw(sw_out),
	.sw(sw),									// for simulation
	.cpu_wait(mio_ready),
	
	.addr_bus(cpu_addr),
	.cpu_data2bus(cpu_data2bus),
	.cpu_data4bus(cpu_data4bus),
	
	.mem_w(mem_w),
	
	.data_rom_we(data_rom_we),			
	.rom_addr(rom_addr),					
	.rom_data_in(rom_data_in),
	.rom_data_out(rom_data_out),		
	
	.data_ram_we(data_ram_we),			// data_ram_we
	.ram_addr(ram_addr),					
	.ram_data_in(ram_data_in),
	.ram_data_out(ram_data_out),		// ram data --> bus
	
	.vga_rdn(vga_rdn),					// vga_rdn
	.vga_addr(vga_addr),					// vga ctrl addr --> bus
	.vram_out(vram_out),					// vram data --> bus
	.vram_data_in(vram_data_in),		// bus data --> vram
	.vram_addr(vram_addr),				// bus addr --> vram
	.vram_we(vram_we),					// vram_we
	
	.peripheral_in(peripheral_in),
	.GPIOfffffe00_we(GPIOfffffe00_we),// 7seg we
	.GPIOffffff00_we(GPIOffffff00_we),// led we
	.led_out(led_out),					// led --> bus
	
	.counter_we(counter_we),
	.counter_out(counter_out),
	.counter0_out(counter_out0),
	.counter1_out(counter_out1),
	.counter2_out(counter_out2),
	
	.ps2_rd(ps2_rd),
	.ps2_ready(ps2_ready),
	.key(key),
	
	.JD(JD)
);

seven_seg_dev_io U5(
	.clk(clk_io),
	.reset(reset),
	.GPIOfffffe00_we(GPIOfffffe00_we),
//	.test_select(sw_out[7:5]),
	.test_select(sw[7:5]),			// for simulation
	.cpu_data(peripheral_in),
	.test_data0(pc),
	.test_data1(counter_out),
	.test_data2(inst),
	.test_data3(cpu_addr),
	.test_data4(key_d),
//	.test_data5({27'b0, state}),
	.test_data6(GPIOf0),
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


led_dev_io U7(
	.clk(clk_io), 
	.reset(reset), 
	.GPIOffffff00_we(GPIOffffff00_we), 
	.peripheral_in(peripheral_in), 
	.counter_set(counter_set), 
	.led_out(led_out),
	.GPIOf0(GPIOf0)
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
anti_jitter U9(clk, btn, sw, btn_out, sw_out);

counter_x U10(
	.clk(clk_io),
	.reset(reset),
	.clk0(clkdiv[9]),
	.clk1(clkdiv[10]),
	.clk2(clkdiv[10]),
	.counter_we(counter_we),
	.counter_val(peripheral_in),
	.counter_ch(counter_set),
	.counter0_out(counter_out0),
	.counter1_out(counter_out1),
	.counter2_out(counter_out2),
	.counter_out(counter_out)
);

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
	.GPIOf0(GPIOf0),
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
