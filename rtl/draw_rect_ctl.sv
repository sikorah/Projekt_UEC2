typedef enum bit [1:0] { IDLE, FALL, ELEVATE } State;

module draw_rect_ctl (
    input logic rst,
    input logic v_tick,
    input logic clk,
    output logic [11:0] xpos,
    output logic [11:0] ypos
);

State state, state_nxt;

logic [11:0] xpos_nxt, ypos_nxt;
logic v_tick_old;

always_ff @(posedge clk) begin
    if (rst) begin
        state   <= IDLE;
        xpos    <= 350;
        ypos    <= 350;
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
    xpos_nxt = xpos;  // X position remains constant
    ypos_nxt = ypos;

    case (state)
        IDLE: begin
            state_nxt = ELEVATE;
        end
        ELEVATE: begin
            if (ypos > 220)  // Move up to ypos 220 (370 - 150)
                ypos_nxt = ypos - 1;
            else
                state_nxt = FALL;
        end
        FALL: begin
            if (ypos < 370)  // Move back down to ypos 370
                ypos_nxt = ypos + 1;
            else
                state_nxt = IDLE;
        end
    endcase
end

endmodule
