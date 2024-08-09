/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * Top level synthesizable module including the project top and all the FPGA-referred modules.
 */

`timescale 1 ns / 1 ps

module top_vga_basys3 (
    input  wire clk,
    input  wire btnC,
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    output wire JA1,
    inout wire  PS2Clk,PS2Data
);


wire pclk40;
wire pclk_mirror40;
wire pclk100;
wire pclk_mirror100;


(* KEEP = "TRUE" *)
(* ASYNC_REG = "TRUE" *)

// For details on synthesis attributes used above, see AMD Xilinx UG 901:
// https://docs.xilinx.com/r/en-US/ug901-vivado-synthesis/Synthesis-Attributes


assign JA1 = pclk_mirror40;


clk_wiz_0  u_clk
    (
     .clk40MHz(pclk40),
     .clk100MHz(pclk100),
     .clk(clk)
    );

// Mirror pclk on a pin for use by the testbench;
// not functionally required for this design to work.

ODDR pclk40_oddr (
    .Q(pclk_mirror40),
    .C(pclk40),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
);


ODDR pclk100_oddr (
    .Q(pclk_mirror100),
    .C(pclk100),
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
    .clk40(pclk40),
    .clk100(pclk100),
    .rst(btnC),
    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync),
    .ps2_clk(PS2Clk),
    .ps2_data(PS2Data)
);

endmodule