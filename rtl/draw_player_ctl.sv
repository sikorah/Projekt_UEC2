`include "state_pkg.sv"

module draw_player_ctl (
    input logic rst,
    input logic v_tick,
    input logic clk,
    input logic [7:0] result,
    output logic [11:0] player_xpos,
    output logic [11:0] player_ypos
);

import state_pkg::*;

State state, state_nxt;
logic [11:0] player_xpos_nxt, player_ypos_nxt;
logic v_tick_old;

always_ff @(posedge clk) begin
    if (rst) begin
        state   <= IDLE;
        player_xpos    <= 0;
        player_ypos    <= 0;
    end else begin
        v_tick_old <= v_tick;
        if (v_tick && !v_tick_old) begin
            state   <= state_nxt;
            player_xpos    <= player_xpos_nxt;
            player_ypos    <= player_ypos_nxt;
        end
    end
end

always_comb begin
    player_xpos_nxt = player_xpos;
    player_ypos_nxt = player_ypos;
    state_nxt = state; // Domyślne przypisanie bieżącego stanu

    case (state)
        IDLE: begin
            if (result==8'h23) begin
                state_nxt = RIGHT;
            end else if (result==8'h1C) begin
                state_nxt = LEFT;
            end else begin
                state_nxt = IDLE;
            end
        end
        RIGHT: begin
            if (player_xpos < 0) begin
                player_xpos_nxt = player_xpos + 1;
            end else begin
                state_nxt = IDLE;
            end
        end
        LEFT: begin
            if (player_xpos > 756) begin
                player_xpos_nxt = player_xpos - 1;
            end else begin
                state_nxt = IDLE;
            end
        end
        default: begin
            state_nxt = IDLE;
        end
    endcase
end


endmodule
