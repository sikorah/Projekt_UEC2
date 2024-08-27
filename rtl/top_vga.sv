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
vga_if vga_buttons();
vga_if vga_rect();
vga_if vga_player();

logic [11:0] xpos_mouse, ypos_mouse;
logic [11:0] xpos_rect_ctl, ypos_rect_ctl;
logic [11:0] xpos_player_ctl, ypos_player_ctl;
logic button_pressed;
wire m_left, m_right;
wire [11:0] rom2rect_pixel;
wire [13:0] rect2rom_address;

/**
 * Signals assignments
 */
assign vs = vga_player.vsync;
assign hs = vga_player.hsync;
assign {r, g, b} = vga_player.rgb;  // Extract higher bits for RGB

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
    .xpos_player(xpos_player_ctl),
    .ypos_player(ypos_player_ctl),
    .button_pressed(button_pressed)
);

draw_rect u_draw_rect (
    .clk(clk_40),
    .rst(rst),
    .vga_in(vga_buttons),
    .vga_out(vga_rect),
    .xpos_rect(xpos_rect_ctl),
    .ypos_rect(ypos_rect_ctl),
    .rgb_address(rect2rom_address),
    .rgb_pixel(rom2rect_pixel)
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

draw_player u_draw_player(
    .clk(clk_40),
    .rst(rst),
    .vga_out(vga_player),
    .vga_in(vga_rect),
    .xpos_player(xpos_player_ctl),  
    .ypos_player(ypos_player_ctl)   
);

draw_player_ctl u_draw_player_ctl (
    .clk(clk_40),
    .rst(rst),
    .v_tick(vga_tim.vsync),
    .m_left(m_left),
    .m_right(m_right),
    .xpos_player(xpos_player_ctl),
    .ypos_player(ypos_player_ctl)
);

MouseCtl u_mouse_ctl(
    .clk(clk_100),
    .rst(rst),
    .xpos(xpos_mouse),
    .ypos(ypos_mouse),
    .ps2_clk(ps2_clk), 
    .ps2_data(ps2_data),
    .left(m_left),
    .right(m_right),
    .zpos(),
    .middle(),
    .new_event(),
    .value('0)
);

endmodule
