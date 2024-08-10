/**
 * MTM Project_HubertSikora_ZuzannaSchab
 * 
 * Author: Zuzanna Schab
 *
 * Description:
 * Module for drawing background frame on VGA display with integrated image ROM.
 */

 `timescale 1 ns / 1 ps
 
 module draw_bg_with_image_rom (
     input  logic clk,
     input  logic rst,
     vga_if.in vga_in,      // Wejście interfejsu vga_if
     vga_if.out vga_out     // Wyjście interfejsu vga_if
 );
 import vga_pkg::*;
 
 /**
  * Local variables and signals
  */
 logic [11:0] rgb_nxt;
 logic [19:0] rom_addr;  // Adres ROM (20-bitowy, aby zaadresować do 1024*768 pikseli)
 logic [11:0] rom_pixel;

 // Stałe dla rozdzielczości 1024x768
 localparam int HOR_PIXELS = 1024;
 localparam int VER_PIXELS = 768;
 
 /**
  * ROM Implementation (Image Storage)
  */
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

 /**
  * VGA Signal Processing
  */
 always_ff @(posedge clk) begin : bg_ff_blk
     if (rst) begin
         // Resetowanie wszystkich sygnałów
         vga_out.vcount <= '0;
         vga_out.vsync  <= '0;
         vga_out.vblnk  <= '0;
         vga_out.hcount <= '0;
         vga_out.hsync  <= '0;
         vga_out.hblnk  <= '0;
         vga_out.rgb    <= '0;
     end else begin
         // Przekazywanie sygnałów z wejścia do wyjścia
         vga_out.vcount <= vga_in.vcount;
         vga_out.vsync  <= vga_in.vsync;
         vga_out.vblnk  <= vga_in.vblnk;
         vga_out.hcount <= vga_in.hcount;
         vga_out.hsync  <= vga_in.hsync;
         vga_out.hblnk  <= vga_in.hblnk;
         vga_out.rgb    <= rgb_nxt;
     end
 end
 
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

endmodule
