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
    localparam HOR_PIXELS = 10'd800;
    localparam VER_PIXELS = 10'd600;
    localparam HOR_TOTAL_TIME = 11'd1055;
    localparam HOR_BLANK_START = 10'd799;
    localparam HOR_SYNC_START = 10'd839;
    localparam VER_TOTAL_TIME = 10'd627;
    localparam VER_BLANK_START = 10'd599;
    localparam VER_SYNC_START = 10'd600;
    
    // Add VGA timing parameters here and refer to them in other modules.
    localparam HOR_BLANK_STOP = 11'd1055;
    localparam VER_BLANK_STOP = 10'd627;
    localparam HOR_SYNC_STOP = 10'd967;
    localparam VER_SYNC_STOP = 10'd604;

    localparam COLOR_LETTER = 12'd0_0_13;
    
    endpackage
