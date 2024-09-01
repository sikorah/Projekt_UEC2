import vga_pkg::*;

module char_rom_title(
    input  logic        clk,
    output  logic [6 :0] char_code,            
    input logic  [7:0] char_xy
);

logic [6:0] data;

always_ff @(posedge clk)
    char_code <= data;
always_comb begin
    case(char_xy)
        12'h000: data = "P";
        12'h001: data = "L";
        12'h002: data = "A";
        12'h003: data = "T";
        12'h004: data = "F";
        12'h005: data = "O";
        12'h006: data = "R";
        12'h007: data = "M";
        12'h008: data = "I";
        12'h009: data = "C";
        12'h00a: data = "O";
        12'h00b: data = "!";
        default : data = 7'h20;
    endcase
end

endmodule