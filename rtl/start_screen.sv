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
    if (((x >= 215 && x < 245) && (y >= 260 && y < 270)) || // górna pozioma linia
        ((x >= 215 && x < 225) && (y >= 270 && y < 290)) || // lewy pionowy
        ((x >= 215 && x < 245) && (y >= 280 && y < 290)) || // środkowa pozioma linia
        ((x >= 235 && x < 245) && (y >= 290 && y < 310)) || // prawy pionowy
        ((x >= 215 && x < 245) && (y >= 300 && y < 310)))   // dolna pozioma linia
        return 12'h0_0_0; // czarny

    // Litera "T"
    else if (((x >= 255 && x < 295) && (y >= 260 && y < 270)) || // górna pozioma linia
             ((x >= 270 && x < 280) && (y >= 270 && y < 310)))   // środkowy pionowy
        return 12'h0_0_0; // czarny

    // Litera "A"
    else if (((x >= 300 && x < 310) && (y >= 270 && y < 310)) || // lewy pionowy
             ((x >= 320 && x < 330) && (y >= 270 && y < 310)) || // prawy pionowy
             ((x >= 310 && x < 320) && (y >= 260 && y < 270)) || // górna pozioma linia
             ((x >= 310 && x < 320) && (y >= 280 && y < 290)))   // środkowa pozioma linia
        return 12'h0_0_0; // czarny

    // Litera "R"
    else if (((x >= 340 && x < 350) && (y >= 260 && y < 310)) || // lewy pionowy
             ((x >= 350 && x < 360) && (y >= 260 && y < 270)) || // górna pozioma linia
             ((x >= 360 && x < 370) && (y >= 270 && y < 290)) || // prawy górny pionowy
             ((x >= 350 && x < 370) && (y >= 280 && y < 290)) || // środkowa pozioma linia
             ((x >= 355 && x < 365) && (y >= 290 && y < 300)) || // prawy dolny pionowy
             ((x >= 360 && x < 370) && (y >= 300 && y < 310)))  // prawy dolny pionowy
        return 12'h0_0_0; // czarny

    // Litera "T" (druga)
    else if (((x >= 375 && x < 415) && (y >= 260 && y < 270)) || // górna pozioma linia
             ((x >= 390 && x < 400) && (y >= 270 && y < 310)))   // środkowy pionowy
        return 12'h0_0_0; // czarny

    // Przerwa między wyrazami (10 pikseli szerokości)
    else if (x >= 415 && x < 425)
        return 12'hf_f_0; // żółty

    // Litera "G"
    else if (((x >= 435 && x < 465) && (y >= 260 && y < 270)) || // górna pozioma linia
             ((x >= 435 && x < 445) && (y >= 270 && y < 310)) || // lewy pionowy
             ((x >= 445 && x < 465) && (y >= 300 && y < 310)) || // dolna pozioma linia
             ((x >= 455 && x < 465) && (y >= 280 && y < 290)) || // prawy górny pionowy
             ((x >= 455 && x < 465) && (y >= 290 && y < 310)))   // prawy dolny pionowy
        return 12'h0_0_0; // czarny

    // Litera "A" (druga)
    else if (((x >= 475 && x < 485) && (y >= 270 && y < 310)) || // lewy pionowy
             ((x >= 495 && x < 505) && (y >= 270 && y < 310)) || // prawy pionowy
             ((x >= 485 && x < 495) && (y >= 260 && y < 270)) || // górna pozioma linia
             ((x >= 485 && x < 495) && (y >= 280 && y < 290)))   // środkowa pozioma linia
        return 12'h0_0_0; // czarny

    // Litera "M"
    else if (((x >= 515 && x < 525) && (y >= 260 && y < 310)) || // lewy pionowy
             ((x >= 545 && x < 555) && (y >= 260 && y < 310)) || // prawy pionowy
             ((x >= 525 && x < 530) && (y >= 270 && y < 280)) || // lewy ukośny
             ((x >= 540 && x < 545) && (y >= 270 && y < 280)) || // prawy ukośny
             ((x >= 530 && x < 540) && (y >= 280 && y < 290)))  // środkowa pozioma linia
        return 12'h0_0_0; // czarny

    // Litera "E"
    else if (((x >= 565 && x < 575) && (y >= 260 && y < 310)) || // lewy pionowy
             ((x >= 575 && x < 605) && (y >= 260 && y < 270)) || // górna pozioma linia
             ((x >= 575 && x < 605) && (y >= 280 && y < 290)) || // środkowa pozioma linia
             ((x >= 575 && x < 605) && (y >= 300 && y < 310)))   // dolna pozioma linia
        return 12'h0_0_0; // czarny

    else return 12'hf_f_0; // Żółty kolor tła, jeśli nie litera
endfunction

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
            rgb_nxt = get_text_pixel(vga_in.hcount, vga_in.vcount);       
        else                                    // Reszta aktywnego ekranu:
            rgb_nxt = 12'h0_f_0;                // - ustaw na zielono.
    end       
end

endmodule
