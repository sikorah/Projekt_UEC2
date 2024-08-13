/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Draw background.
 */


 `timescale 1 ns / 1 ps

 module draw_bg (
     input  logic clk,
     input  logic rst,
 
     vga_if.out vga_out,
     vga_if.in vga_in,
 
     output logic [11:0] rgb_out
 );
 
 import vga_pkg::*;

 
 logic [11:0] rgb_nxt;
 
 /* dla ROM
logic [11:0] rgb_nxt;
 logic [19:0] rom_addr;  // Adres ROM (20-bitowy, aby zaadresować do 1024*768 pikseli)
 logic [11:0] rom_pixel;

 // Stałe dla rozdzielczości 1024x768
 localparam int HOR_PIXELS = 1024;
 localparam int VER_PIXELS = 768;
 
 
  // ROM Implementation (Image Storage)
  
 // Pamięć ROM, gdzie przechowywany jest obraz
  reg [11:0] rom [0:4095];
 
  initial begin
      // Inicjalizacja pamięci ROM obrazem
      // Upewnij się, że plik "background_image_2.data" zawiera dane zgodne z rozdzielczością 1024x768 (taką ma nasz obrazek na tło)
      $readmemh("background_image_2.data", rom);
  end
  
  always_ff @(posedge clk) begin
      // Odczyt piksela z ROM na podstawie adresu
      rom_pixel <= rom[rom_addr];
  end
 */

  always_ff @(posedge clk) begin : bg_ff_blk
    if (rst) begin
        vga_out.vcount <= '0;
        vga_out.vsync <= '0;
        vga_out.vblnk<= '0;
        vga_out.hcount <= '0;
        vga_out.hsync  <= '0;
        vga_out.hblnk <= '0;
        vga_out.rgb   <= '0;
    end else begin
        vga_out.vcount <=vga_in.vcount;
        vga_out.vsync  <=vga_in.vsync;
        vga_out.vblnk <= vga_in.vblnk;
        vga_out.hcount <=vga_in.hcount;
        vga_out.hsync  <=vga_in.hsync;
        vga_out.hblnk <= vga_in.hblnk;
        vga_out.rgb  <=rgb_nxt;
    end
end
 
/*
 always_comb begin : bg_comb_blk
     if (vga_in.vblnk || vga_in.hblnk) begin   // Obszar wygaszania:
         rgb_nxt = 12'h0_0_0;                  // - wypełnij czernią.
     end else if (vga_in.hcount < HOR_PIXELS && vga_in.vcount < VER_PIXELS) begin
         // Obliczenie adresu ROM na podstawie hcount i vcount
         rom_addr = vga_in.vcount * HOR_PIXELS + vga_in.hcount; 
         rgb_nxt = rom_pixel;                  // Przypisanie piksela z ROM do wyjścia
     end else begin
         // Poza obszarem obrazu, czarne tło
         rgb_nxt = 12'h0_0_0;
     end
 end
 */

 always_comb begin : bg_comb_blk
     if (vga_in.vblnk || vga_in.hblnk) begin             // Blanking region:
         rgb_nxt = 12'h0_0_0;                    // - make it it black.
     end else begin                              // Active region:
         if (vga_in.vcount == 0)                     // - top edge:
             rgb_nxt = 12'hf_f_0;                // - - make a yellow line.
         else if (vga_in.vcount == VER_PIXELS - 1)   // - bottom edge:
             rgb_nxt = 12'hf_0_0;                // - - make a red line.
         else if (vga_in.hcount == 0)                // - left edge:
             rgb_nxt = 12'h0_f_0;                // - - make a green line.
         else if (vga_in.hcount == HOR_PIXELS - 1)   // - right edge:
             rgb_nxt = 12'h0_0_f;                // - - make a blue line.
 
        //terrain

             //ground
         else if (vga_in.vcount > 500)             
             rgb_nxt = 12'h0_f_0;
         
             //buttons - do tego raczej oddzielny modol
         else if ((vga_in.vcount > 490 && vga_in.vcount <= 500) && ((vga_in.hcount > 200 && vga_in.hcount < 250) || (vga_in.hcount > 600 && vga_in.hcount < 650)))
             rgb_nxt = 12'hf_0_0;                  

             // the obsticle do tego raczej oddzielny modol
        else if ((vga_in.vcount > 350 && vga_in.vcount <= 500) && (vga_in.hcount >  370 && vga_in.hcount < 470))
             rgb_nxt = 12'hF0F;  

             //house
        else if ((vga_in.vcount > 350 && vga_in.vcount <= 500) && (vga_in.hcount > 699 && vga_in.hcount < 725))
             rgb_nxt = 12'hf_f_0;
        else if ((vga_in.vcount > 350 && vga_in.vcount <= 500) && (vga_in.hcount > 775 && vga_in.hcount < 800))
             rgb_nxt = 12'hf_f_0;
        else if ((vga_in.vcount > 400 && vga_in.vcount <= 425) && (vga_in.hcount > 700 && vga_in.hcount < 800))
             rgb_nxt = 12'hf_f_0;
        else if (vga_in.vcount <= 425 && vga_in.vcount >= (-2'd2)*vga_in.hcount + 1850 && vga_in.vcount >= (2'd2)*vga_in.hcount - 1150)
             rgb_nxt = 12'h0FF;
        else if ((vga_in.vcount > 350 && vga_in.vcount < 425) && (vga_in.hcount > 700 && vga_in.hcount < 800))
             rgb_nxt = 12'hF0F;
        else if (vga_in.vcount <= 350 && vga_in.vcount >= (-2'd2)*vga_in.hcount + 1750 && vga_in.vcount >= (2'd2)*vga_in.hcount - 1250)
             rgb_nxt = 12'hf_f_0;
        else if ((vga_in.vcount > 425 && vga_in.vcount <= 500) && (vga_in.hcount > 725 && vga_in.hcount < 775))
             rgb_nxt = 12'h0_0_0;

            //clouds
        else if (((vga_in.vcount - 100)**2 + (vga_in.hcount - 100)**2 <= 300) || ((vga_in.vcount - 100)**2 + (vga_in.hcount - 150)**2 <= 300) || ((vga_in.vcount - 90)**2 + (vga_in.hcount - 125)**2 <= 600))
             rgb_nxt = 12'hFFF;
        else if (((vga_in.vcount - 275)**2 + (vga_in.hcount - 200)**2 <= 300) || ((vga_in.vcount - 275)**2 + (vga_in.hcount - 250)**2 <= 300) || ((vga_in.vcount - 265)**2 + (vga_in.hcount - 225)**2 <= 600))
             rgb_nxt = 12'hFFF;
        else if (((vga_in.vcount - 150)**2 + (vga_in.hcount - 400)**2 <= 700) || ((vga_in.vcount - 150)**2 + (vga_in.hcount - 460)**2 <= 700) || ((vga_in.vcount - 140)**2 + (vga_in.hcount - 425)**2 <= 900))
             rgb_nxt = 12'hFFF;
        else if (((vga_in.vcount - 200)**2 + (vga_in.hcount - 600)**2 <= 300) || ((vga_in.vcount - 200)**2 + (vga_in.hcount - 650)**2 <= 300) || ((vga_in.vcount - 190)**2 + (vga_in.hcount - 625)**2 <= 600))
             rgb_nxt = 12'hFFF;
        else if (((vga_in.vcount - 50)**2 + (vga_in.hcount - 700)**2 <= 300) || ((vga_in.vcount - 50)**2 + (vga_in.hcount - 750)**2 <= 300) || ((vga_in.vcount - 40)**2 + (vga_in.hcount - 725)**2 <= 600))
             rgb_nxt = 12'hFFF;
         else                                    // The rest of active display pixels:
             rgb_nxt = 12'h00F;                // - fill withdeep blue.
     end
        
 end
 
 endmodule