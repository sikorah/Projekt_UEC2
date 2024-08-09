`timescale 1 ns / 1 ps

module rect_ctl_tb;

/**
 *  Local parameters
 */

localparam CLK40_PERIOD = 25;     // 40 MHz
localparam CLK100_PERIOD = 10;     // 40 MHz

/**
 * Local variables and signals
 */

logic clk40,clk100, rst;
wire vs, hs;
wire [3:0] r, g, b;


/**
 * Clock generation
 */

initial begin
    clk40 = 1'b0;
    clk100= 1'b0;
    fork
        forever #(CLK40_PERIOD/2) clk40 = ~clk40;
        forever #(CLK100_PERIOD/2) clk100 = ~clk100;
    join
end


/**
 * Submodules instances
 */

top_vga dut (
    .clk40(clk40),
    .clk100(clk100),
    .rst(rst),
    .vs(vs),
    .hs(hs),
    .r(r),
    .g(g),
    .b(b)
);

tiff_writer #(
    .XDIM(16'd1056),
    .YDIM(16'd628),
    .FILE_DIR("../../results")
) u_tiff_writer (
    .clk(clk40),
    .r({r,r}), // fabricate an 8-bit value
    .g({g,g}), // fabricate an 8-bit value
    .b({b,b}), // fabricate an 8-bit value
    .go(vs)
);


/**
 * Main test
 */

initial begin
    rst = 1'b0;
    # 30 rst = 1'b1;
    # 30 rst = 1'b0;

    force dut.m_left=1;

    wait (vs == 1'b0);
    @(negedge vs) $display("velocity_f %d | ynxt %d | ypos %d | velocity %f ",draw_rect_ctl.velocity[7:4], draw_rect_ctl.ypos_nxt, draw_rect_ctl.ypos,draw_rect_ctl.velocity);

    //force dut.m_left=1;

    wait (vs == 1'b0);
    @(negedge vs) $display("velocity_f %d | ynxt %d | ypos %d | velocity %f ",draw_rect_ctl.velocity[7:4], draw_rect_ctl.ypos_nxt, draw_rect_ctl.ypos,draw_rect_ctl.velocity);

    //force dut.m_left=0;
    repeat(5) begin
        wait (vs == 1'b0);
        @(negedge vs) $display("velocity_f %d | ynxt %d | ypos %d | velocity %f ",draw_rect_ctl.velocity[7:4], draw_rect_ctl.ypos_nxt, draw_rect_ctl.ypos,draw_rect_ctl.velocity);
    end
    
    @(negedge vs) $finish;
end

endmodule