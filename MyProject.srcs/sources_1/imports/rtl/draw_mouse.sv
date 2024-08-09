module draw_mouse
(
    input  logic clk,rst,
    vga_if.OUT out,
    vga_if.IN in,
    input logic [11:0] xpos,ypos
);

logic [11:0] rgb_nxt;

delay #(.W(4))u_delay(
    .clk(clk),
    .sig_in({in.vsync,in.vblnk,in.hsync,in.hblnk}),
    .sig_out({out.vsync,out.vblnk,out.hsync,out.hblnk})
);

delay #(.W(11)) u_delay_hcount(
    .clk(clk),
    .sig_in(in.hcount),
    .sig_out(out.hcount)
);

delay #(.W(11)) u_delay_vcount(
    .clk(clk),
    .sig_in(in.vcount),
    .sig_out(out.vcount)
);

always_ff @(posedge clk) begin
    if (rst) begin
        out.rgb   <= '0;
    end else begin

        out.rgb  <=rgb_nxt;
    end
end

MouseDisplay u_mouse_display(
     .pixel_clk(clk),
     .xpos(xpos),
     .ypos(ypos),
     .blank(in.vblnk||in.hblnk),
     .rgb_in(in.rgb),
     .rgb_out(rgb_nxt),
     .hcount(in.hcount),
     .vcount(in.vcount)
     );

endmodule