module char_rom_title(
    input  logic        clk,
    output  logic [6 :0] char_code,            
    input logic  [7:0] char_xy
);
import vga_pkg::*;

logic [255:0] [7:0] text ="\
PLATFORMICO!
";


logic x;
always_ff @(posedge clk) begin
    {x,char_code} <= text[char_xy];
end

endmodule