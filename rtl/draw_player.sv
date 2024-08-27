/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab
 *
 * Description:
 * Draw player in various states.
 */

 import state_pkg::*;

module draw_player(
    input  logic clk,
    input  logic rst,
    vga_if.out vga_out,
    vga_if.in vga_in,
    input logic [11:0] xpos_player,
    input logic [11:0] ypos_player,
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
            // player standing
            // eyes
            if ((((vga_in.vcount - 440)**2 + (vga_in.hcount - 10)**2 <= 30)) || 
                ((vga_in.vcount - 440)**2 + (vga_in.hcount - 27)**2 <= 30))
                rgb_nxt = 12'h0FF;
            // body
            else if ((vga_in.vcount > 420 && vga_in.vcount <= 480) && 
                     (vga_in.hcount > 0 && vga_in.hcount < 40))
                rgb_nxt = 12'hFFF;
            // legs
            else if ((vga_in.vcount > 480 && vga_in.vcount < 500) && 
                     ((vga_in.hcount > 0 && vga_in.hcount < 15) || 
                      (vga_in.hcount > 25 && vga_in.hcount < 40)))
                rgb_nxt = 12'hFFF;
        end
        RIGHT: begin
            // player going right
            // body
            if ((vga_in.vcount > 420 && vga_in.vcount < 500) && 
                (vga_in.hcount > 0 && vga_in.hcount < 25))
                rgb_nxt = 12'hFFF;
            // eye
            else if ((vga_in.vcount > 425 && vga_in.vcount < 455) && 
                     (vga_in.hcount >= 25 && vga_in.hcount < 30))
                rgb_nxt = 12'h0FF;
        end
        LEFT: begin
            // player going left
            // body
            if ((vga_in.vcount > 420 && vga_in.vcount < 500) && 
                (vga_in.hcount > 5 && vga_in.hcount < 30))
                rgb_nxt = 12'hFFF;
            // eye
            else if ((vga_in.vcount > 425 && vga_in.vcount < 455) && 
                     (vga_in.hcount >= 0 && vga_in.hcount < 5))
                rgb_nxt = 12'h0FF;
        end
    endcase
end

endmodule