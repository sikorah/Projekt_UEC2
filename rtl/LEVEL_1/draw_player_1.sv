/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab
 *
 * Description:
 * Draw player in various states.
 */

 import state_pkg::*;

 module draw_player_1(
     input  logic clk,
     input  logic rst,
     vga_if.out vga_out,
     vga_if.in vga_in,
     input logic [11:0] xpos_player1,
     input State1 state
 );
 
 import vga_pkg::*;
 
 logic [11:0] rgb_nxt;
 logic [11:0] rgb_pipe1, rgb_pipe2;
 logic ypos_player1 = '0;
 
 logic [10:0] vcount_d1, vcount_d2;
 logic [10:0] hcount_d1, hcount_d2;
 logic [11:0] ypos_d1, ypos_d2;
 logic [11:0] xpos_d1, xpos_d2;
 
 logic [23:0] vcount_diff1_stage1, hcount_diff1_stage1;
 logic [23:0] vcount_diff2_stage1, hcount_diff2_stage1;
 logic [23:0] dist1_stage2, dist2_stage2;
 logic [23:0] dist1_stage3, dist2_stage3;
 
 always_ff @(posedge clk) begin : bg_ff_blk
     if (rst) begin
         vga_out.vcount <= '0;
         vga_out.vsync <= '0;
         vga_out.vblnk <= '0;
         vga_out.hcount <= '0;
         vga_out.hsync  <= '0;
         vga_out.hblnk <= '0;
         rgb_pipe1 <= 12'h000;
         rgb_pipe2 <= 12'h000;
         vga_out.rgb <= 12'h000;
 
         vcount_d1 <= '0;
         vcount_d2 <= '0;
         hcount_d1 <= '0;
         hcount_d2 <= '0;
         ypos_d1 <= '0;
         ypos_d2 <= '0;
         xpos_d1 <= '0;
         xpos_d2 <= '0;
 
         vcount_diff1_stage1 <= '0;
         hcount_diff1_stage1 <= '0;
         vcount_diff2_stage1 <= '0;
         hcount_diff2_stage1 <= '0;
         dist1_stage2 <= '0;
         dist2_stage2 <= '0;
         dist1_stage3 <= '0;
         dist2_stage3 <= '0;
 
     end else begin
         vga_out.vcount <= vga_in.vcount;
         vga_out.vsync  <= vga_in.vsync ;
         vga_out.vblnk <= vga_in.vblnk ;
         vga_out.hcount <= vga_in.hcount;
         vga_out.hsync  <= vga_in.hsync ;
         vga_out.hblnk <= vga_in.hblnk ;
 
         rgb_pipe1 <= rgb_nxt;
         rgb_pipe2 <= rgb_pipe1;
         vga_out.rgb  <= rgb_pipe2;
 
         vcount_d1 <= vga_in.vcount;
         vcount_d2 <= vcount_d1;
         hcount_d1 <= vga_in.hcount;
         hcount_d2 <= hcount_d1;
         ypos_d1 <= ypos_player1;
         ypos_d2 <= ypos_d1;
         xpos_d1 <= xpos_player1;
         xpos_d2 <= xpos_d1;
 
         vcount_diff1_stage1  <= vcount_d2 - (563 - ypos_d2);
         hcount_diff1_stage1  <= hcount_d2 - (13 + xpos_d2);
         vcount_diff2_stage1  <= vcount_d2 - (563 - ypos_d2);
         hcount_diff2_stage1  <= hcount_d2 - (35 + xpos_d2);
         
         dist1_stage2 <= vcount_diff1_stage1 * vcount_diff1_stage1 + hcount_diff1_stage1 * hcount_diff1_stage1;
         dist2_stage2 <= vcount_diff2_stage1 * vcount_diff2_stage1 + hcount_diff2_stage1 * hcount_diff2_stage1;
 
         // Now add the additional pipelining stage
         dist1_stage3 <= dist1_stage2;
         dist2_stage3 <= dist2_stage2;
     end
 end
 
 always_ff @(posedge clk) begin
 
     // Sprawdzenie stanu i odpowiednie rysowanie postaci
     case (state)
         IDLE1: begin
             // ears
             if ((vga_in.vcount + ypos_player1 >= 531 && vga_in.vcount <= 538 + ypos_player1) && (
                 (vga_in.hcount > xpos_player1 && vga_in.hcount < 19 + xpos_player1) || 
                 (vga_in.hcount > 32 + xpos_player1 && vga_in.hcount < 51 + xpos_player1)))
                 rgb_nxt <= 12'hF0F;
 
             // eyes
             else if (dist1_stage3 <= 38 || dist2_stage3 <= 38)
                 rgb_nxt <= 12'h0FF;
 
             else if ((vga_in.vcount + ypos_player1 >= 525 && vga_in.vcount <= 531 + ypos_player1) && (
                 (vga_in.hcount > xpos_player1 && vga_in.hcount < 13 + xpos_player1) || 
                 (vga_in.hcount > 38 + xpos_player1 && vga_in.hcount < 51 + xpos_player1)))
                 rgb_nxt <= 12'hF0F;
 
             else if ((vga_in.vcount + ypos_player1 > 538 && vga_in.vcount <= 614 + ypos_player1) && 
                      (vga_in.hcount > xpos_player1 && vga_in.hcount < 51 + xpos_player1))
                 rgb_nxt <= 12'hF0F;
                 
             // legs
             else if ((vga_in.vcount > 614 + ypos_player1 && vga_in.vcount < 640 + ypos_player1 ) && 
                      ((vga_in.hcount > 0 + xpos_player1 && vga_in.hcount < 19 + xpos_player1) || 
                       (vga_in.hcount > 32 + xpos_player1 && vga_in.hcount < 51 + xpos_player1)))
                 rgb_nxt <= 12'hF0F;
 
             else 
                 rgb_nxt <= vga_in.rgb;
         end
         RIGHT1: begin
             // player going right
             // body
             if ((vga_in.vcount > 525 + ypos_player1 && vga_in.vcount < 640 + ypos_player1 ) && 
                 (vga_in.hcount > 0 + xpos_player1 && vga_in.hcount < 32 + xpos_player1))
                 rgb_nxt <= 12'hF0F;
             // eye
             else if ((vga_in.vcount > 550 + ypos_player1 && vga_in.vcount < 576 + ypos_player1) && 
                      (vga_in.hcount  >= 32 + xpos_player1 && vga_in.hcount < 38 + xpos_player1 ))
                 rgb_nxt <= 12'h0FF;
 
             else 
                 rgb_nxt <= vga_in.rgb;
         end
         LEFT1: begin
             // player going left
             // body
             if ((vga_in.vcount > 525 + ypos_player1 && vga_in.vcount < 640 + ypos_player1 ) && 
                 (vga_in.hcount > 6 + xpos_player1 && vga_in.hcount < 38 + xpos_player1))
                 rgb_nxt <= 12'hF0F;
             // eye
             else if ((vga_in.vcount > 550 + ypos_player1 && vga_in.vcount < 576 + ypos_player1 ) && 
                      (vga_in.hcount >= 0 + xpos_player1 && vga_in.hcount < 6 + xpos_player1))
                 rgb_nxt <= 12'h0FF;
 
             else 
                 rgb_nxt <= vga_in.rgb;
         end
     endcase
 end
 
 endmodule
 