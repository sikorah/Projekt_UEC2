interface vga_if;
  logic [10:0] vcount;
  logic        vsync;
  logic        vblnk;
  logic [10:0] hcount;
  logic        hsync;
  logic        hblnk;
  logic [11:0] rgb;

  modport IN (input vcount,  vsync, vblnk,  hcount, hsync, hblnk,rgb);
  modport OUT (output vcount,  vsync, vblnk,  hcount, hsync, hblnk,rgb);

endinterface