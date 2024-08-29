/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Hubert Sikora
 *
 * Description:
 * Finish screen for game
 */


 `timescale 1 ns / 1 ps

 module finish_screen(
     input  logic clk,
     input  logic rst,
 
     vga_if.out vga_out,
     vga_if.in vga_in,
 
     output logic [11:0] rgb_out
 );
 
 import vga_pkg::*;

 
 logic [11:0] rgb_nxt;
 

  always_ff @(posedge clk) begin : bg_ff_blk
    if (rst) begin
        vga_out.vcount <= '0;
        vga_out.vsync <= '0;
        vga_out.vblnk<= '0;
        vga_out.hcount <= '0;
        vga_out.hsync  <= '0;
        vga_out.hblnk <= '0;
        vga_out.rgb   <= '0;
    end else begin
        vga_out.vcount <=vga_in.vcount;
        vga_out.vsync  <=vga_in.vsync;
        vga_out.vblnk <= vga_in.vblnk;
        vga_out.hcount <=vga_in.hcount;
        vga_out.hsync  <=vga_in.hsync;
        vga_out.hblnk <= vga_in.hblnk;
        vga_out.rgb  <=rgb_nxt;
    end
end
 
 always_comb begin : bg_comb_blk
     if (vga_in.vblnk || vga_in.hblnk) begin             
         rgb_nxt = 12'hf_0_0;                    // green background
     end else if (vga_in.vcount >= 225 && vga_in.vcount <= 375 && vga_in.hcount >= 300 && vga_in.hcount <= 500) begin     
         rgb_nxt = 12'h0_f_0;                  
     end
        
 end
 
 endmodule