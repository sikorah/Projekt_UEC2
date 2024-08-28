/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab
 *
 * Description:
 * ROM module.
 */
module image_rom (
    input  logic clk,
    input  logic [13:0] address,  // Adres = {7-bit addry, 7-bit addrx} (dla obrazu 100x100 pikseli)
    output logic [11:0] rgb  // 12-bitowy kolor (4-bit R, 4-bit G, 4-bit B)
);

/**
 * Local variables and signals
 */

reg [11:0] rom [0:9999];  // ROM dla obrazu 100x100 pikseli

/**
 * Memory initialization from a file
 */

initial $readmemh("mine.dat", rom);  // Zmodyfikowano do obsługi 100x100 pikseli

/**
 * Internal logic
 */
always_ff @(posedge clk)
    rgb <= rom[address];

endmodule
