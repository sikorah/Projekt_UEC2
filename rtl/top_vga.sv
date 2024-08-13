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

 logic [11:0] rect2rom_adress;  // Address to access the image ROM
 logic [11:0] rom2rect_pixel;   // Pixel data from the image ROM

 /**
  * Signals assignments
  */
 
 assign vs = vga_bg.vsync;
 assign hs = vga_bg.hsync;
 assign {r, g, b} = vga_bg.rgb;  // Extract higher bits for RGB

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
   // .rom_addr(rect2rom_adress),  // Output address to ROM
   // .rom_pixel(rom2rect_pixel)   // Input pixel data from ROM
);
/*
image_rom u_image_rom (
    .clk(clk_40),
    .address(rect2rom_adress),   // Receive address from draw_bg
    .rgb(rom2rect_pixel)         // Output pixel data to draw_bg
);
*/
/*
<<<<< HEAD

draw_player u_draw_plaer(
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
/*
always_ff @(posedge clk_40) begin
    xpos <= xpos_buf;
    ypos <= ypos_buf;
end
*/
endmodule
