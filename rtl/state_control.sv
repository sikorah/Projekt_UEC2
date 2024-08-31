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
    input logic clk_40,
    input logic rst,
    input logic m_left,
    input logic xpos_mouse,
    input logic ypos_mouse,
    input logic ypos_player,

    output g_state game_state
);

g_state game_state_nxt;

always_ff @(posedge clk_40) begin
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
            if(m_left /*&& ypos_mouse >= 250 && ypos_mouse<= 320 && xpos_mouse >= 160 && xpos_mouse <= 650*/) begin
                game_state_nxt = LEVEL_1;
            end
            else begin
                game_state_nxt = START;
            end
        end
        LEVEL_1: begin
            if(ypos_player >= 500) begin
                game_state_nxt = FINISH;
            end else begin
                game_state_nxt = LEVEL_1;
            end
        end
        FINISH: begin
            if(rst) begin
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