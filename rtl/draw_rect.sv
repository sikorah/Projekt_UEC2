module draw_rect
    #(
        parameter  W = 100,
        parameter  L = 100
    )(
        input  logic clk,
        input  logic rst,

        vga_if.out vga_out,
        vga_if.in vga_in,

        input logic [11:0] xpos, ypos,
        output logic [13:0] rgb_address,  // Adres dla odczytu z ROM
        input  logic [11:0] rgb_pixel     // Dane piksela z ROM
    );
    
    import vga_pkg::*;
    
    localparam COLOR = 12'hF0F;
    
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
         end
     end
     
     always_ff @(posedge clk) begin
        if (rst) begin
            vga_out.rgb <= '0;
        end else begin
            vga_out.rgb <= rgb_nxt;
        end
    end
    
     always_comb begin : bg_comb_blk                            
        if (vga_in.vcount <= ypos + W && vga_in.vcount >= ypos &&
            vga_in.hcount <= xpos + L && vga_in.hcount >= xpos) begin
            rgb_nxt = rgb_pixel;  // Z ROM
        end else
            rgb_nxt = vga_in.rgb;
     end

     assign addry = vga_in.vcount - ypos;
     assign addrx = vga_in.hcount - xpos;
     assign rgb_address = addry * 100 + addrx;  // Konwersja adresu na 14-bitowy format

endmodule
