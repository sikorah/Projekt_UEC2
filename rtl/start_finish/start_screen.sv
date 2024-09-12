/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Hubert Sikora, Zuzanna Schab
 *
 * Description:
 * Finish screen for game
 */
`timescale 1 ns / 1 ps

module start_screen (
    input  logic clk,
    input  logic rst,

    vga_if.out vga_out,
    vga_if.in vga_in
);

import vga_pkg::*;

logic [11:0] rgb_nxt;

function logic [11:0] get_text_pixel(input int x, input int y);
    // Litera "S"
    if (((x >= 275 && x < 313) && (y >= 333 && y < 346)) || // górna pozioma linia
        ((x >= 275 && x < 288) && (y >= 346 && y < 371)) || // lewy pionowy
        ((x >= 275 && x < 313) && (y >= 358 && y < 371)) || // środkowa pozioma linia
        ((x >= 300 && x < 313) && (y >= 371 && y < 397)) || // prawy pionowy
        ((x >= 275 && x < 313) && (y >= 384 && y < 397)))   // dolna pozioma linia
        return 12'h0_0_0; // czarny

    // Litera "T"
    else if (((x >= 326 && x < 378) && (y >= 333 && y < 346)) || // górna pozioma linia
             ((x >= 346 && x < 358) && (y >= 346 && y < 397)))   // środkowy pionowy
        return 12'h0_0_0; // czarny

    // Litera "A"
    else if (((x >= 384 && x < 397) && (y >= 346 && y < 397)) || // lewy pionowy
             ((x >= 410 && x < 422) && (y >= 346 && y < 397)) || // prawy pionowy
             ((x >= 397 && x < 410) && (y >= 333 && y < 346)) || // górna pozioma linia
             ((x >= 397 && x < 410) && (y >= 358 && y < 371)))   // środkowa pozioma linia
        return 12'h0_0_0; // czarny

    // Litera "R"
    else if (((x >= 435 && x < 448) && (y >= 333 && y < 397)) || // lewy pionowy
             ((x >= 448 && x < 461) && (y >= 333 && y < 346)) || // górna pozioma linia
             ((x >= 461 && x < 474) && (y >= 346 && y < 371)) || // prawy górny pionowy
             ((x >= 448 && x < 474) && (y >= 358 && y < 371)) || // środkowa pozioma linia
             ((x >= 454 && x < 467) && (y >= 371 && y < 384)) || // prawy dolny pionowy
             ((x >= 461 && x < 474) && (y >= 384 && y < 397)))  // prawy dolny pionowy
        return 12'h0_0_0; // czarny

    // Litera "T" (druga)
    else if (((x >= 480 && x < 531) && (y >= 333 && y < 346)) || // górna pozioma linia
             ((x >= 499 && x < 512) && (y >= 346 && y < 397)))   // środkowy pionowy
        return 12'h0_0_0; // czarny

    // Przerwa między wyrazami (10 pikseli szerokości)
    else if (x >= 531 && x < 544)
        return 12'hf_f_0; // żółty

    // Litera "G"
    else if (((x >= 557 && x < 595) && (y >= 333 && y < 346)) || // górna pozioma linia
             ((x >= 557 && x < 570) && (y >= 346 && y < 397)) || // lewy pionowy
             ((x >= 570 && x < 595) && (y >= 384 && y < 397)) || // dolna pozioma linia
             ((x >= 582 && x < 595) && (y >= 358 && y < 371)) || // prawy górny pionowy
             ((x >= 582 && x < 595) && (y >= 371 && y < 397)))   // prawy dolny pionowy
        return 12'h0_0_0; // czarny

    // Litera "A" (druga)
    else if (((x >= 608 && x < 621) && (y >= 346 && y < 397)) || // lewy pionowy
             ((x >= 634 && x < 646) && (y >= 346 && y < 397)) || // prawy pionowy
             ((x >= 621 && x < 634) && (y >= 333 && y < 346)) || // górna pozioma linia
             ((x >= 621 && x < 634) && (y >= 358 && y < 371)))   // środkowa pozioma linia
        return 12'h0_0_0; // czarny

    // Litera "M"
    else if (((x >= 659 && x < 672) && (y >= 333 && y < 397)) || // lewy pionowy
             ((x >= 698 && x < 710) && (y >= 333 && y < 397)) || // prawy pionowy
             ((x >= 672 && x < 678) && (y >= 346 && y < 359)) || // lewy ukośny
             ((x >= 691 && x < 698) && (y >= 346 && y < 359)) || // prawy ukośny
             ((x >= 678 && x < 691) && (y >= 358 && y < 371)))  // środkowa pozioma linia
        return 12'h0_0_0; // czarny

    // Litera "E"
    else if (((x >= 723 && x < 736) && (y >= 333 && y < 397)) || // lewy pionowy
             ((x >= 736 && x < 774) && (y >= 333 && y < 346)) || // górna pozioma linia
             ((x >= 736 && x < 774) && (y >= 358 && y < 371)) || // środkowa pozioma linia
             ((x >= 736 && x < 774) && (y >= 384 && y < 397)))   // dolna pozioma linia
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
        else if (vga_in.vcount > 320 && vga_in.vcount < 410 && vga_in.hcount > 205 && vga_in.hcount < 832) 
            rgb_nxt = get_text_pixel(vga_in.hcount, vga_in.vcount);       
        else                                    // Reszta aktywnego ekranu:
            rgb_nxt = 12'h0_f_0;                // - ustaw na zielono.
    end       
end

endmodule