
/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab
 *
 * Description:
 * Control of obstice's movements.
 */
module draw_rect_ctl (
    input  logic rst,
    input  logic v_tick,
    input  logic clk,
    output  logic [1:0] button_pressed,
    input logic [11:0] xpos_player1,
    input logic [11:0] xpos_player2,
    output logic [11:0] xpos_rect,
    output logic [11:0] ypos_rect
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
logic [1:0] button1_pressed, button2_pressed;
logic [1:0] button_pressed_nxt;

always_ff @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        xpos_rect <= 476;
        ypos_rect <= 540;
        button_pressed <= 2'b00;
    end else begin
        v_tick_old <= v_tick;
        if (v_tick && !v_tick_old) begin
            state <= state_nxt;
            xpos_rect <= xpos_nxt;
            ypos_rect <= ypos_nxt;
            button_pressed <= button_pressed_nxt;
        end
    end
end

always_comb begin

    if((xpos_player1 >= 256 && xpos_player1 <= 320) || (xpos_player2 >= 256 && xpos_player2 <= 320))
    begin
        button1_pressed = 1;
    end else begin
        button1_pressed = 0;
    end

    if((xpos_player1 >= 768 && xpos_player1 <= 832) || (xpos_player2 >= 768 && xpos_player2 <= 832))
    begin
        button2_pressed = 1;
    end else begin
        button2_pressed = 0;
    end

    case (state)
        IDLE: begin
            if (button_pressed) begin
                state_nxt = ELEVATE;
            end
            else begin
                state_nxt = IDLE;
            end
            ypos_nxt = ypos_rect;
            xpos_nxt = xpos_rect;

        end
        ELEVATE: begin
            if (ypos_rect > 412 && button_pressed) begin
                state_nxt = state;
                ypos_nxt = ypos_rect - 1;
            end
            else if (ypos_rect == 412 && button_pressed) begin
                ypos_nxt = ypos_rect;
                state_nxt = state;
            end
            else begin
                state_nxt = FALL;
                ypos_nxt = ypos_rect;
            end
                xpos_nxt = xpos_rect;
        end
        FALL: begin
            if (!button_pressed && ypos_rect < 540) begin
                ypos_nxt = ypos_rect + 1;
                state_nxt = state;
            end
            else if (button_pressed) begin
                state_nxt = ELEVATE;
                ypos_nxt = ypos_rect;
            end
            else begin
                state_nxt = IDLE;
                ypos_nxt = ypos_rect;
            end
            xpos_nxt = xpos_rect;
        end
        default: begin
            state_nxt = IDLE;
            xpos_nxt = xpos_rect;
            ypos_nxt = ypos_rect;

        end
    endcase

    button_pressed_nxt = button1_pressed || button2_pressed;
end


endmodule
