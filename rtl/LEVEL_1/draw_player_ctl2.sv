/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab
 *
 * Description:
 * Control of players movements.
 */
import state_pkg::*;

module draw_player_ctl2 (
    input logic rst,
    input logic v_tick,
    input logic clk,
    input logic [1:0] button_pressed,
    input logic gpio_left,
    input logic gpio_right,
    input logic m_right,
    output logic [11:0] xpos_player2,
    output State2 state

);



State2 state_nxt;
logic [11:0] xpos_nxt2; 
logic v_tick_old;

always_ff @(posedge clk) begin
    if (rst) begin
        state   <= IDLE2;
        xpos_player2    <= '0;
        v_tick_old <= '0;
    end else begin
        v_tick_old <= v_tick;
        if (v_tick && !v_tick_old) begin
            state   <= state_nxt;
            xpos_player2    <= xpos_nxt2;
        end
    end
end

always_comb begin
    xpos_nxt2 = xpos_player2;
    state_nxt = state;
    case (state)

        IDLE2: begin

            if(gpio_right) begin
                state_nxt = RIGHT2;
            end
            else if (gpio_left) begin
                state_nxt = LEFT2;
            end
            else begin
                state_nxt = IDLE2;
            end

        end
        RIGHT2: begin
            if (xpos_player2 < 310 && gpio_right) begin      //przed klockiem
                xpos_nxt2 = xpos_player2 + 1;
                state_nxt = state;
            end
            else if ((xpos_player2 <= 310) && gpio_right && !button_pressed) begin
                //na granicy klocka od lewej, przycisk nie wciśnięty
                xpos_nxt2  = xpos_player2;
                state_nxt = state;
            end
            else if (xpos_player2 >= 310 && xpos_player2 <= 450 && gpio_right && button_pressed)
            begin
                //w granicach klocka, przycisk wciśnięty
                xpos_nxt2 = xpos_player2 + 1;
                state_nxt = state;
            end
            else if ((xpos_player2 >= 450) && gpio_right && !button_pressed) begin
                //na granicy klocka od prawej, przycisk nie wciśnięty
                xpos_nxt2 = xpos_player2 + 1;
                state_nxt = state;
            end

            else if (xpos_player2 >= 450 && xpos_player2 < 660 && gpio_right) begin // po klocku
                xpos_nxt2 = xpos_player2 + 1;
                state_nxt = state;
            end
            else if (xpos_player2 <= 660 && gpio_right) begin // na granicy ekranu
                xpos_nxt2 = xpos_player2;
                state_nxt = state;
            end
            else begin
                state_nxt = IDLE2;
                xpos_nxt2  = xpos_player2;
            end

        end

        LEFT2: begin

            if (xpos_player2 > 0 && xpos_player2 < 310 && gpio_left) begin // przed klockiem
                xpos_nxt2 = xpos_player2 - 1;
                state_nxt = state;
            end
            else if (xpos_player2 <= 0 && gpio_left) begin // na granicy ekranu
                xpos_nxt2 = xpos_player2;
                state_nxt = state;
            end

            else if ((xpos_player2 <= 310) && gpio_left && !button_pressed) begin
                //na granicy klocka od lewej, przycisk nie wciśnięty
                xpos_nxt2 = xpos_player2 - 1;
                state_nxt = state;
            end
            else if (xpos_player2 >= 310 && xpos_player2 <= 450 && gpio_left && button_pressed)
            begin
                //w granicach klocka, przycisk wciśnięty
                xpos_nxt2 = xpos_player2 - 1;
                state_nxt = state;
            end
            else if ((xpos_player2 >= 450) && gpio_left && !button_pressed) begin
                //na granicy klocka od prawej, przycisk nie wciśnięty
                xpos_nxt2 = xpos_player2;
                state_nxt = state;
            end

            else if ((xpos_player2 > 450) && gpio_left) begin //po klocku
                xpos_nxt2  = xpos_player2 - 1;
                state_nxt = state;
            end
            else begin
                state_nxt = IDLE2;
                xpos_nxt2  = xpos_player2;
            end

        end
        default: begin
            state_nxt = IDLE2;
            xpos_nxt2 = xpos_player2;
        end
    endcase
end

endmodule
