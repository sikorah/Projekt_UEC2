/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk, Hubert Sikora, Zuzanna Schab
 *
 * Description:
 * Top level synthesizable module including the project top and all the FPGA-referred modules.
 */

`timescale 1 ns / 1 ps


 module top_vga_basys3 (
    input  wire clk,
    input  wire btnC,
    input wire JA2,
    input wire JA3,
    output wire JA4,
    output wire JA5,
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire JA1,
    inout wire  PS2Clk,PS2Data
);


wire pclk_65;
wire pclk_mirror65;
wire locked;

(* KEEP = "TRUE" *)
(* ASYNC_REG = "TRUE" *)

// For details on synthesis attributes used above, see AMD Xilinx UG 901:
// https://docs.xilinx.com/r/en-US/ug901-vivado-synthesis/Synthesis-Attributes


assign JA1 = pclk_mirror65;


clk_wiz_0_clk_wiz  CLK
    (
     .clk65MHz(pclk_65),
     .clk100MHz(),
     .clk(clk),
     .locked(locked)
    );

// Mirror pclk on a pin for use by the testbench;
// not functionally required for this design to work.

ODDR pclk65_oddr (
    .Q(pclk_mirror65),
    .C(pclk_65),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
);


/**
 *  Project functional top module
 */

 top_vga u_top_vga (
     .clk_65(pclk_65),
     .rst(btnC),
     .r(vgaRed),
     .g(vgaGreen),
     .b(vgaBlue),
     .hs(Hsync),
     .vs(Vsync),
     .ps2_clk(PS2Clk),
     .ps2_data(PS2Data),
     .gpio_left_input(JA2),
     .gpio_right_input(JA3),
     .gpio_left_output(JA4),
     .gpio_right_output(JA5)
     );

endmodule
