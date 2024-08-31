module mouse_to_gpio (
    input logic clk,
    input logic rst,
    input logic m_left,   // lewy przycisk myszki
    input logic m_right,  // prawy przycisk myszki
    output logic gpio_left_output,
    output logic gpio_right_output
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        gpio_left_output <= 0;
        gpio_right_output <= 0;
    end else begin
        gpio_left_output <= m_left;
        gpio_right_output <= m_right;
    end
end

endmodule