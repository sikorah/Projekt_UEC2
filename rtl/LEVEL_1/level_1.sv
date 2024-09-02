/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab
 *
 * Description:
 * Draw background.
 */


 `timescale 1 ns / 1 ps

 module level_1 (
     input  logic clk,
     input  logic rst,
 
     vga_if.out vga_out,
     vga_if.in vga_in
 );
 
 import vga_pkg::*;

 
 logic [11:0] rgb_nxt;
 logic [11:0] rgb_nxt_pipe;
 logic [18:0] vcount_centered_pipe1, hcount_centered_pipe1;
 logic [18:0] vcount_centered_pipe2, hcount_centered_pipe2;
 logic [20:0] squared_dist_pipe;

 always_ff @(posedge clk) begin
     if (rst) begin
          vga_out.vcount <= '0;
          vga_out.vsync <= '0;
          vga_out.vblnk<= '0;
          vga_out.hcount <= '0;
          vga_out.hsync  <= '0;
          vga_out.hblnk <= '0;
          vga_out.rgb <= '0;

  
      end else begin
          vga_out.vcount <= vga_in.vcount;
          vga_out.vsync  <= vga_in.vsync ;
          vga_out.vblnk <= vga_in.vblnk ;
          vga_out.hcount <= vga_in.hcount;
          vga_out.hsync  <= vga_in.hsync ;
          vga_out.hblnk <= vga_in.hblnk ;
          vga_out.rgb <= rgb_nxt_pipe;
          
         

     end
 end
 always_ff @(posedge clk) begin
     vcount_centered_pipe1 <= vga_in.vcount - 100;
     hcount_centered_pipe1 <= vga_in.hcount - 100;

     vcount_centered_pipe2 <= vcount_centered_pipe1 * vcount_centered_pipe1;
     hcount_centered_pipe2 <= hcount_centered_pipe1 * hcount_centered_pipe1;
 
     squared_dist_pipe <= vcount_centered_pipe2 + hcount_centered_pipe2;
 end

 always_ff @(posedge clk) begin
     rgb_nxt_pipe <= rgb_nxt;
 end


 always_comb begin
     
     if ((vga_in.vblnk == 1 ) || (vga_in.hblnk == 1)) begin             // Blanking region:
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
 
        //terrain

             //ground
        else if (vga_in.vcount > 500)             
             rgb_nxt = 12'h0_f_0;

//////////////////////////////////////////////////////////////////////////////////////////////////////////       

             //house
        else if ((vga_in.vcount > 350 && vga_in.vcount <= 500) && (vga_in.hcount > 699 && vga_in.hcount < 725))
             rgb_nxt = 12'hf_f_0;
        else if ((vga_in.vcount > 350 && vga_in.vcount <= 500) && (vga_in.hcount > 775 && vga_in.hcount < 800))
             rgb_nxt = 12'hf_f_0;
        else if ((vga_in.vcount > 400 && vga_in.vcount <= 425) && (vga_in.hcount > 700 && vga_in.hcount < 800))
             rgb_nxt = 12'hf_f_0;
        else if (vga_in.vcount <= 425 && vga_in.vcount >= (-2'd2)*vga_in.hcount + 1850 && vga_in.vcount >= (2'd2)*vga_in.hcount - 1150)
             rgb_nxt = 12'h0FF;
        else if ((vga_in.vcount > 350 && vga_in.vcount < 425) && (vga_in.hcount > 700 && vga_in.hcount < 800))
             rgb_nxt = 12'hF0F;
        else if (vga_in.vcount <= 350 && vga_in.vcount >= (-2'd2)*vga_in.hcount + 1750 && vga_in.vcount >= (2'd2)*vga_in.hcount - 1250)
             rgb_nxt = 12'hf_f_0;
        else if ((vga_in.vcount > 425 && vga_in.vcount <= 500) && (vga_in.hcount > 725 && vga_in.hcount < 775))
             rgb_nxt = 12'h0_0_0;

///////////////////////////////////////////////////////////////////////////////////////////////////////////
            
             //clouds
          else if(squared_dist_pipe <= 4000)
             rgb_nxt = 12'hFF0;
          
        else                                    // The rest of active display pixels:
             rgb_nxt = 12'h00F;                // - fill withdeep blue.
     end
        
 end
 
 endmodule