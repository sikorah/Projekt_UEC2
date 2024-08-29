/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Hubert Sikora
 *
 * Description:
 * Selecting state of the game
 */

module start_game(
    input logic clk_40,
    input logic rst,
    input g_state state_game,

    vga_if.in vga_in,
    vga_if.out vga_out
);

import vga_pkg::*;

vga_if game_menu();
vga_if level_1();
vga_if out();
vga_if finish();

start_screen u_start_screen(
    .clk(clk_40),
    .rst(rst),
    .vga_in,
    .vga_out(game_menu)
);

level_1 u_level_1(
    .clk(clk_40),
    .rst(rst),
    .vga_in,
    .vga_out(level_1)
);

finish_screen u_finish_screen(
    .clk(clk_40),
    .rst(rst),
    .vga_in,
    .vga_out(finish)
);

always_comb begin
    case(game_state)
        START: begin
            out.vcount <= game_menu.vcount;
            out.vsync <= game_menu.vsync;
            out.vblnk<= game_menu.vblnk;
            out.hcount <= game_menu.hcount;
            out.hsync  <= game_menu.hsync;
            out.hblnk <= game_menu.hblnk;
            out.rgb   <= game_menu.rgb;
        end
        LEVEL_1: begin
            out.vcount <= level_1.vcount;
            out.vsync <= level_1.vsync;
            out.vblnk<= level_1.vblnk;
            out.hcount <= level_1.hcount;
            out.hsync  <= level_1.hsync;
            out.hblnk <= level_1.hblnk;
            out.rgb   <= level_1.rgb;
        end
        FINISH: begin
            out.vcount <= level_1.vcount;
            out.vsync <= level_1.vsync;
            out.vblnk<= level_1.vblnk;
            out.hcount <= level_1.hcount;
            out.hsync  <= level_1.hsync;
            out.hblnk <= level_1.hblnk;
            out.rgb   <= level_1.rgb;
        end
    endcase
end

endmodule