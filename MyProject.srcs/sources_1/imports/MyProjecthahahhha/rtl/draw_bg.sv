/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Draw background.
 */


 `timescale 1 ns / 1 ps

 module draw_bg (
     input  logic clk,
     input  logic rst,
 
     vga_if.OUT out,
     vga_if.IN in
 );
 
 import vga_pkg::*;

 
 logic [11:0] rgb_nxt;
 
 

  always_ff @(posedge clk) begin : bg_ff_blk
    if (rst) begin
        out.vcount <= '0;
        out.vsync <= '0;
        out.vblnk<= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk <= '0;
        out.rgb  <= '0;
    end else begin
        out.vcount <=in.vcount;
        out.vsync  <=in.vsync;
        out.vblnk <= in.vblnk;
        out.hcount <=in.hcount;
        out.hsync  <=in.hsync;
        out.hblnk <= in.hblnk;
        out.rgb   <=rgb_nxt;
    end
end
 
 always_comb begin : bg_comb_blk
     if (in.vblnk || in.hblnk) begin             // Blanking region:
         rgb_nxt = 12'h0_0_0;                    // - make it it black.
     end else begin                              // Active region:
         if (in.vcount == 0)                     // - top edge:
             rgb_nxt = 12'hf_f_0;                // - - make a yellow line.
         else if (in.vcount == VER_PIXELS - 1)   // - bottom edge:
             rgb_nxt = 12'hf_0_0;                // - - make a red line.
         else if (in.hcount == 0)                // - left edge:
             rgb_nxt = 12'h0_f_0;                // - - make a green line.
         else if (in.hcount == HOR_PIXELS - 1)   // - right edge:
             rgb_nxt = 12'h0_0_f;                // - - make a blue line.
 
        // "Z"   
        else if (in.vcount >=8'd80 && in.vcount <=9'd113 && in.hcount >= 9'd150 && in.hcount <= 10'd315)
            rgb_nxt = 12'h0_0_f;                //Top line of "Z"
        else if (in.vcount >=10'd405 && in.vcount <= 10'd438 && in.hcount >= 9'd150 && in.hcount <= 10'd315)   
             rgb_nxt = 12'h0_0_f;               //Bottom line of "Z"
        else if (in.vcount >= 9'd80 && in.vcount <= 10'd438 && in.vcount >= (-2'd2)*in.hcount + 11'd700 && in.vcount <= (-2'd2)*in.hcount + 11'd745)    
             rgb_nxt = 12'h0_0_f;               //Slash line of "Z" 
             //r?wnanie prostej 2  y = -2x _+ 745
             //r?wnanie prostrej 1 - y = -2x + 700


        // "S"
            //gb_nxt = 12'h0_0_f; 
           
        else if (in.vcount >=8'd80 && in.vcount <=9'd113 && in.hcount >= 9'd450 && in.hcount <= 10'd650)
            rgb_nxt = 12'h0_0_f;                //Top line of "S"
        else if (in.vcount >=10'd405 && in.vcount <= 10'd438 && in.hcount >= 9'd450 && in.hcount <= 10'd650)   
            rgb_nxt = 12'h0_0_f;               //Bottom line of "S"
        else if (in.vcount >=10'd240 && in.vcount <= 10'd273 && in.hcount >= 9'd450 && in.hcount <= 10'd650)   
            rgb_nxt = 12'h0_0_f;               //Middle line of "S"
        else if (in.vcount >=10'd110 && in.vcount <= 10'd270 && in.hcount >= 9'd450 && in.hcount <= 10'd470)   
            rgb_nxt = 12'h0_0_f;               //Frist line of "S"
        else if (in.vcount >=10'd270 && in.vcount <= 10'd435 && in.hcount >= 10'd630 && in.hcount <= 10'd650)   
            rgb_nxt = 12'h0_0_f;               //Second line of "S"
         else                                    // The rest of active display pixels:
            rgb_nxt = 12'h5_f_d;                // - fill with gray.
     end
 end
 
 endmodule