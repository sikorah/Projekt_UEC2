/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * The project top module.
 */

`timescale 1 ns / 1 ps

module top_vga (
    input  logic clk100, clk40,rst,
    output logic vs,hs,
    output logic [3:0] r,g,b,
    inout  logic ps2_clk, ps2_data
);


/**
 * Local variables and signals
 */
wire [11:0] rom2rect_pixel;
wire [11:0] rect2rom_adress;
wire [11:0] x_pos;
wire [11:0] y_pos;
wire [11:0] x_pos_ctl;
wire [11:0] y_pos_ctl;
wire m_left, m_right;

// VGA signals from timing
 vga_if timing2bg();
 vga_if bg2rect();
 vga_if rect2cursor();
 vga_if  vga_out();

/**
 * Signals assignments
 */

assign vs = vga_out.vsync;
assign hs = vga_out.hsync;
assign {r,g,b} = vga_out.rgb;


/**
 * Submodules instances
 */


vga_timing u_vga_timing (
    .clk(clk40),
    .rst,
    .out(timing2bg)
);


draw_bg u_draw_bg (
    .clk(clk40),
    .rst,
    .in(timing2bg),
    .out(bg2rect)
);

draw_rect u_draw_rect(
    .clk(clk40),
    .rst,
    .in(bg2rect),
    .out(rect2cursor),
    .xpos(x_pos_ctl),
    .ypos(y_pos_ctl),
    .rgb_pixel(rom2rect_pixel),
    .rgb_address(rect2rom_adress)
);

MouseCtl  u_mouse_ctl(
	.clk(clk100),
	.rst,
	.xpos(x_pos),
	.ypos(y_pos),
	.setmax_x(1'b0),
	.setmax_y(1'b0),
	.ps2_clk, 
	.ps2_data,
    .left(m_left),
    .right(m_right)
	);


draw_mouse  u_draw_mouse(
        .clk(clk40),
        .rst,
        .in(rect2cursor),
        .out(vga_out),
        .xpos(x_pos),
        .ypos(y_pos)
    );

image_rom u_image_rom(
    .clk(clk40),
    .address(rect2rom_adress),
    .rgb(rom2rect_pixel)
    );

draw_rect_ctl u_draw_rect_ctl
    (
        .rst,
        .v_tick(timing2bg.vblnk),
        .clk(clk40),
        .mouse_left(m_left),
        .mouse_xpos(x_pos),
        .mouse_ypos(y_pos),
        .xpos(x_pos_ctl),
        .ypos(y_pos_ctl)
    );

endmodule
 