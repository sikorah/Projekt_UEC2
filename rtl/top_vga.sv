module top_vga (
    input  logic clk_40,
    input  logic clk_100,
    inout  logic ps2_clk,
    inout  logic ps2_data,
    input  logic rst,
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b
);

/**
 * Local variables and signals
 */
vga_if vga_tim();
vga_if vga_bg();
vga_if vga_rect();
vga_if vga_buttons();

logic [11:0] xpos, ypos;
logic button_pressed;

wire [11:0] rom2rect_pixel;
wire [13:0] rect2rom_address;

/**
 * Signals assignments
 */
assign vs = vga_bg.vsync;
assign hs = vga_bg.hsync;
assign {r, g, b} = vga_rect.rgb;  // Extract higher bits for RGB

/**
 * Submodules instances
 */

vga_timing u_vga_timing (
    .clk(clk_40),
    .rst(rst),
    .vga_out(vga_tim)
);

draw_bg u_draw_bg (
    .clk(clk_40),
    .rst(rst),
    .vga_in(vga_tim),
    .vga_out(vga_bg)
);

draw_buttons u_draw_buttons (
    .clk(clk_40),
    .rst(rst),
    .vga_in(vga_bg),
    .vga_out(vga_buttons),
    .player_xpos(xpos),
    .player_ypos(ypos),
    .button_pressed(button_pressed)
);

draw_rect u_draw_rect (
    .clk(clk_40),
    .rst(rst),
    .vga_in(vga_buttons),
    .vga_out(vga_rect),
    .xpos(xpos),
    .ypos(ypos),
    .rgb_address(rect2rom_address),
    .rgb_pixel(rom2rect_pixel)
);

draw_rect_ctl u_draw_rect_ctl (
    .clk(clk_40),
    .rst(rst),
    .v_tick(vga_bg.vsync),
    .xpos(xpos),
    .ypos(ypos),
    .button_pressed(button_pressed),
    .rgb_pixel(rom2rect_pixel),
    .rgb_address(rect2rom_address)
);

image_rom u_image_rom (
    .clk(clk_40),
    .address(rect2rom_address),
    .rgb(rom2rect_pixel)
);

/*keyboard u_keyboard (
    .clk(clk_100),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data)
);*/


ps2_keyboard u_ps2_keyboard(
	.clk(clk_100),
	.rst,
	.ps2_clk, 
	.ps2_data,
    .ps2_code,
    .ps2_code_new
);

debounce u_debounce(
    .clk(clk_100),
    .rst,
    .button,
    .result
);

draw_player u_draw_player (
    .clk(clk_40),
    .rst(rst),
    .vga_in(vga_buttons),
    .vga_out(vga_rect),
    .xpos(xpos),
    .ypos(ypos),
    .state(state)  // Przekazujemy stan do rysowania postaci
);

draw_player_ctl u_draw_player_ctl (
    .clk(clk_40),
    .rst(rst),
    .v_tick(vga_bg.vsync),  // Use vsync as the vertical tick
    .a_pressed(a_pressed),
    .d_pressed(d_pressed),
    .xpos(xpos),
    .ypos(ypos),
    .state(state), // Odbieramy stan z kontrolera
    .result  
);




endmodule
