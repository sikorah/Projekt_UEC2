/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab
 *
 * Description:
 * Control of players movements.
 */
import state_pkg::*;

module draw_player_ctl1 (
    input logic rst,
    input logic v_tick,
    input logic clk,
    input logic m_left,
    input logic m_right,
    input logic [1:0] button_pressed,
    output logic [11:0] xpos_player1,
    output State1 state

);



State1 state_nxt;
logic [11:0] xpos_nxt1;
logic v_tick_old;

always_ff @(posedge clk) begin
    if (rst) begin
        state   <= IDLE1;
        xpos_player1    <= '0;
        v_tick_old <= '0;
    end else begin
        v_tick_old <= v_tick;
        if (v_tick && !v_tick_old) begin
            state   <= state_nxt;
            xpos_player1    <= xpos_nxt1;
        end
    end
end

always_comb begin
    xpos_nxt1 = xpos_player1;
    state_nxt = state;
    case (state)

        IDLE1: begin

            if (m_right) begin
                state_nxt = RIGHT1;
            end
            else if (m_left) begin
                state_nxt = LEFT1;
            end
            else begin
                state_nxt = IDLE1;
            end

        end
        RIGHT1: begin
            if (xpos_player1 < 310 && m_right) begin      //przed klockiem
                xpos_nxt1 = xpos_player1 + 1;
                state_nxt = state;
            end
            else if ((xpos_player1 <= 310) && m_right && !button_pressed) begin
                //na granicy klocka od lewej, przycisk nie wciśnięty
                xpos_nxt1  = xpos_player1;
                state_nxt = state;
            end
            else if (xpos_player1 >= 310 && xpos_player1 <= 450 && m_right && button_pressed) begin
                //w granicach klocka, przycisk wciśnięty
                xpos_nxt1 = xpos_player1 + 1;
                state_nxt = state;
            end
            else if ((xpos_player1 >= 450) && m_right && !button_pressed) begin //na granicy klocka
                //od prawej, przycisk nie wciśnięty
                xpos_nxt1 = xpos_player1 + 1;
                state_nxt = state;
            end

            else if (xpos_player1 >= 450 && xpos_player1 < 660 && m_right ) begin // po klocku
                xpos_nxt1 = xpos_player1 + 1;
                state_nxt = state;
            end
            else if (xpos_player1 <= 660 && m_right ) begin // na granicy ekranu
                xpos_nxt1 = xpos_player1;
                state_nxt = state;
            end
            else begin
                state_nxt = IDLE1;
                xpos_nxt1 = xpos_player1;
            end


        end
        LEFT1: begin

            if (xpos_player1 > 0 && xpos_player1 < 310 && m_left ) begin // przed klockiem
                xpos_nxt1 = xpos_player1 - 1;
                state_nxt = state;
            end
            else if (xpos_player1 <= 0 && m_left ) begin // na granicy ekranu
                xpos_nxt1 = xpos_player1;
                state_nxt = state;
            end

            else if ((xpos_player1 <= 310) && m_left && !button_pressed) begin
                //na granicy klocka od lewej, przycisk nie wciśnięty
                xpos_nxt1 = xpos_player1 - 1;
                state_nxt = state;
            end
            else if (xpos_player1 >= 310 && xpos_player1 <= 450 && m_left && button_pressed) begin
                //w granicach klocka, przycisk wciśnięty
                xpos_nxt1 = xpos_player1 - 1;
                state_nxt = state;
            end
            else if ((xpos_player1 >= 450) && m_left && !button_pressed) begin
                //na granicy klocka od prawej, przycisk nie wciśnięty
                xpos_nxt1 = xpos_player1;
                state_nxt = state;
            end

            else if ((xpos_player1 > 450) && m_left) begin //po klocku
                xpos_nxt1  = xpos_player1 - 1;
                state_nxt = state;
            end
            else begin
                state_nxt = IDLE1;
                xpos_nxt1  = xpos_player1;
            end


        end


        default: begin
            state_nxt = IDLE1;
            xpos_nxt1 = xpos_player1;
        end
    endcase
end

endmodule
