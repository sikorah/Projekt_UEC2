module ending_screen
    #(
        parameter YPOS=100,
        parameter XPOS=150
    )(
     input  logic clk,
     input  logic rst,

     input  logic [7:0] char_pixels,
     output  logic [3:0] char_line,
     output  logic [7:0] char_xy,
 
     vga_if.OUT out,
     vga_if.IN in
 );
 import vga_pkg::*;

 

logic [10:0]  x,y;

assign x =in.hcount-XPOS;
assign y= in.vcount-YPOS;

always_ff @(posedge  clk) begin
    if (rst) begin
        out.rgb   <= '0;
        char_xy <= '0;
    end else begin
        if( XPOS<=in.hcount && in.hcount <= XPOS+128+6 &&  YPOS <= in.vcount && in.vcount <= YPOS+256) begin
            out.rgb <= char_pixels[~x[2:0]] ? 12'h0_0_0 : in.rgb;
            char_xy <=  {y[7:4],x[6:3]};
        end else begin
            out.rgb <= in.rgb;
            char_xy <='X;
        end
    end

    
end

 endmodule