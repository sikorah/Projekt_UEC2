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
   localparam HOR_TOTAL_TIME = 1056;
   localparam HOR_BLANK_START = 800;
   localparam HOR_SYNC_START = 840;
   localparam VER_TOTAL_TIME = 628;
   localparam VER_BLANK_START = 600;
   localparam VER_SYNC_START = 601;
   
   // Add VGA timing parameters here and refer to them in other modules.
   localparam HOR_SYNC_END = 968;
   localparam HOR_BLANK_END = 1056;
   localparam VER_SYNC_END = 605;
   localparam VER_BLANK_END = 628;
   
   localparam RECT_LENGTH = 48;
   localparam RECT_HEIGHT = 64;
   
   localparam CHARX = 300;
   localparam CHARY = 300;
   localparam CHARH = 272;
   localparam CHARL = 128;
   
   endpackage
   