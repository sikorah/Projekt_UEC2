/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab
 *
 * Description:
 * Draw obsticle with ROM.
 */
module draw_rect
    #(
        parameter  W = 100,
        parameter  L = 100
    )(
        input  logic clk,
        input  logic rst,

        vga_if.out vga_out,
        vga_if.in vga_in,

        input logic [11:0] xpos_rect, ypos_rect,
        output logic [13:0] rgb_address,  // Adres dla odczytu z ROM
        input  logic [11:0] rgb_pixel     // Dane piksela z ROM
    );
    
    import vga_pkg::*;
    

    
    logic [11:0] rgb_nxt;
    logic [6:0] addrx, addry;  // Adresy X i Y w obrębie obrazka
    
     always_ff @(posedge clk) begin : bg_ff_blk
         if (rst) begin
             vga_out.vcount <= '0;
             vga_out.vsync <= '0;
             vga_out.vblnk <= '0;
             vga_out.hcount <= '0;
             vga_out.hsync  <= '0;
             vga_out.hblnk <= '0;
         end else begin
             vga_out.vcount <= vga_in.vcount;
             vga_out.vsync  <= vga_in.vsync;
             vga_out.vblnk  <= vga_in.vblnk;
             vga_out.hcount <= vga_in.hcount;
             vga_out.hsync  <= vga_in.hsync;
             vga_out.hblnk  <= vga_in.hblnk;
             vga_out.rgb <= rgb_nxt;
         end
     end
     
    
     always_comb begin : bg_comb_blk                            
        if (vga_in.vcount <= ypos_rect + W && vga_in.vcount >= ypos_rect && vga_in.hcount <= xpos_rect + L && vga_in.hcount >= xpos_rect) begin
            rgb_nxt = rgb_pixel;  // Z ROM
        end else
            rgb_nxt = vga_in.rgb;
     end

     assign addry = vga_in.vcount - ypos_rect;
     assign addrx = vga_in.hcount - xpos_rect;
     assign rgb_address = addry * 100 + addrx;  // Konwersja adresu na 14-bitowy format

endmodule
