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
    input logic gpio_l,
    input logic gpio_r,
    input logic [11:0] xpos_player1,
    input logic [11:0] xpos_player2,
    output logic zero,

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

always_ff @(posedge clk) begin
    if(game_state == FINISH) begin
        zero <= '1;
    end else begin
        zero <= '0;
    end
end


always_comb begin
    case(game_state)
        START: begin
            if(m_right || gpio_r) begin
                game_state_nxt = LEVEL_1;
            end
            else begin
                game_state_nxt = START;
            end
        end
        LEVEL_1: begin
            if(xpos_player1 >= 930 && xpos_player2 >= 930) begin
                game_state_nxt = FINISH;
            end else begin
                game_state_nxt = LEVEL_1;
            end
        end
        FINISH: begin
            if(m_left || gpio_l) begin
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