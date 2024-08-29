/**
 * MTM Project_HubertSikora_ZuzannaSchab
 * 
 * Author: Hubert Sikora
 *
 * Description:
 * Timing module for VGA display
 */


 `timescale 1 ns / 1 ps

 module vga_timing (
     input  logic clk,
     input  logic rst,
     vga_if.out vga_out   // Wyjście interfejsu vga_if
 );
 
 import vga_pkg::*;
 
 
 /**
  * Local variables and signals
  */
 
 logic [10:0] hcount_nxt;
 logic hsync_nxt;
 logic hblnk_nxt;
 logic [10:0] vcount_nxt;
 logic vsync_nxt;
 logic vblnk_nxt;
 
 
 /**
  * Internal logic
  */
 
 always_ff @(posedge clk) begin
     if(rst) begin
         vga_out.hcount <= '0;
         vga_out.hsync <= '0;
         vga_out.hblnk <= '0;
         vga_out.vcount <= '0;
         vga_out.vsync <= '0;
         vga_out.vblnk <= '0;
     end
     else begin
         vga_out.hcount <= hcount_nxt;
         vga_out.hsync <= hsync_nxt;
         vga_out.hblnk <= hblnk_nxt;
         vga_out.vcount <= vcount_nxt;
         vga_out.vsync <= vsync_nxt;
         vga_out.vblnk <= vblnk_nxt;
     end
 end
 
 always_comb begin
     if (vga_out.hcount < HOR_TOTAL_TIME - 1) begin
       hcount_nxt = vga_out.hcount + 1;
       vcount_nxt = vga_out.vcount;
     end 
     else if (vga_out.vcount < VER_TOTAL_TIME - 1 && vga_out.hcount == HOR_TOTAL_TIME - 1) begin
       vcount_nxt = vga_out.vcount + 1;
       hcount_nxt = '0;
     end    
     else begin
       vcount_nxt = '0;
       hcount_nxt = '0;
     end
   end
 
   always_comb begin 
     if (vga_out.hcount == HOR_SYNC_END - 1) begin                  
         hsync_nxt = '0;
     end 
     else if (vga_out.hcount == HOR_SYNC_START - 1) begin
       hsync_nxt = '1;                                  
     end        
     else begin
       hsync_nxt = vga_out.hsync;
     end
   end
 
   always_comb begin  
     if (vga_out.hcount == HOR_TOTAL_TIME - 1) begin 
         hblnk_nxt = '0;                                  
       end 
     else if (vga_out.hcount == HOR_BLANK_START - 1) begin     
       hblnk_nxt = '1;                                   
     end        
     else begin
       hblnk_nxt = vga_out.hblnk;
     end
   end 
 
   always_comb begin  
     if (vga_out.vcount == VER_SYNC_END- 1 && vga_out.hcount == HOR_TOTAL_TIME - 1) begin 
         vsync_nxt = '0;                                  
       end  
     else if (vga_out.vcount == VER_SYNC_START - 1 && vga_out.hcount == HOR_TOTAL_TIME - 1) begin
       vsync_nxt = '1;                                  
     end   
     else begin
       vsync_nxt = vga_out.vsync;
     end
   end
 
   always_comb begin  
    if (vga_out.vcount == VER_TOTAL_TIME - 1 && vga_out.hcount == HOR_TOTAL_TIME - 1) begin 
         vblnk_nxt = '0;  
    end                      
     else if (vga_out.vcount == VER_BLANK_START - 1 && vga_out.hcount == HOR_TOTAL_TIME - 1) begin         
       vblnk_nxt = '1;                                  
     end       
     else begin
       vblnk_nxt = vga_out.vblnk;
     end
   end
 
 
 endmodule
 