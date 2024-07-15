/**
 * MTM Project_HubertSikora_ZuzannaSchab
 * 
 * Author: Zuzanna Schab
 *
 * Description:
 * Module for drawing background frame on VGA display (to know where our screen ends)
 */


 `timescale 1 ns / 1 ps

 module draw_bg (
     input  logic clk,
     input  logic rst,
 
     vga_if.in vga_in,
     vga_if.out vga_out
 );
 
 import vga_pkg::*;
 logic [11:0] rgb_nxt;
  

  always_ff @(posedge clk) begin : bg_ff_blk
    if (rst) begin
        vga_out.hcount <= '0;
        vga_out.hblnk  <= '0;
        vga_out.hsync  <= '0;
        vga_out.vcount <= '0;
        vga_out.vblnk  <= '0;
        vga_out.vsync  <= '0;
    end else begin
        vga_out.vcount <= vga_in.vcount;
        vga_out.vsync  <= vga_in.vsync;
        vga_out.vblnk  <= vga_in.vblnk;
        vga_out.hcount <= vga_in.hcount;
        vga_out.hsync  <= vga_in.hsync;
        vga_out.hblnk  <= vga_in.hblnk;
        vga_out.rgb    <= rgb_nxt;
    end
end
 
 always_comb begin : bg_comb_blk
     if (vga_in.vblnk || vga_in.hblnk) begin             // Blanking region:
         rgb_nxt = 12'h0_0_0;                    // - make it it black.
     end else begin                              // Active region:
         if (vga_in.vcount == 0)                     // - top edge:
             rgb_nxt = 12'h0_0_0;                // - - make a black line.
         else if (vga_in.vcount == VER_PIXELS - 1)   // - bottom edge:
             rgb_nxt = 12'h0_0_0;                // - - make a black line.
         else if (vga_in.hcount == 0)                // - left edge:
             rgb_nxt = 12'h0_0_0;                // - - make a black line.
         else if (vga_in.hcount == HOR_PIXELS - 1)   // - right edge:
             rgb_nxt = 12'h0_0_0;                // - - make a black line.
 
     end
end
 
 endmodule