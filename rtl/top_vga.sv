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

logic [11:0] xpos, ypos;
//logic [1:0] state;
//logic a_pressed, d_pressed;

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
    .rst,
    .vga_out(vga_tim)
);

draw_bg u_draw_bg (
    .clk(clk_40),
    .rst,
    .vga_in(vga_tim),
    .vga_out(vga_bg)
);

draw_rect u_draw_rect (
    .clk(clk_40),
    .rst,
    .vga_in(vga_bg),
    .vga_out(vga_rect),
    .xpos(xpos),
    .ypos(ypos)
);

draw_rect_ctl u_draw_rect_ctl (
    .clk(clk_40),
    .rst,
    .v_tick(vga_bg.vsync),
    .xpos(xpos),
    .ypos(ypos)
);

/*
draw_player u_draw_player (
    .clk(clk_40),
    .rst(rst),
    .vga_in(vga_bg),
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
    .state(state)  // Odbieramy stan z kontrolera
);

*/
endmodule

