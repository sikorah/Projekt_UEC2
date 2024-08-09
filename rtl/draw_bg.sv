/**
 * MTM Project_HubertSikora_ZuzannaSchab
 * 
 * Author: Zuzanna Schab
 *
 * Description:
 * Module for drawing background frame on VGA display (to know where our screen ends)
 */


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
     vga_if.in vga_in,    // Wejście interfejsu vga_if
     vga_if.out vga_out   // Wyjście interfejsu vga_if
 );
 import vga_pkg::*;
 
 
 
 /**
  * Local variables and signals
  */
 
 logic [11:0] rgb_nxt;
 localparam LETTER_COLOR = 12'hf_0_0;
 
 /**
  * Internal logic
  */
 
 always_ff @(posedge clk) begin : bg_ff_blk
     if (rst) begin
         vga_out.vcount <= '0;
         vga_out.vsync  <= '0;
         vga_out.vblnk  <= '0;
         vga_out.hcount <= '0;
         vga_out.hsync  <= '0;
         vga_out.hblnk  <= '0;
         vga_out.rgb    <= '0;
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
             rgb_nxt = 12'hf_f_0;                // - - make a yellow line.
         else if (vga_in.vcount == VER_PIXELS - 1)   // - bottom edge:
             rgb_nxt = 12'hf_0_0;                // - - make a red line.
         else if (vga_in.hcount == 0)                // - left edge:
             rgb_nxt = 12'h0_f_0;                // - - make a green line.
         else if (vga_in.hcount == HOR_PIXELS - 1)   // - right edge:
             rgb_nxt = 12'h0_0_f;                // - - make a blue line.
 
         // Add your code here.

       // "Z"   
             else if (vga_in.vcount >=8'd80 && vga_in.vcount <=9'd113 && vga_in.hcount >= 9'd150 && vga_in.hcount <= 10'd315)
             rgb_nxt = 12'h0_0_f;                //Top line of "Z"
         else if (vga_in.vcount >=10'd405 && vga_in.vcount <= 10'd438 && vga_in.hcount >= 9'd150 && vga_in.hcount <= 10'd315)   
              rgb_nxt = 12'h0_0_f;               //Bottom line of "Z"
         else if (vga_in.vcount >= 9'd80 && vga_in.vcount <= 10'd438 && vga_in.vcount >= (-2'd2)*vga_in.hcount + 11'd700 && vga_in.vcount <= (-2'd2)*vga_in.hcount + 11'd745)    
              rgb_nxt = 12'h0_0_f;               //Slash line of "Z" 
              //r?wnanie prostej 2  y = -2x _+ 745
              //r?wnanie prostrej 1 - y = -2x + 700
 
 
         // "S"
             //gb_nxt = 12'h0_0_f; 
            
         else if (vga_in.vcount >=8'd80 && vga_in.vcount <=9'd113 && vga_in.hcount >= 9'd450 && vga_in.hcount <= 10'd650)
             rgb_nxt = 12'hf_0_0;                //Top line of "S"
         else if (vga_in.vcount >=10'd405 && vga_in.vcount <= 10'd438 && vga_in.hcount >= 9'd450 && vga_in.hcount <= 10'd650)   
             rgb_nxt = 12'hf_0_0;               //Bottom line of "S"
         else if (vga_in.vcount >=10'd240 && vga_in.vcount <= 10'd273 && vga_in.hcount >= 9'd450 && vga_in.hcount <= 10'd650)   
             rgb_nxt = 12'hf_0_0;               //Middle line of "S"
         else if (vga_in.vcount >=10'd110 && vga_in.vcount <= 10'd270 && vga_in.hcount >= 9'd450 && vga_in.hcount <= 10'd470)   
             rgb_nxt = 12'hf_0_0;               //Frist line of "S"
         else if (vga_in.vcount >=10'd270 && vga_in.vcount <= 10'd435 && vga_in.hcount >= 10'd630 && vga_in.hcount <= 10'd650)   
             rgb_nxt = 12'hf_0_0;               //Second line of "S"

         else                                    // The rest of active display pixels:
             rgb_nxt = 12'h0_f_0;                // - fill with green.
        end

    end

    endmodule