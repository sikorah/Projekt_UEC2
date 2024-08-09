module draw_rect
#(
    parameter WIDTH = 48,
    parameter HIGHT = 64,
    parameter COLOR = 12'hf_f_0

)
(
    input  logic clk,
    input  logic rst,
    vga_if.OUT out,
    vga_if.IN in,
    output logic [11:0] rgb_address,
    input logic [11:0] rgb_pixel, xpos, ypos, 
);

import vga_pkg::*;

logic [11:0] rgb_nxt;
logic [5:0] addrx,addry;
 

 always_ff @(posedge clk) begin : bg_ff_blk
     if (rst) begin
         out.vcount <= '0;
         out.vsync <= '0;
         out.vblnk<= '0;
         out.hcount <= '0;
         out.hsync  <= '0;
         out.hblnk <= '0;
     end else begin
         out.vcount <=in.vcount;
         out.vsync  <=in.vsync;
         out.vblnk <= in.vblnk;
         out.hcount <=in.hcount;
         out.hsync  <=in.hsync;
         out.hblnk <= in.hblnk;
     end
 end

always_ff @(posedge clk) begin
    if(rst) begin 
        out.rgb <= '0;
    end
    else begin
        out.rgb <= rgb_nxt;
    end
end

 always_comb begin : bg_comb_blk                            
    if (in.vcount <= xpos + WIDTH && in.vcount >= ypos && in.hcount <= xpos + HIGHT && in.hcount >= xpos)
        rgb_nxt=rgb_pixel;
    else
        rgb_nxt=in.rgb;
 end
 
 assign addry = in.vcount - ypos;
 assign addrx = in.hcount - xpos;
 assign address = {addry[5:0], addrx[5:0]};
 
endmodule