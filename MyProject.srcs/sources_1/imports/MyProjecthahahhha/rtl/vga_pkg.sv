/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Package with vga related constants.
 */

package vga_pkg;

// Parameters for VGA Display 800 x 600 @ 60fps using a 40 MHz clock;
localparam HOR_PIXELS = 800;
localparam VER_PIXELS = 600;

// Add VGA timing parameters here and refer to them in other modules.
localparam HCNT_MAX=1055;
localparam  HBLK_START = 800;
localparam HBLK_STOP =1055;
localparam HSYNC_START = 840;
localparam HSYNC_STOP = 967;

localparam VCNT_MAX=627;
localparam  VBLK_START = 600;
localparam VBLK_STOP =627;
localparam VSYNC_START = 601;
localparam VSYNC_STOP = 605;

localparam IMG_H = 64;
localparam IMG_W = 48;


endpackage