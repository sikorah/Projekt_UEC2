set_property SRC_FILE_INFO {cfile:/home/student/zschab/Desktop/Projekt_UEC2/fpga/constraints/top_vga_basys3.xdc rfile:../../../../constraints/top_vga_basys3.xdc id:1} [current_design]
set_property SRC_FILE_INFO {cfile:/home/student/zschab/Desktop/Projekt_UEC2/fpga/constraints/clk_wiz_0.xdc rfile:../../../../constraints/clk_wiz_0.xdc id:2} [current_design]
set_property src_info {type:XDC file:1 line:7 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN W5 [get_ports clk]
set_property src_info {type:XDC file:1 line:111 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U18 [get_ports btnC]
set_property src_info {type:XDC file:1 line:126 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN J1 [get_ports {JA1}]
set_property src_info {type:XDC file:1 line:129 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN L2 [get_ports {JA[1]}]
set_property src_info {type:XDC file:1 line:130 export:INPUT save:INPUT read:READ} [current_design]
set_property IOSTANDARD LVCMOS33 [get_ports {JA[1]}]
set_property src_info {type:XDC file:1 line:236 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN G19 [get_ports {vgaRed[0]}]
set_property src_info {type:XDC file:1 line:238 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN H19 [get_ports {vgaRed[1]}]
set_property src_info {type:XDC file:1 line:240 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN J19 [get_ports {vgaRed[2]}]
set_property src_info {type:XDC file:1 line:242 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N19 [get_ports {vgaRed[3]}]
set_property src_info {type:XDC file:1 line:244 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN N18 [get_ports {vgaBlue[0]}]
set_property src_info {type:XDC file:1 line:246 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN L18 [get_ports {vgaBlue[1]}]
set_property src_info {type:XDC file:1 line:248 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN K18 [get_ports {vgaBlue[2]}]
set_property src_info {type:XDC file:1 line:250 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN J18 [get_ports {vgaBlue[3]}]
set_property src_info {type:XDC file:1 line:252 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN J17 [get_ports {vgaGreen[0]}]
set_property src_info {type:XDC file:1 line:254 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN H17 [get_ports {vgaGreen[1]}]
set_property src_info {type:XDC file:1 line:256 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN G17 [get_ports {vgaGreen[2]}]
set_property src_info {type:XDC file:1 line:258 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN D17 [get_ports {vgaGreen[3]}]
set_property src_info {type:XDC file:1 line:260 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P19 [get_ports Hsync]
set_property src_info {type:XDC file:1 line:262 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN R19 [get_ports Vsync]
set_property src_info {type:XDC file:1 line:274 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN C17 [get_ports PS2Clk]
set_property src_info {type:XDC file:1 line:277 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN B17 [get_ports PS2Data]
set_property src_info {type:XDC file:2 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk]] 0.100
