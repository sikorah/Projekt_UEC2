/**
 * MTM Project_HubertSikora_ZuzannaSchab
 * 
 * Author: Hubert Sikora, Zuzanna Schab
 *
 * Description:
 * Timing module for VGA display
 */


 `timescale 1 ns / 1 ps

 module vga_timing (
  input  logic clk,
  input  logic rst,
  
  vga_if.out vga_out

);

import vga_pkg::*;


/**
* Local variables and signals
*/
logic [10:0] vcount_nxt, hcount_nxt;
logic vsync_nxt, hsync_nxt, vblnk_nxt, hblnk_nxt;

/**
* Internal logic
*/

always_ff @(posedge clk) begin 
  // counter 
  if(rst) begin
    vga_out.vcount <= '0;
    vga_out.vsync <= '0;
    vga_out.vblnk <= '0;
    vga_out.hcount <= '0;
    vga_out.hsync <= '0;
    vga_out.hblnk <= '0;
  end
  else begin
    vga_out.vcount <= vcount_nxt;
    vga_out.vsync <= vsync_nxt;
    vga_out.vblnk <= vblnk_nxt;
    vga_out.hcount <= hcount_nxt;
    vga_out.hsync <= hsync_nxt;
    vga_out.hblnk <= hblnk_nxt;
  end
end

always_comb begin 
  if(vga_out.hcount == H_COUNT_TOT - 1) begin
      hcount_nxt = '0; 
      if (vga_out.vcount == V_COUNT_TOT - 1) begin
          vcount_nxt = '0;
      end
      else begin
          vcount_nxt = vga_out.vcount + 1;
      end
  end
  else begin
      hcount_nxt = vga_out.hcount + 1;
      vcount_nxt = vga_out.vcount;
  end

  // synch and blank
  // vertical
  if (vcount_nxt >= V_SYNC_START && vcount_nxt < V_SYNC_END) begin
      vsync_nxt = 1;
  end
  else begin
      vsync_nxt = '0;
  end
  if (vcount_nxt >= V_BLNK_START && vcount_nxt < V_BLNK_END) begin
      vblnk_nxt = 1;
  end
  else begin
      vblnk_nxt = '0;
  end
  
  // horizontal
  if (hcount_nxt >= H_SYNC_START && hcount_nxt < H_SYNC_END) begin
      hsync_nxt = 1;
  end
  else begin
      hsync_nxt = '0;
  end
  if (hcount_nxt >= H_BLNK_START && hcount_nxt < H_BLNK_END) begin
      hblnk_nxt = 1;
  end
  else begin
      hblnk_nxt = '0;
  end
end
endmodule
 