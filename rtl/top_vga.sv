/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab, Hubert Sikora
 *
 * Description:
 * top module of the game
 */

import state_pkg::*;

module top_vga (
    input  logic clk_40,
    input  logic clk_100,
    inout  logic ps2_clk,
    inout  logic ps2_data,
    inout  logic [11:0] xpos, ypos,
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
vga_if vga_mouse();
vga_if vga_out();

logic [11:0] xpos_mouse, ypos_mouse;
logic [11:0] xpos_rect_ctl, ypos_rect_ctl;
logic [11:0] xpos_player_ctl, ypos_player_ctl;
logic  button_pressed;

wire m_left, m_right;
wire [11:0] rom2rect_pixel;
wire [13:0] rect2rom_address;

g_state game_state;
State state;

/**
 * Signals assignments
 */
assign vs = vga_out.vsync;
assign hs = vga_out.hsync;
assign {r, g, b} = vga_out.rgb;  // Extract higher bits for RGB

/**
 * Submodules instances
 */

vga_timing u_vga_timing (
    .clk(clk_40),
    .rst(rst),
    .vga_out(vga_tim)
);

MouseCtl u_mouse_ctl(
    .clk(clk_100),
    .rst(rst),
    .xpos(xpos_mouse),
    .ypos(ypos_mouse),
    .setmax_x(1'b0),
    .setmax_y(1'b0),
    .ps2_clk(ps2_clk), 
    .ps2_data(ps2_data),
    .left(m_left),
    .right(m_right),
    .zpos(),
    .middle(),
    .new_event(),
    .value('0),
    .setx('0),
    .sety('0)
);

start_game u_start_game(
    .clk_40(clk_40),
    .rst(rst),
    .game_state,
    .state,
    .xpos,
    .ypos,
    .vga_in(vga_tim),
    .vga_out(vga_mouse)
);

draw_mouse  u_draw_mouse(
    .clk(clk_40),
    .rst,
    .vga_in(vga_mouse),
    .vga_out(vga_out),
    .xpos(x_pos),
    .ypos(y_pos)
);

state_control u_state_control(
    .clk_40(clk_40),
    .rst(rst),
    .xpos_mouse(xpos_mouse),
    .ypos_mouse(ypos_mouse),
    .m_left(m_left),
    .ypos_player(ypos_player),
    .game_state
);

image_rom u_image_rom (
    .clk(clk_40),
    .address(rect2rom_address),
    .rgb(rom2rect_pixel)
);

draw_rect_ctl u_draw_rect_ctl (
    .clk(clk_40),
    .rst(rst),
    .v_tick(vga_tim.vsync),
    .xpos_rect(xpos_rect_ctl),  
    .ypos_rect(ypos_rect_ctl),  
    .button_pressed(button_pressed)
);



draw_player_ctl u_draw_player_ctl (
    .clk(clk_40),
    .rst(rst),
    .v_tick(vga_tim.vsync),
    .m_left(m_left),
    .m_right(m_right),
    .xpos_player(xpos_player_ctl),
    .ypos_player(ypos_player_ctl),
    .button_pressed(button_pressed),
    .state

);

endmodule
