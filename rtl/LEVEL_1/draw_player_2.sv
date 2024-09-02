/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab
 *
 * Description:
 * Draw player in various states.
 */

 import state_pkg::*;

module draw_player_2(
    input  logic clk,
    input  logic rst,
    vga_if.out vga_out,
    vga_if.in vga_in,
    input logic [11:0] xpos_player2,
    input State2 state
);

import vga_pkg::*;

logic [11:0] rgb_nxt;
logic [11:0] rgb_pipe1, rgb_pipe2;
logic ypos_player2 = '0;

logic [11:0] vcount_d1, vcount_d2;
logic [11:0] hcount_d1, hcount_d2;
logic [11:0] ypos_d1, ypos_d2;
logic [11:0] xpos_d1, xpos_d2;

logic [23:0] vcount_diff1_stage1, hcount_diff1_stage1;
logic [23:0] vcount_diff2_stage1, hcount_diff2_stage1;
logic [23:0] dist1_stage2, dist2_stage2;


          
always_ff @(posedge clk) begin : bg_ff_blk
    if (rst) begin
        vga_out.vcount <= '0;
        vga_out.vsync <= '0;
        vga_out.vblnk<= '0;
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
        ypos_d1 <= ypos_player2;
        ypos_d2 <= ypos_d1;
        xpos_d1 <= xpos_player2;
        xpos_d2 <= xpos_d1;

        vcount_diff1_stage1  <= vcount_d2 - (440 - ypos_d2);
        hcount_diff1_stage1  <= hcount_d2 - (10 + xpos_d2);
        vcount_diff2_stage1  <= vcount_d2 - (440 - ypos_d2);
        hcount_diff2_stage1  <= hcount_d2 - (27 + xpos_d2);
        
        dist1_stage2 <= vcount_diff1_stage1 * vcount_diff1_stage1 + hcount_diff1_stage1 * hcount_diff1_stage1;
        dist2_stage2 <= vcount_diff2_stage1 * vcount_diff2_stage1 + hcount_diff2_stage1 * hcount_diff2_stage1;

    end
end


always_comb begin
    
    
    // Sprawdzenie stanu i odpowiednie rysowanie postaci
    case (state)
        IDLE2: begin
            // eyes
            if(dist1_stage2 <= 30 || dist2_stage2 <= 30)
                rgb_nxt = 12'h0FF;
                //ears

            // body
            else if ((vga_in.vcount + ypos_player2 > 420 && vga_in.vcount <= 480 + ypos_player2) && 
                     (vga_in.hcount > xpos_player2 && vga_in.hcount < 40 + xpos_player2))
                rgb_nxt = 12'hF00;
        
                //ears

            else if ((vga_in.vcount + ypos_player2 >= 415 && vga_in.vcount <= 420 + ypos_player2) && (
                    (vga_in.hcount > xpos_player2 && vga_in.hcount < 15 + xpos_player2) || vga_in.hcount > 25 +
                    xpos_player2 && vga_in.hcount < 40 + xpos_player2))
                rgb_nxt = 12'hF00;
            else if ((vga_in.vcount + ypos_player2 >= 410 && vga_in.vcount <= 415 + ypos_player2) && (
                    (vga_in.hcount > xpos_player2 && vga_in.hcount < 10 + xpos_player2) || vga_in.hcount > 30 +
                    xpos_player2 && vga_in.hcount < 40 + xpos_player2))
                rgb_nxt = 12'hF00;
            // legs
            else if ((vga_in.vcount > 480 + ypos_player2 && vga_in.vcount < 500 + ypos_player2 ) && 
                     ((vga_in.hcount > 0 + xpos_player2 && vga_in.hcount < 15 + xpos_player2) || 
                      (vga_in.hcount > 25 + xpos_player2 && vga_in.hcount < 40 + xpos_player2)))
                rgb_nxt = 12'hF00;

            else 
            rgb_nxt = vga_in.rgb;
        end
        RIGHT2: begin
            // player going right
            // body
            if ((vga_in.vcount > 410 + ypos_player2 && vga_in.vcount < 500 + ypos_player2 ) && 
                (vga_in.hcount > 0 + xpos_player2 && vga_in.hcount < 25 + xpos_player2))
                rgb_nxt = 12'hF00;
            // eye
            else if ((vga_in.vcount > 430 + ypos_player2 && vga_in.vcount < 450 + ypos_player2) && 
                     (vga_in.hcount  >= 25 + xpos_player2 && vga_in.hcount < 30 + xpos_player2 ))
                rgb_nxt = 12'h0FF;
                else 
            rgb_nxt = vga_in.rgb;
        end
        LEFT2: begin
            // player going left
            // body
            if ((vga_in.vcount > 410 + ypos_player2 && vga_in.vcount < 500 + ypos_player2 ) && 
                (vga_in.hcount > 5 + xpos_player2 && vga_in.hcount < 30 + xpos_player2))
                rgb_nxt = 12'hF00;
            // eye
            else if ((vga_in.vcount > 430 + ypos_player2 && vga_in.vcount < 450 + ypos_player2 ) && 
                     (vga_in.hcount >= 0 + xpos_player2 && vga_in.hcount < 5 + xpos_player2))
                rgb_nxt = 12'h0FF;
                else 
            rgb_nxt = vga_in.rgb;
        end
    endcase
end

endmodule