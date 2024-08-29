/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Zuzanna Schab
 *
 * Description:
 * Control of players movements.
 */
import state_pkg::*;

module draw_player_ctl (
    input logic rst,
    input logic v_tick,
    input logic clk,
    input logic m_left,
    input logic m_right,
    input logic middle,
    input logic button_pressed,
    output logic [11:0] xpos_player1,
    output logic [11:0] ypos_player1,
    output logic [11:0] xpos_player2,
    output logic [11:0] ypos_player2,
    output State state

);

State state_nxt;
logic [11:0] xpos_nxt1, ypos_nxt1;
logic [11:0] xpos_nxt2, ypos_nxt2;
logic v_tick_old;

always_ff @(posedge clk) begin
    if (rst) begin
        state   <= IDLE;
        xpos_player1    <= '0;
        ypos_player1    <= '0;
        xpos_player2    <= '0;
        ypos_player2    <= '0;
    end else begin
        v_tick_old <= v_tick;
        if (v_tick && !v_tick_old) begin
            state   <= state_nxt;
            xpos_player1    <= xpos_nxt1;
            ypos_player1    <= ypos_nxt1;
            xpos_player2    <= xpos_nxt2;
            ypos_player2    <= ypos_nxt2;
        end
    end
end

always_comb begin

    case (state)
        IDLE: begin
            if (m_right) begin
                state_nxt = RIGHT1;
            end 
            else if (m_left) begin
                state_nxt = LEFT1;
            end
            else if (middle && m_right) begin
                state_nxt = RIGHT2;
            end 
            else if (middle && m_left) begin
                state_nxt = LEFT2;
            end
            
            else begin
                state_nxt = IDLE;
            end
            xpos_nxt1 = xpos_player1;
            ypos_nxt1 = ypos_player1;
            xpos_nxt2 = xpos_player2;
            ypos_nxt2 = ypos_player2;
        end
        RIGHT1: begin
            if (xpos_player1 < 350 && m_right) begin      //przed klockiem
                xpos_nxt1 = xpos_player1 + 1;
                state_nxt = state;
            end 
            else if ((xpos_player1 <= 350) && m_right && !button_pressed) begin //na granicy klocka od lewej, przycisk nie wciśnięty
                xpos_nxt1  = xpos_player1;
                state_nxt = state;
            end
            else if (xpos_player1 >= 350 && xpos_player1 <= 450 && m_right && button_pressed) begin //w granicach klocka, przycisk wciśnięty
                xpos_nxt1 = xpos_player1 + 1;
                state_nxt = state;
            end 
            
            else if (xpos_player1 >= 450 && xpos_player1 < 760 && m_right ) begin // po klocku
                xpos_nxt1 = xpos_player1 + 1;
                state_nxt = state;
            end 
            else begin
                state_nxt = IDLE;
                xpos_nxt1 = xpos_player1 ;
            end
            
            ypos_nxt1 = ypos_player1;
            xpos_nxt2 = xpos_player2;
            ypos_nxt2 = ypos_player2;
        end
        LEFT1: begin
            if (xpos_player1 > 0 && xpos_player1 < 350 && m_left ) begin // przed klockiem
                xpos_nxt1 = xpos_player1 - 1;
                state_nxt = state;
            end 
            else if (xpos_player1 >= 350 && xpos_player1 <= 450 && m_left && button_pressed) begin //w granicach klocka, przycisk wciśnięty
                xpos_nxt1 = xpos_player1 - 1;
                state_nxt = state;
            end 
            else if ((xpos_player1 >= 450) && m_left && !button_pressed) begin //na granicy klocka od prawej, przycisk nie wciśnięty
                xpos_nxt1 = xpos_player1;
                state_nxt = state;
            end
            
            else if ((xpos_player1 > 450) && m_left) begin //po klocku
                xpos_nxt1  = xpos_player1 - 1;
                state_nxt = state;
            end
            else begin
                state_nxt = IDLE;
                xpos_nxt1  = xpos_player1;
            end
            
            ypos_nxt1 = ypos_player1;
            xpos_nxt2 = xpos_player2;
            ypos_nxt2 = ypos_player2;
        end
        RIGHT2: begin
            if (xpos_player2 < 350 && m_right) begin      //przed klockiem
                xpos_nxt2 = xpos_player2 + 1;
                state_nxt = state;
            end 
            else if ((xpos_player2 <= 350) && m_right && !button_pressed) begin //na granicy klocka od lewej, przycisk nie wciśnięty
                xpos_nxt2  = xpos_player2;
                state_nxt = state;
            end
            else if (xpos_player2 >= 350 && xpos_player2 <= 450 && m_right && button_pressed) begin //w granicach klocka, przycisk wciśnięty
                xpos_nxt2 = xpos_player2 + 1;
                state_nxt = state;
            end 
            
            else if (xpos_player2 >= 450 && xpos_player2 < 760 && m_right ) begin // po klocku
                xpos_nxt2 = xpos_player2 + 1;
                state_nxt = state;
            end 
            else begin
                state_nxt = IDLE;
                xpos_nxt2 = xpos_player2 ;
            end
            xpos_nxt1 = xpos_player1;
            ypos_nxt1 = ypos_player1;
            ypos_nxt2 = ypos_player2;
        end
        LEFT2: begin
            if (xpos_player2 > 0 && xpos_player2 < 350 && m_left ) begin // przed klockiem
                xpos_nxt2 = xpos_player2 - 1;
                state_nxt = state;
            end 
            else if (xpos_player2 >= 350 && xpos_player2 <= 450 && m_left && button_pressed) begin //w granicach klocka, przycisk wciśnięty
                xpos_nxt2 = xpos_player2 - 1;
                state_nxt = state;
            end 
            else if ((xpos_player2 >= 450) && m_left && !button_pressed) begin //na granicy klocka od prawej, przycisk nie wciśnięty
                xpos_nxt2 = xpos_player2;
                state_nxt = state;
            end
            
            else if ((xpos_player2 > 450) && m_left) begin //po klocku
                xpos_nxt2  = xpos_player2 - 1;
                state_nxt = state;
            end
            else begin
                state_nxt = IDLE;
                xpos_nxt2  = xpos_player2;
            end
            xpos_nxt1 = xpos_player1;
            ypos_nxt1 = ypos_player1;
            ypos_nxt2 = ypos_player2;
        end
        default: begin
            state_nxt = IDLE;
            xpos_nxt1 = xpos_player1;
            ypos_nxt1 = ypos_player1;
            xpos_nxt2 = xpos_player2;
            ypos_nxt2 = ypos_player2;
        end
    endcase
end

endmodule