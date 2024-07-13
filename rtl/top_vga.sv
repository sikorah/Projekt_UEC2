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
    input  logic clk_40,
    input  logic clk_100,
    input  logic ps2_clk,
    input  logic ps2_data,
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
vga_if mouse_out();

logic [11:0] xpos;
logic [11:0] ypos;

logic [11:0] xpos_buf;
logic [11:0] ypos_buf;

/**
 * Signals assignments
 */

 assign vs = mouse_out.vsync;
 assign hs = mouse_out.hsync;
 assign {r,g,b} = mouse_out.rgb;


/**
 * Submodules instances
 */

vga_timing u_vga_timing (
    .clk(clk_40),
    .rst,
    .vga_in(vga_tim),
    .vga_out(vga_tim)
    
);

draw_bg u_draw_bg (
    .clk(clk_40),
    .rst,

    .vga_in(vga_tim),
    .vga_out(vga_bg)

);

/*draw_rect  #(
    .POSITION_X(100),
    .POSITION_Y(50),
    .HIGHT(150),
    .WIDTH(80),
    .COLOR(12'h0_f_0)
) u_draw_rect (
    .clk(clk_40),
    .rst,

    .vga_in(vga_bg),
    .vga_out(vga_rect)
);
*/
/*draw_rect u_draw_rect (
    .clk(clk_40),
    .rst,

    .vga_in(vga_bg),
    .vga_out(vga_rect),

    .xpos,
    .ypos
);
*/
/*
MouseCtl u_MouseCtl(
    .clk(clk_100),
    .rst,
    .ps2_data,
    .ps2_clk,
    .xpos(xpos_buf),
    .ypos(ypos_buf),

    .zpos(),
    .left(),
    .middle(),
    .right(),
    .new_event(),
    .value('0),
    .setx('0),
    .sety('0),
    .setmax_x('0),
    .setmax_y('0)

    );
*/
always_ff @(posedge clk_40) begin
    xpos <= xpos_buf;
    ypos <= ypos_buf;
end
/*
draw_mouse u_draw_mouse(
    .clk(clk_40),
    .rst,
    .vga_in(vga_rect),
    .vga_out(mouse_out),
    .xpos,
    .ypos
);

*/
endmodule
