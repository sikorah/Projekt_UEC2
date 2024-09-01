`timescale 1 ns / 1 ps

 module draw_text
    #(
        parameter YPOS=100,
        parameter XPOS=150
    )(
     input  logic clk,
     input  logic rst,

     input  logic [7:0] char_pixels,
     output  logic [3:0] char_line,
     output  logic [7:0] char_xy,
 
     vga_if.out vga_out,
     vga_if.in vga_in
 );
 import vga_pkg::*;

/* delay #(.CLK_DEL(5),.W(4))u_delay(
    .clk(clk),
    .rst,
    .din({in.vsync,in.vblnk,in.hsync,in.hblnk}),
    .dout({out.vsync,out.vblnk,out.hsync,out.hblnk})
);

delay #(.CLK_DEL(5), .W(11)) u_delay_hcount(
    .clk(clk),
    .rst,
    .din(in.hcount),
    .dout(out.hcount)
);

delay #(.CLK_DEL(5), .W(11)) u_delay_vcount(
    .clk(clk),
    .rst,
    .din(in.vcount),
    .dout(out.vcount)
);

delay #(.CLK_DEL(1), .W(4)) u_delay_char_line(
    .clk(clk),
    .rst,
    .din(y[3:0]),
    .dout(char_line)
);*/


logic [10:0]  x,y;

assign x =vga_in.hcount-XPOS;
assign y= vga_in.vcount-YPOS;

always_ff @(posedge  clk) begin
    if (rst) begin
        vga_out.rgb   <= '0;
        char_xy <= '0;
    end else begin
        if( XPOS<=vga_in.hcount && vga_in.hcount <= XPOS+128+6 &&  YPOS <= vga_in.vcount && vga_in.vcount <= YPOS+256) begin
            vga_out.rgb <= char_pixels[~x[2:0]] ? 12'h0_0_0 : vga_in.rgb;
            char_xy <=  {y[7:4],x[6:3]};
        end else begin
            vga_out.rgb <= vga_in.rgb;
            char_xy <='X;
        end
    end

    
end

 endmodule