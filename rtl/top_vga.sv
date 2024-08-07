/**
 * MTM Project_HubertSikora_ZuzannaSchab
 * 
 * Author: Hubert Sikora & Zuzanna Schab
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
vga_if vga_out();
//vga_if vga_rect();
//vga_if mouse_out();


logic [11:0] xpos;
logic [11:0] ypos;

logic [11:0] xpos_buf;
logic [11:0] ypos_buf;


/**
 * Signals assignments
 */

assign vs = vga_out.vsync;
assign hs = vga_out.hsync;
 //assign {r,g,b} = mouse_out.rgb;
assign {r,g,b} = vga_out.rgb;

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
/*image_rom u_image_rom(
    .clk(clk40),
    .address(rect2rom_adress),
    .rgb(rom2rect_pixel)
    );
<<<<<<< HEAD

/*draw_player u_draw_plaer(
    .clk(clk_40),
    .rst,
    .vga_in(vga_rect),
    .vga_out(mouse_out),
    .xpos,
    .ypos
    );
*/

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

always_ff @(posedge clk_40) begin
    xpos <= xpos_buf;
    ypos <= ypos_buf;
end

endmodule
