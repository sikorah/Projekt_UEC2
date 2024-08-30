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
     vga_if.in vga_in
 );
 
 import vga_pkg::*;

 
 logic [11:0] rgb_nxt;
 logic [10:0] vcount_nxt, hcount_nxt;
 logic hblnk_nxt, vblnk_nxt, hsync_nxt, vsync_nxt;


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
        vga_out.vcount <= vcount_nxt;
        vga_out.vsync  <= vsync_nxt;
        vga_out.vblnk <= vblnk_nxt;
        vga_out.hcount <= hcount_nxt;
        vga_out.hsync  <= hsync_nxt;
        vga_out.hblnk <= hblnk_nxt;
        vga_out.rgb  <= rgb_nxt;
    end
end
 
always_comb begin : data_passed
    vcount_nxt = vga_in.vcount;
    vblnk_nxt = vga_in.vblnk;
    vsync_nxt = vga_in.vsync;
    hcount_nxt = vga_in.hcount;
    hblnk_nxt = vga_in.hblnk;
    hsync_nxt = vga_in.hsync;
end

 always_comb begin : bg_comb_blk
     if ((vga_in.vblnk == 1 ) || (vga_in.hblnk == 1)) begin             
         rgb_nxt = 12'hf_0_0;                    // green background
     end else if (vga_in.vcount >= 225 && vga_in.vcount <= 375 && vga_in.hcount >= 300 && vga_in.hcount <= 500) begin     
         rgb_nxt = 12'h0_f_0;                  
     end
        
 end
 
 endmodule