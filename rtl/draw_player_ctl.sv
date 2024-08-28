/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab
 *
 * Description:
 * Control of players movements.
 */
module draw_player_ctl (
    input logic rst,
    input logic v_tick,
    input logic clk,
    input logic m_left,
    input logic m_right,
    input logic button_pressed,
    output logic [11:0] xpos_player,
    output logic [11:0] ypos_player

);

import state_pkg::*;

State state, state_nxt;
logic [11:0] xpos_nxt, ypos_nxt;
logic v_tick_old;

always_ff @(posedge clk) begin
    if (rst) begin
        state   <= IDLE;
    end else begin
        v_tick_old <= v_tick;
        if (v_tick && !v_tick_old) begin
            state   <= state_nxt;
            xpos_player    <= xpos_nxt;
            ypos_player    <= ypos_nxt;
        end
    end
end

always_comb begin
    // xpos_nxt = xpos_player;
    // ypos_nxt = ypos_player;
    // state_nxt = state; // Domyślne przypisanie bieżącego stanu

    case (state)
        IDLE: begin
            if (m_right) begin
                state_nxt = RIGHT;
            end 
            else if (m_left) begin
                state_nxt = LEFT;
            end
            
            else begin
                state_nxt = IDLE;
            end
            xpos_nxt = xpos_player;
            ypos_nxt = ypos_player;
        end
        RIGHT: begin
            if (xpos_player < 300 && m_right && !button_pressed) begin
                xpos_nxt = xpos_player + 1;
                state_nxt = state;
            end 
            else if ((xpos_player == 300) && m_right && !button_pressed) begin
                xpos_nxt  = xpos_player;
                state_nxt = state;
            end
            else if (xpos_player > 400  && m_right && !button_pressed) begin
                xpos_nxt = xpos_player + 1;
                state_nxt = state;
            end 
            else if (xpos_player > 300 && xpos_player <= 400 && m_right && button_pressed) begin
                xpos_nxt = xpos_player + 1;
                state_nxt = state;
            end 

            else begin
                state_nxt = IDLE;
                xpos_nxt = xpos_player ;
            end
            ypos_nxt = ypos_player;
        end
        LEFT: begin
            if (xpos_player > 0 && m_left && !button_pressed) begin
                xpos_nxt = xpos_player - 1;
                state_nxt = state;
            end 
            else if ((xpos_player == 450) && m_left && !button_pressed) begin
                xpos_nxt = xpos_player;
                state_nxt = state;
            end
            else if (xpos_player > 300 && xpos_player <= 400 && m_left && button_pressed) begin
                xpos_nxt = xpos_player - 1;
                state_nxt = state;
            end 
            else if ((xpos_player == 400) && m_left && !button_pressed) begin
                xpos_nxt  = xpos_player - 1;
                state_nxt = state;
            end
            else begin
                state_nxt = IDLE;
                xpos_nxt  = xpos_player;
            end
            ypos_nxt = ypos_player;
        end
        default: begin
            state_nxt = IDLE;
            xpos_nxt = xpos_player;
            ypos_nxt = ypos_player;
        end
    endcase
end

endmodule
