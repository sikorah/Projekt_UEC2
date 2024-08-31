/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Hubert Sikora
 *
 * Description:
 * Finish screen for game
 */


 `timescale 1 ns / 1 ps

 module finish_screen(
     input  logic clk,
     input  logic rst,
 
     vga_if.out vga_out,
     vga_if.in vga_in
 );
 
 import vga_pkg::*;

 
 logic [11:0] rgb_nxt;


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
        vga_out.rgb    <= rgb_nxt;
    end
end

always_comb begin : start_screen_comb_blk
    if (vga_in.vblnk || vga_in.hblnk) begin             // Region wygaszania:
        rgb_nxt = 12'h0_0_0;                    // - ustaw na czarno.
    end else begin                              // Aktywny region:
        if (vga_in.vcount == 0)                     // - górna krawędź:
            rgb_nxt = 12'hf_f_0;                // - - ustaw na żółto.
        else if (vga_in.vcount == VER_PIXELS - 1)   // - dolna krawędź:
            rgb_nxt = 12'hf_0_0;                // - - ustaw na czerwono.
        else if (vga_in.hcount == 0)                // - lewa krawędź:
            rgb_nxt = 12'h0_f_0;               
        else if (vga_in.hcount == HOR_PIXELS - 1)   // - prawa krawędź:
            rgb_nxt = 12'h0_0_f;                // - - ustaw na niebiesko.
        else if (vga_in.vcount > 250 && vga_in.vcount < 320 && vga_in.hcount > 160 && vga_in.hcount < 650) 
            rgb_nxt = 12'hf_f_0;       
        else                                    // Reszta aktywnego ekranu:
            rgb_nxt = 12'h0_f_0;                // - ustaw na zielono.
    end       
end
 
 endmodule