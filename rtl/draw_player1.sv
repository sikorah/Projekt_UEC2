/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab
 *
 * Description:
 * Draw player in various states.
 */

 import state_pkg::*;

module draw_player1(
    input  logic clk,
    input  logic rst,
    vga_if.out vga_out,
    vga_if.in vga_in,
    input logic [11:0] xpos_player1,
    input logic [11:0] ypos_player1,
    input State state
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
    end else begin
        vga_out.vcount <= vga_in.vcount;
        vga_out.vsync  <= vga_in.vsync ;
        vga_out.vblnk <= vga_in.vblnk ;
        vga_out.hcount <= vga_in.hcount;
        vga_out.hsync  <= vga_in.hsync ;
        vga_out.hblnk <= vga_in.hblnk ;
    end
end

always_ff @(posedge clk) begin
    if (rst) begin
        vga_out.rgb   <= '0;
    end else begin
        vga_out.rgb  <= rgb_nxt;
    end
end

always_comb begin : bg_comb_blk                            
    rgb_nxt = vga_in.rgb;
    
    // Sprawdzenie stanu i odpowiednie rysowanie postaci
    case (state)
        IDLE: begin
            // player1 standing
            
            // body
            if ((vga_in.vcount + ypos_player1 > 420 && vga_in.vcount <= 480 + ypos_player1) && 
                     (vga_in.hcount > 0 + ypos_player1 && vga_in.hcount < 40 + ypos_player1))
                rgb_nxt = 12'hFFF;
            // legs
            if ((vga_in.vcount > 480 + ypos_player1 && vga_in.vcount < 500 + ypos_player1 ) && 
                     ((vga_in.hcount > 0 + ypos_player1 && vga_in.hcount < 15 + ypos_player1) || 
                      (vga_in.hcount > 25 + ypos_player1 && vga_in.hcount < 40 + ypos_player1)))
                rgb_nxt = 12'hFFF;
            // eyes
            if ((((vga_in.vcount - (440 - ypos_player1))**2 + (vga_in.hcount - (10 + ypos_player1))**2 <= 30)) || 
                ((vga_in.vcount - (440 - ypos_player1))**2 + (vga_in.hcount - (27 + ypos_player1))**2 <= 30))
                rgb_nxt = 12'h000;
        end
        RIGHT1: begin
            // player going right
            // body
            if ((vga_in.vcount > 420 + ypos_player1 && vga_in.vcount < 500 + ypos_player1 ) && 
                (vga_in.hcount > 0 + ypos_player1 && vga_in.hcount < 25 + ypos_player1))
                rgb_nxt = 12'hFFF;
            // eye
            if ((vga_in.vcount > 425 + ypos_player1 && vga_in.vcount < 455 + ypos_player1) && 
                     (vga_in.hcount  >= 25 + ypos_player1 && vga_in.hcount < 30 + ypos_player1 ))
                rgb_nxt = 12'h000;
        end
        LEFT1: begin
            // player going left
            // body
            if ((vga_in.vcount > 420 + ypos_player1 && vga_in.vcount < 500 + ypos_player1 ) && 
                (vga_in.hcount > 5 + ypos_player1 && vga_in.hcount < 30 + ypos_player1))
                rgb_nxt = 12'hFFF;
            // eye
            if ((vga_in.vcount > 425 + ypos_player1 && vga_in.vcount < 455 + ypos_player1 ) && 
                     (vga_in.hcount >= 0 + ypos_player1 && vga_in.hcount < 5 + ypos_player1))
                rgb_nxt = 12'h000;
        end
        
    endcase
end

endmodule