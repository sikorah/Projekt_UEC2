module mouse_to_gpio (
    input logic clk,
    input logic rst,
    input logic m_left,   // lewy przycisk myszki
    input logic m_right,  // prawy przycisk myszki
    output logic gpio_left,
    output logic gpio_right
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        gpio_left <= 0;
        gpio_right <= 0;
    end else begin
        gpio_left <= m_left;
        gpio_right <= m_right;
    end
end

endmodule
