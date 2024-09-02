module mouse_to_gpio (
    input logic clk,
    input logic rst,
    input logic m_left,   // lewy przycisk myszki
    input logic m_right,  // prawy przycisk myszki
    input logic gpio_left_input,
    input logic gpio_right_input,
    output logic gpio_r,
    output logic gpio_l,
    output logic gpio_left_output,
    output logic gpio_right_output
);

always_ff @(posedge clk) begin
    if (rst) begin
        gpio_left_output <= '0;
        gpio_right_output <= '0;
    end else begin
        gpio_left_output <= m_left;
        gpio_right_output <= m_right;
        gpio_r <= gpio_right_input;
        gpio_l <= gpio_left_input;
    end
end

endmodule