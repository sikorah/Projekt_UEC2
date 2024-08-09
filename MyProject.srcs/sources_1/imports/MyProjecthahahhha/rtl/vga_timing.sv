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
    vga_if.OUT out
);

import vga_pkg::*;


/**
 * Local variables and signals
 */

 logic [10:0] vcount_nxt = '0;
 logic [10:0] hcount_nxt = '0;
 logic vsync_nxt = '0;
 logic hsync_nxt = '0;
 logic vblnk_nxt = '0;
 logic hblnk_nxt = '0;

// Add your signals and variables here.


/**
 * Internal logic
 */
always_ff@(posedge clk) begin
    if(rst) begin
        out.vcount <= '0;
        out.hcount <= '0;
        out.vsync <= '0;
        out.hsync <= '0;
        out.hblnk <= '0;
        out.vblnk <= '0;
  
    end else begin
        out.vcount <= vcount_nxt;
        out.hcount <= hcount_nxt;
        out.vsync <= vsync_nxt;
        out.hsync <= hsync_nxt;
        out.hblnk <= hblnk_nxt;
        out.vblnk <= vblnk_nxt; 
    end
  end

//Horizontal counter
 always_comb  begin
    if(out.hcount < HCNT_MAX) begin
        hcount_nxt = out.hcount +1;
        vcount_nxt = out.vcount;
    end else if(out.vcount<VCNT_MAX &&  out.hcount== HCNT_MAX)begin
        hcount_nxt = 0;
        vcount_nxt = out.vcount +1;
    end else  begin  
        hcount_nxt =0;
        vcount_nxt=0;
    end
end

always_comb begin
    case(out.hcount)
        (HBLK_START-1):  hblnk_nxt = 1'b1;
        HBLK_STOP:       hblnk_nxt = 1'b0;
        default:         hblnk_nxt =out.hblnk;
    endcase
end

always_comb begin
    case(out.hcount)
        (HSYNC_START-1): hsync_nxt = 1'b1;
        HSYNC_STOP:      hsync_nxt = 1'b0;
        default:         hsync_nxt = out.hsync;
    endcase
end

always_comb  begin
    if(out.hcount ==  HCNT_MAX)
        case(out.vcount)
            (VBLK_START-1): vblnk_nxt = 1'b1;
            VBLK_STOP:      vblnk_nxt = 1'b0;
            default:        vblnk_nxt = out.vblnk;
        endcase
    else
        vblnk_nxt = out.vblnk;
end


always_comb  begin
    if(out.hcount ==  HCNT_MAX)
        case(out.vcount)
            (VSYNC_START-1): vsync_nxt = 1'b1;
            VSYNC_STOP:      vsync_nxt = 1'b0;
            default:         vsync_nxt = out.vsync;
        endcase
    else
        vsync_nxt = out.vsync;
end

endmodule