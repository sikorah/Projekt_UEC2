/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Hubert Sikora, Zuzanna Schab
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
        vga_out.hblnk  <= vga_in.hblnk;
        vga_out.hsync  <= vga_in.hsync;
        vga_out.rgb    <= rgb_nxt;
    end
end

function logic [11:0] get_text_pixel(input int x, input int y);
    // Litera "Y"
    if (((x >= 282 && x < 294) && (y >= 333 && y < 358)) || // lewy górny pionowy
        ((x >= 320 && x < 333) && (y >= 333 && y < 358)) || // prawy górny pionowy
        ((x >= 300 && x < 313) && (y >= 358 && y < 397)))   // dolny pionowy
        return 12'h0_0_0; // czarny

    // Litera "O"
    else if (((x >= 352 && x < 365) && (y >= 333 && y < 397)) || // lewy pionowy
             ((x >= 390 && x < 403) && (y >= 333 && y < 397)) || // prawy pionowy
             ((x >= 365 && x < 390) && (y >= 333 && y < 346)) || // górna pozioma linia
             ((x >= 365 && x < 390) && (y >= 384 && y < 397)))   // dolna pozioma linia
        return 12'h0_0_0; // czarny

    // Litera "U"
    else if (((x >= 422 && x < 435) && (y >= 333 && y < 397)) || // lewy pionowy
             ((x >= 461 && x < 474) && (y >= 333 && y < 397)) || // prawy pionowy
             ((x >= 435 && x < 461) && (y >= 384 && y < 397)))   // dolna pozioma linia
        return 12'h0_0_0; // czarny

    // Przerwa między wyrazami (10 pikseli szerokości)
    else if (x >= 486 && x < 499)
        return 12'hf_f_0; // żółty

    // Litera "W"
    else if (((x >= 512 && x < 525) && (y >= 333 && y < 397)) || // lewy pionowy
             ((x >= 550 && x < 563) && (y >= 333 && y < 397)) || // prawy pionowy
             ((x >= 525 && x < 531) && (y >= 371 && y < 384)) || // lewy ukośny
             ((x >= 544 && x < 550) && (y >= 371 && y < 384)))   // prawy ukośny
        return 12'h0_0_0; // czarny

    // Litera "I"
    else if (((x >= 576 && x < 627) && (y >= 333 && y < 346)) || // górna pozioma linia
             ((x >= 595 && x < 608) && (y >= 346 && y < 397)) || // środkowy pionowy
             ((x >= 576 && x < 627) && (y >= 384 && y < 397)))   // dolna pozioma linia
        return 12'h0_0_0; // czarny

    // Litera "N"
    else if (((x >= 652 && x < 665) && (y >= 333 && y < 397)) || // lewy pionowy
             ((x >= 691 && x < 704) && (y >= 333 && y < 397)) || // prawy pionowy
             ((x >= 665 && x < 691) && (y >= 346 && y < 358)))   // ukośny
        return 12'h0_0_0; // czarny

    else return 12'hf_f_0; // Żółty kolor tła, jeśli nie litera
endfunction

always_ff @(posedge clk) begin
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
        vga_out.hblnk  <= vga_in.hblnk;
        vga_out.hsync  <= vga_in.hsync;
        vga_out.rgb    <= rgb_nxt;
    end
end

always_comb begin : win_screen_comb_blk
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
            else if (vga_in.vcount > 320 && vga_in.vcount < 410 && vga_in.hcount > 205 && vga_in.hcount < 832) 
            rgb_nxt = get_text_pixel(vga_in.hcount, vga_in.vcount);       
        else                                    // Reszta aktywnego ekranu:
            rgb_nxt = 12'h0_f_0;                // - ustaw na zielono.
    end       
end

 endmodule