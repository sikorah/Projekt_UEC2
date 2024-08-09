module delay
    #(
        parameter N=2,
        parameter W=8
    )
    (
        input clk,
        input  logic [W-1:0] sig_in,
        output logic [W-1:0] sig_out
    );

    logic [N-1:0][W-1:0] shift_reg ;

    always_ff @(posedge clk) begin
        shift_reg <= (shift_reg<<W) | sig_in;
        sig_out <= shift_reg[N-1];
    end
endmodule