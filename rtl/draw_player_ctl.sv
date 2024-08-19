`include "state_pkg.sv"

module draw_player_ctl (
    input logic rst,
    input logic v_tick,
    input logic clk,
    output logic [11:0] xpos,
    output logic [11:0] ypos
);

import state_pkg::*;

State state, state_nxt;
logic [11:0] xpos_nxt, ypos_nxt;
logic v_tick_old;

always_ff @(posedge clk) begin
    if (rst) begin
        state   <= IDLE;
        xpos    <= 0;
        ypos    <= 0;
    end else begin
        v_tick_old <= v_tick;
        if (v_tick && !v_tick_old) begin
            state   <= state_nxt;
            xpos    <= xpos_nxt;
            ypos    <= ypos_nxt;
        end
    end
end

always_comb begin
    xpos_nxt = xpos;
    ypos_nxt = ypos;
    state_nxt = state; // Domyślne przypisanie bieżącego stanu

    case (state)
        IDLE: begin
            if (/* warunek dla prawego ruchu */) begin
                state_nxt = RIGHT;
            end else if (/* warunek dla lewego ruchu */) begin
                state_nxt = LEFT;
            end else begin
                state_nxt = IDLE;
            end
        end
        RIGHT: begin
            if (xpos < /* maksymalna pozycja */) begin
                xpos_nxt = xpos + 1;
            end else begin
                state_nxt = IDLE;
            end
        end
        LEFT: begin
            if (xpos > /* minimalna pozycja */) begin
                xpos_nxt = xpos - 1;
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
