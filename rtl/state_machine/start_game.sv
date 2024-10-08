/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Hubert Sikora
 *
 * Description:
 * Selecting state of the game
 */

 import vga_pkg::*;
 import state_pkg::*;

module start_game(
    input logic clk,
    input logic rst,
    input g_state game_state,
    input logic [11:0] xpos_rect_ctl, ypos_rect_ctl,
    input logic [11:0] xpos_player_ctl1, xpos_player_ctl2,
    input State1 state1,
    input State2 state2,

    vga_if.in vga_in,
    vga_if.out vga_out
);

vga_if game_menu();
vga_if lvl_start();
vga_if buttons();
vga_if rect();
vga_if player_1();
vga_if level_1();
vga_if out();
vga_if finish();

wire [11:0] rom2rect_pixel;
wire [13:0] rect2rom_address;

start_screen u_start_screen(
    .clk(clk),
    .rst(rst),
    .vga_in,
    .vga_out(game_menu)
);

level_1 u_level_1(
    .clk(clk),
    .rst(rst),
    .vga_in,
    .vga_out(lvl_start)
);

draw_buttons u_draw_buttons (
    .clk(clk),
    .rst(rst),
    .vga_in(lvl_start),
    .vga_out(buttons)
);

draw_rect u_draw_rect (
    .clk(clk),
    .rst(rst),
    .vga_in(buttons),
    .vga_out(rect),
    .xpos_rect(xpos_rect_ctl),
    .ypos_rect(ypos_rect_ctl),
    .rgb_address(rect2rom_address),
    .rgb_pixel(rom2rect_pixel)
);

image_rom u_image_rom (
    .clk(clk),
    .address(rect2rom_address),
    .rgb(rom2rect_pixel)
);

draw_player_2 u_draw_player_2(
    .clk(clk),
    .rst(rst),
    .vga_in(rect),
    .vga_out(player_1),
    .xpos_player2(xpos_player_ctl2),
    .state(state2)
);

draw_player_1 u_draw_player_1(
    .clk(clk),
    .rst(rst),
    .vga_in(player_1),
    .vga_out(level_1),
    .xpos_player1(xpos_player_ctl1),
    .state(state1)
);


finish_screen u_finish_screen(
    .clk(clk),
    .rst(rst),
    .vga_in,
    .vga_out(finish)
);

always_comb begin
    case(game_state)
        START: begin
            out.vcount = game_menu.vcount;
            out.vsync = game_menu.vsync;
            out.vblnk = game_menu.vblnk;
            out.hcount = game_menu.hcount;
            out.hsync  = game_menu.hsync;
            out.hblnk = game_menu.hblnk;
            out.rgb   = game_menu.rgb;
        end
        LEVEL_1: begin
            out.vcount = level_1.vcount;
            out.vsync = level_1.vsync;
            out.vblnk = level_1.vblnk;
            out.hcount = level_1.hcount;
            out.hsync  = level_1.hsync;
            out.hblnk = level_1.hblnk;
            out.rgb   = level_1.rgb;
        end
        FINISH: begin
            out.vcount = finish.vcount;
            out.vsync = finish.vsync;
            out.vblnk = finish.vblnk;
            out.hcount = finish.hcount;
            out.hsync  = finish.hsync;
            out.hblnk = finish.hblnk;
            out.rgb   = finish.rgb;
        end
        default: begin
            out.vcount = game_menu.vcount;
            out.vsync = game_menu.vsync;
            out.vblnk = game_menu.vblnk;
            out.hcount = game_menu.hcount;
            out.hsync  = game_menu.hsync;
            out.hblnk = game_menu.hblnk;
            out.rgb   = game_menu.rgb;
        end
    endcase
end

always_ff @(posedge clk) begin
    if(rst) begin
        vga_out.vcount <= '0;
        vga_out.vsync <= '0;
        vga_out.vblnk <= '0;
        vga_out.hcount <= '0;
        vga_out.hsync <= '0;
        vga_out.hblnk <= '0;
        vga_out.rgb <= '0;
    end
    else begin
        vga_out.vcount <= out.vcount;
        vga_out.vsync <= out.vsync;
        vga_out.vblnk <= out.vblnk;
        vga_out.hcount <= out.hcount;
        vga_out.hsync <= out.hsync;
        vga_out.hblnk <= out.hblnk;
        vga_out.rgb <= out.rgb;
    end
end

endmodule