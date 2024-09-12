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
     input  logic clk_65,
     input  logic clk_100,
     inout  logic ps2_clk,
     inout  logic ps2_data,
     input  logic gpio_left_input,
     input  logic gpio_right_input,
     output logic gpio_left_output,
     output logic gpio_right_output,
     input  logic rst,
     output logic vs,
     output logic hs,
     output logic [3:0] r,
     output logic [3:0] g,
     output logic [3:0] b
 );
 
 vga_if vga_tim();
 vga_if start();
 vga_if vga_out();
 
 wire m_left, m_right;
 wire [11:0] xpos_rect_ctl, ypos_rect_ctl;
 wire [11:0] xpos_player_ctl1, xpos_player_ctl2;
 wire [1:0] button_pressed;

 g_state game_state;
 State1 state1;
 State2 state2;
 
 
 assign vs = vga_out.vsync;
 assign hs = vga_out.hsync;
 assign {r, g, b} = vga_out.rgb; 
 
 vga_timing u_vga_timing (
     .clk(clk_65),
     .rst(rst),
     .vga_out(vga_tim)
 );
 
 MouseCtl u_mouse_ctl(
     .clk(clk_100),
     .rst(rst),
     .setmax_x(1'b0),
     .setmax_y(1'b0),
     .ps2_clk(ps2_clk), 
     .ps2_data(ps2_data),
     .left(m_left),
     .right(m_right),
     .new_event(),
     .value('0)
 );
 
 mouse_to_gpio u_mouse_to_gpio(
     .clk(clk_65),
     .rst(rst),
     .m_left(m_left),
     .m_right(m_right),
     .gpio_left_output(gpio_left_output),
     .gpio_right_output(gpio_right_output)
 
 );
 
 state_control u_state_control(
     .clk(clk_65),
     .rst(rst),
     .m_left(m_left),
     .m_right(m_right),
     .gpio(gpio_left_input),
     .xpos_player1(xpos_player_ctl1),
     .xpos_player2(xpos_player_ctl2),
     .game_state
 );

 

 draw_player_ctl1 u_draw_player_ctl1 (
     .clk(clk_65),
     .rst(rst),
     .v_tick(vga_tim.vsync),
     .m_left(m_left),
     .m_right(m_right),
     .xpos_player1(xpos_player_ctl1),
     .button_pressed(button_pressed),
     .state(state1)
 );

 draw_player_ctl2 u_draw_player_ctl2 (
    .clk(clk_65),
    .rst(rst),
    .v_tick(vga_tim.vsync),
    .gpio_left(gpio_left_input),
    .gpio_right(gpio_right_input),
    .xpos_player2(xpos_player_ctl2),
    .button_pressed(button_pressed),
    .state(state2)
);

 draw_rect_ctl u_draw_rect_ctl (
    .clk(clk_65),
    .rst(rst),
    .v_tick(vga_tim.vsync),
    .xpos_rect(xpos_rect_ctl),  
    .ypos_rect(ypos_rect_ctl),  
    .button_pressed(button_pressed),
    .xpos_player1(xpos_player_ctl1),
    .xpos_player2(xpos_player_ctl2)
);
 
 
 start_game u_start_game(
     .clk(clk_65),
     .rst(rst),
     .game_state,
     .state1,
     .state2,
     .xpos_rect_ctl,
     .ypos_rect_ctl,
     .xpos_player_ctl1,
     .xpos_player_ctl2,
     .vga_in(vga_tim),
     .vga_out(vga_out)
 );
 
 
 endmodule