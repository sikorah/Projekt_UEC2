/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab
 *
 * Description:
 * Draw buttons.
 * 
 */module draw_buttons (
    input logic clk,
    input logic rst,
    vga_if.out vga_out,
    vga_if.in vga_in,
    input logic [11:0] xpos_player,
    input logic [11:0] ypos_player,
    output logic button_pressed
);

import vga_pkg::*;
logic [11:0] rgb_nxt;
logic button1_pressed, button2_pressed;

always_ff @(posedge clk) begin
    if (rst) begin
        vga_out.vcount <= '0;
        vga_out.vsync <= '0;
        vga_out.vblnk<= '0;
        vga_out.hcount <= '0;
        vga_out.hsync  <= '0;
        vga_out.hblnk <= '0;
        vga_out.rgb   <= '0;
    end else begin
        vga_out.vcount <= vga_in.vcount;
        vga_out.vsync  <= vga_in.vsync;
        vga_out.vblnk <= vga_in.vblnk;
        vga_out.hcount <= vga_in.hcount;
        vga_out.hsync  <= vga_in.hsync;
        vga_out.hblnk <= vga_in.hblnk;
        vga_out.rgb  <= rgb_nxt;
    end
end

always_comb begin
    rgb_nxt = vga_in.rgb;

    // Rysowanie przycisków
    if ((vga_in.vcount > 490 && vga_in.vcount <= 500) && (vga_in.hcount > 200 && vga_in.hcount < 250)) begin
        rgb_nxt = 12'hf_0_0;
        button1_pressed = (xpos_player >= 200 && xpos_player <= 250) && (ypos_player >= 490 && ypos_player <= 500);
    
    end else if ((vga_in.vcount > 490 && vga_in.vcount <= 500) && (vga_in.hcount > 600 && vga_in.hcount < 650)) begin
        rgb_nxt = 12'hf_0_0;
        button2_pressed = (xpos_player >= 600 && xpos_player <= 650) && (ypos_player >= 490 && ypos_player <= 500);
    
    end else begin
        button1_pressed = 0;
        button2_pressed = 0;
    end
end

assign button_pressed = button1_pressed || button2_pressed;

endmodule
