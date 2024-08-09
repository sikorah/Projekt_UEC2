module draw_mouse
(
    input  logic clk,rst,
    vga_if.OUT out,
    vga_if.IN in,
    output logic [11:0] rgb_out,
    input logic [11:0] rgb_in,xpos,ypos
);

logic [11:0] rgb_nxt;
 
always_ff @(posedge clk) begin : bg_ff_blk
    if (rst) begin
        out.vcount <= '0;
        out.vsync <= '0;
        out.vblnk<= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk <= '0;
        rgb_out   <= '0;  
    end else begin
        out.vcount <=in.vcount  ;
        out.vsync  <=in.vsync   ;
        out.vblnk <= in.vblnk   ;
        out.hcount <=in.hcount  ;
        out.hsync  <=in.hsync   ;
        out.hblnk <= in.hblnk ;
        rgb_out    <=rgb_nxt;
    end
end


MouseDisplay u_mouse_display(
     .pixel_clk(clk),
     .xpos(xpos),
     .ypos(ypos),
     .blank(in.vblnk||in.hblnk),
     .rgb_in(rgb_in),
     .rgb_out(rgb_nxt),
     .hcount(in.hcount),
     .vcount(in.vcount)
     );

endmodule