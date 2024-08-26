module draw_rect_ctl (
    input  logic rst,
    input  logic v_tick,
    input  logic clk,
    input  logic button_pressed,
    output logic [11:0] xpos_rect,
    output logic [11:0] ypos_rect,
    output logic [13:0] rgb_address,  // Adres do odczytu z ROM
    input  logic [11:0] rgb_pixel,    // Dane piksela z ROM
    output logic [11:0] rgb_out       // Wyjściowy kolor piksela
);

// Definicja stanów
typedef enum logic [1:0] {
    IDLE = 2'b00,
    ELEVATE = 2'b01,
    FALL = 2'b10
} State;

State state, state_nxt;

logic [11:0] xpos_nxt, ypos_nxt;
logic v_tick_old;

always_ff @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        xpos_rect <= 350;
        ypos_rect <= 400;
    end else begin
        v_tick_old <= v_tick;
        if (v_tick && !v_tick_old) begin
            state <= state_nxt;
            xpos_rect <= xpos_nxt;
            ypos_rect <= ypos_nxt;
        end
    end
end

always_comb begin
    xpos_nxt = xpos_rect;
    ypos_nxt = ypos_rect;
    state_nxt = state;

    case (state)
        IDLE: begin
            if (button_pressed)
                state_nxt = ELEVATE;
        end
        ELEVATE: begin
            if (ypos_rect > 300)
                ypos_nxt = ypos_rect - 1;
            else
                state_nxt = IDLE;
        end
        FALL: begin
            if (!button_pressed && ypos_rect < 400)
                ypos_nxt = ypos_rect + 1;
            else if (button_pressed)
                state_nxt = ELEVATE;
            else
                state_nxt = IDLE;
        end
    endcase
end

// Wyprowadzenie adresu i koloru piksela
assign rgb_address = ypos_rect * 100 + xpos_rect;
assign rgb_out = rgb_pixel;

endmodule
