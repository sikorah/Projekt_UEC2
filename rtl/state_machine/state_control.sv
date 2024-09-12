/**
 * Copyright (C) 2024  AGH University of Science and Technology
 * MTM UEC2
 * Author: Hubert Sikora
 *
 * Description:
 * Control for state of the game
 */

import vga_pkg::*;
import state_pkg::*;

module state_control(
    input logic clk,
    input logic rst,
    input logic m_left,
    input logic m_right,
    input logic gpio,
    input logic [11:0] xpos_player1,
    input logic [11:0] xpos_player2,

    output g_state game_state
);

g_state game_state_nxt;

always_ff @(posedge clk) begin
    if(rst) begin
        game_state <= START;
    end
    else begin
        game_state <= game_state_nxt;
    end
end

always_comb begin
    case(game_state)
        START: begin
            if(m_left || gpio) begin
                game_state_nxt = LEVEL_1;
            end
            else begin
                game_state_nxt = START;
            end
        end
        LEVEL_1: begin
            if(xpos_player1 >= 980 && xpos_player2 >= 980) begin
                game_state_nxt = FINISH;
            end else begin
                game_state_nxt = LEVEL_1;
            end
        end
        FINISH: begin
            if(m_right) begin
                game_state_nxt = START;
            end
            else begin
                game_state_nxt = FINISH;
            end
        end
        default: begin
            game_state_nxt = START;
        end
    endcase
end
    

endmodule