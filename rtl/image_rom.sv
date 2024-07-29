/**
 * MTM Project_HubertSikora_ZuzannaSchab
 * 
 * Author: Zuzanna Schab
 *
 * Description:
 * Background image ROM
 */

 module image_rom (
    input  logic clk ,
    input  logic [11:0] address,  // address = {addry[5:0], addrx[5:0]}
    output logic [11:0] rgb
);


/**
 * Local variables and signals
 */

reg [11:0] rom [0:786435];


/**
 * Memory initialization from a file
 */

/* Relative path from the simulation or synthesis working directory */
initial $readmemh("../../rtl/background_image_2.dat", rom);


/**
 * Internal logic
 */

always @(posedge clk) begin
    rgb <= rom[address];
 end

endmodule