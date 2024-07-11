/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Vga timing controller.
 */

`timescale 1 ns / 1 ps

 module vga_timing (
    input  logic clk,
    input  logic rst,
    output logic [10:0] vcount,
    output logic vsync,
    output logic vblnk,
    output logic [10:0] hcount,
    output logic hsync,
    output logic hblnk,
    
   vga_if.IN vga_in,
   vga_if.OUT vga_out
);

import vga_pkg::*;
 
 logic [10:0] vcount_nxt = 1'd0;
 logic [10:0] hcount_nxt = 1'd0;
 logic vsync_nxt = 1'd0;
 logic hsync_nxt = 1'd0;
 logic vblnk_nxt = 1'd0;
 logic hblnk_nxt = 1'd0;
 
 always_ff @(posedge clk or posedge rst) begin
   if(rst) begin
     vga_out.hcount<=1'b0;
     vga_out.hblnk<=1'b0;
     vga_out.hsync<=1'b0;
     vga_out.vcount<=1'b0;
     vga_out.vblnk<=1'b0;
     vga_out.vsync<=1'b0;
   end
   else begin
     vga_out.hcount<=hcount_nxt;
     vga_out.hblnk<=hblnk_nxt;
     vga_out.hsync<=hsync_nxt;
     vga_out.vcount<=vcount_nxt;
     vga_out.vblnk<=vblnk_nxt;
     vga_out.vsync<=vsync_nxt;
    end
  end
      
 always_comb begin
   if(vga_in.hcount < HOR_TOTAL_TIME) begin
       hcount_nxt = vga_in.hcount + 1;
       vcount_nxt = vga_in.vcount;
   end
   else if(vga_in.vcount < VER_TOTAL_TIME && vga_in.hcount == HOR_TOTAL_TIME) begin
     hcount_nxt = 0;
     vcount_nxt = vga_in.vcount + 1;
   end 
   else begin
     hcount_nxt = 0;
     vcount_nxt = 0;
   end
 end 
 
 always_comb begin
   case(vga_in.hcount)
     (HOR_BLANK_START - 1) : hblnk_nxt = 1'b1;
     HOR_BLANK_STOP : hblnk_nxt = 1'b0;
     
     default: hblnk_nxt = vga_in.hblnk;
   endcase 
 end
 
 always_comb begin
   case(vga_in.hcount)
     (HOR_SYNC_START - 1) : hsync_nxt = 1'b1;
     HOR_SYNC_STOP : hsync_nxt = 1'b0;
     
     default: hsync_nxt = vga_in.hsync;
   endcase
 end
 
 always_comb begin
       if(vga_in.hcount == HOR_TOTAL_TIME)
         case(vga_out.vcount) 
           (VER_BLANK_START - 1) : vblnk_nxt = 1'b1; 
           VER_BLANK_STOP : vblnk_nxt = 1'b0;
           
           default: vblnk_nxt = vga_in.vblnk;
         endcase 
       end
       
 always_comb begin
       if(vga_in.hcount == HOR_TOTAL_TIME)
         case(vga_in.vcount) 
           (VER_SYNC_START - 1) : vsync_nxt = 1'b1; 
           VER_SYNC_STOP : vsync_nxt = 1'b0;
           
           default: vsync_nxt = vga_in.vsync;
         endcase 
       end
  
endmodule
