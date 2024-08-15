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
    .rst(rst),
    .v_tick(vga_bg.vsync),  // Use vsync as the vertical tick
    .xpos(xpos),
    .ypos(ypos)
);

endmodule
