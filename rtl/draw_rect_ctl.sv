module draw_rect_ctl (
    input logic rst,
    input logic v_tick,
    input logic clk,
    input logic button_pressed,
    output logic [11:0] xpos,
    output logic [11:0] ypos,
    output logic [15:0] rgb_address, 
    output logic [7:0] rgb_pixel     
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
        xpos <= 350;
        ypos <= 350;
    end else begin
        v_tick_old <= v_tick;
        if (v_tick && !v_tick_old) begin
            state <= state_nxt;
            xpos <= xpos_nxt;
            ypos <= ypos_nxt;
        end
    end
end

always_comb begin
    xpos_nxt = xpos;
    ypos_nxt = ypos;
    state_nxt = state;

    case (state)
        IDLE: begin
            if (button_pressed)
                state_nxt = ELEVATE;
        end
        ELEVATE: begin
            if (ypos > 220)
                ypos_nxt = ypos - 1;
            else
                state_nxt = IDLE;
        end
        FALL: begin
            if (!button_pressed && ypos < 370)
                ypos_nxt = ypos + 1;
            else if (button_pressed)
                state_nxt = ELEVATE;
            else
                state_nxt = IDLE;
        end
    endcase
end

endmodule
