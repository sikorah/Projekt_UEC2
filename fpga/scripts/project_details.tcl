# Copyright (C) 2023  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
#
# Description:
# Project detiles required for generate_bitstream.tcl
# Make sure that project_name, top_module and target are correct.
# Provide paths to all the files required for synthesis and implementation.
# Depending on the file type, it should be added in the corresponding section.
# If the project does not use files of some type, leave the corresponding section commented out.

#-----------------------------------------------------#
#                   Project details                   #
#-----------------------------------------------------#
# Project name                                  -- EDIT
set project_name vga_project

# Top module name                               -- EDIT
set top_module top_vga_basys3

# FPGA device
set target xc7a35tcpg236-1

#-----------------------------------------------------#
#                    Design sources                   #
#-----------------------------------------------------#
# Specify .xdc files location                   -- EDIT
set xdc_files {
    constraints/top_vga_basys3.xdc
    constraints/clk_wiz_0.xdc
}

# Specify SystemVerilog design files location   -- EDIT
set sv_files {
    ../rtl/pkgs/vga_pkg.sv 
    ../rtl/pkgs/state_pkg.sv
    ../rtl/mouse_to_gpio.sv
    ../rtl/pkgs/vga_if.sv
    ../rtl/vga_timing.sv
    ../rtl/state_machine/state_control.sv 
    ../rtl/start_finish/start_screen.sv 
    ../rtl/state_machine/start_game.sv 
    ../rtl/LEVEL_1/level_1.sv 
    ../rtl/start_finish/finish_screen.sv 
    ../rtl/LEVEL_1/draw_rect.sv
    ../rtl/LEVEL_1/draw_rect_ctl.sv
    ../rtl/top_vga.sv
    ../rtl/LEVEL_1/image_rom.sv
    ../rtl/LEVEL_1/draw_buttons.sv
    ../rtl/LEVEL_1/draw_player_1.sv 
    ../rtl/LEVEL_1/draw_player_2.sv 
    ../rtl/LEVEL_1/draw_player_ctl1.sv
    ../rtl/LEVEL_1/draw_player_ctl2.sv
    rtl/top_vga_basys3.sv
    rtl/clk_wiz_0_clk_wiz.v
    rtl/clk_wiz_0.v
}

# Specify Verilog design files location         -- EDIT
 set verilog_files {
    rtl/clk_wiz_0_clk_wiz.v
    rtl/clk_wiz_0.v
 }

# Specify VHDL design files location            -- EDIT
 set vhdl_files {
    ../rtl/mouse/MouseCtl.vhd
    ../rtl/mouse/MouseDisplay.vhd
    ../rtl/mouse/Ps2Interface.vhd
 }

# Specify files for a memory initialization     -- EDIT
 set mem_files {
    ../rtl/LEVEL_1/mine.dat
 
 }
