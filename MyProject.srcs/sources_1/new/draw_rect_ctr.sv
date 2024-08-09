typedef enum bit [1:0] { IDLE, FALL, BOUNCE} State;

module draw_rect_ctl
    (
        input logic  rst,
        input logic v_tick,
        input logic clk,
        input logic mouse_left,
        input logic [11:0] mouse_xpos,
        input logic [11:0] mouse_ypos,
        output logic [11:0] xpos,
        output logic [11:0] ypos
    );
    import vga_pkg::*;
localparam accelaration=8'b1001_1100;//9.8
State  state,state_nxt;
logic [7:0] vel_ver ,vel_ver_nxt  ,vel_hor, vel_hor_nxt;
logic [11:0] xpos_nxt, ypos_nxt;
logic v_tick_old;

always_ff @(posedge clk) begin
    if(rst) begin
        state           <= IDLE;
        vel_ver        <= '0;
        xpos            <= mouse_xpos;
        ypos            <= mouse_ypos;

    end else begin
        v_tick_old <= v_tick;
        if (v_tick && !v_tick_old) begin
            state           <= state_nxt;
            vel_ver        <= vel_ver_nxt;
            vel_hor        <= vel_hor_nxt;
            xpos            <= xpos_nxt;
            ypos            <= ypos_nxt;
        end

    end
end
always_comb begin
    case(state)
        IDLE:   state_nxt = mouse_left ? FALL : IDLE;
        FALL:   state_nxt = (ypos>= VER_PIXELS-IMG_H) ? BOUNCE:FALL;
        BOUNCE:   state_nxt = (ypos >=10) ? IDLE:BOUNCE;

    endcase
end

always_comb begin
    case(state)
        IDLE: begin
            xpos_nxt = mouse_xpos;
            ypos_nxt = mouse_ypos;
            vel_ver_nxt=1;
            vel_hor_nxt=0;
        end
        FALL: begin
            xpos_nxt = xpos;
            ypos_nxt = ypos + vel_ver[7:4];
            vel_ver_nxt = vel_ver + accelaration;
            vel_hor_nxt=0;

        end
        BOUNCE: begin
            xpos_nxt= xpos+ vel_hor[7:4];
            ypos_nxt = ypos - vel_ver[7:4];
            vel_ver_nxt= vel_ver - accelaration;
            vel_hor_nxt=vel_hor + accelaration;
        end

    endcase
end
endmodule