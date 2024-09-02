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
    // Litera "Y"
    if (((x >= 220 && x < 230) && (y >= 260 && y < 280)) || // lewy górny pionowy
        ((x >= 250 && x < 260) && (y >= 260 && y < 280)) || // prawy górny pionowy
        ((x >= 235 && x < 245) && (y >= 280 && y < 310)))   // dolny pionowy
        return 12'h0_0_0; // czarny

    // Litera "O"
    else if (((x >= 275 && x < 285) && (y >= 260 && y < 310)) || // lewy pionowy
             ((x >= 305 && x < 315) && (y >= 260 && y < 310)) || // prawy pionowy
             ((x >= 285 && x < 305) && (y >= 260 && y < 270)) || // górna pozioma linia
             ((x >= 285 && x < 305) && (y >= 300 && y < 310)))   // dolna pozioma linia
        return 12'h0_0_0; // czarny

    // Litera "U"
    else if (((x >= 330 && x < 340) && (y >= 260 && y < 310)) || // lewy pionowy
             ((x >= 360 && x < 370) && (y >= 260 && y < 310)) || // prawy pionowy
             ((x >= 340 && x < 360) && (y >= 300 && y < 310)))   // dolna pozioma linia
        return 12'h0_0_0; // czarny

    // Przerwa między wyrazami (10 pikseli szerokości)
    else if (x >= 380 && x < 390)
        return 12'hf_f_0; // żółty

    // Litera "W"
    else if (((x >= 400 && x < 410) && (y >= 260 && y < 310)) || // lewy pionowy
             ((x >= 430 && x < 440) && (y >= 260 && y < 310)) || // prawy pionowy
             ((x >= 410 && x < 415) && (y >= 290 && y < 300)) || // lewy ukośny
             ((x >= 425 && x < 430) && (y >= 290 && y < 300)))   // prawy ukośny
        return 12'h0_0_0; // czarny

    // Litera "I"
    else if (((x >= 450 && x < 490) && (y >= 260 && y < 270)) || // górna pozioma linia
             ((x >= 465 && x < 475) && (y >= 270 && y < 310)) || // środkowy pionowy
             ((x >= 450 && x < 490) && (y >= 300 && y < 310)))   // dolna pozioma linia
        return 12'h0_0_0; // czarny

    // Litera "N"
    else if (((x >= 510 && x < 520) && (y >= 260 && y < 310)) || // lewy pionowy
             ((x >= 540 && x < 550) && (y >= 260 && y < 310)) || // prawy pionowy
             ((x >= 520 && x < 540) && (y >= 270 && y < 280)))   // ukośny
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
        else if (vga_in.vcount > 250 && vga_in.vcount < 320 && vga_in.hcount > 160 && vga_in.hcount < 650) 
            rgb_nxt = get_text_pixel(vga_in.hcount, vga_in.vcount);       
        else                                    // Reszta aktywnego ekranu:
            rgb_nxt = 12'h0_f_0;                // - ustaw na zielono.
    end       
end

endmodule
