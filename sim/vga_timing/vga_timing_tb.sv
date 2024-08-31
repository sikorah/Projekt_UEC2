/**
 *  Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Testbench for vga_timing module.
 */

`timescale 1 ns / 1 ps

module vga_timing_tb;

import vga_pkg::*;


localparam CLK_PERIOD = 25;     // 40 MHz


logic clk;
logic rst;

vga_if timing_out();


initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end



initial begin
                       rst = 1'b0;
    #(1.25*CLK_PERIOD) rst = 1'b1;
                       rst = 1'b1;
    #(2.00*CLK_PERIOD) rst = 1'b0;
end

vga_timing dut(
    .clk,
    .rst,
    .vga_out(timing_out.out)
);


 task counter_test (input  [10:0] count,  input  [10:0]  max_val,  input  string name);
    begin
        assert(count <= max_val) else $error("%s higher than %d", name,  max_val);
    end
 endtask

 property vcounter_synchronization;
    @(posedge clk) disable iff ($realtime < 4 * CLK_PERIOD)
    (timing_out.hcount ==  HCNT_MAX && timing_out.vcount== VCNT_MAX) |=> (timing_out.vcount == 0);
 endproperty

 property hsync_start;
    @(posedge clk) disable iff ($realtime < 4 * CLK_PERIOD)
    (timing_out.hcount ==  HSYNC_START-1 ) |=> (timing_out.hsync == 1);
 endproperty

 property hsync_stop;
    @(posedge clk) disable iff ($realtime < 4 * CLK_PERIOD)
    (timing_out.hcount ==  HSYNC_STOP) |=> (timing_out.hsync == 0);
 endproperty

 property hblnk_start;
    @(posedge clk) disable iff ($realtime < 4 * CLK_PERIOD)
    (timing_out.hcount ==  HBLK_START-1) |=> (timing_out.hblnk == 1);
 endproperty

 property hblnk_stop;
    @(posedge clk) disable iff ($realtime < 4 * CLK_PERIOD)
    (timing_out.hcount ==  HBLK_STOP) |=> (timing_out.hblnk == 0);
 endproperty

 //VERTICAL PROPERTY

 property vsync_start;
    @(posedge clk) disable iff ($realtime < 4 * CLK_PERIOD)
    (timing_out.hcount ==  HCNT_MAX && timing_out.vcount ==  VSYNC_START-1) |=> (timing_out.vsync == 1);
 endproperty
 
 property vsync_stop;
    @(posedge clk) disable iff ($realtime < 4 * CLK_PERIOD)
    (timing_out.hcount ==  HCNT_MAX && timing_out.vcount ==  VSYNC_STOP) |=> (timing_out.vsync == 0);
 endproperty

 property vblnk_start;
    @(posedge clk) disable iff ($realtime < 4 * CLK_PERIOD)
    (timing_out.hcount ==  HCNT_MAX && timing_out.vcount ==  VBLK_START-1) |=> (timing_out.vblnk == 1);
 endproperty
 
 property vblnk_stop;
    @(posedge clk) disable iff ($realtime < 4 * CLK_PERIOD)
    (timing_out.hcount ==  HCNT_MAX && timing_out.vcount ==  VBLK_STOP) |=> (timing_out.vblnk == 0);
 endproperty

/**
 * Main test
 */
always begin
    #(4*CLK_PERIOD)
    counter_test(timing_out.hcount, HCNT_MAX, "Horizontal Counter");
    counter_test(timing_out.vcount, VCNT_MAX, "Vertical Counter");
 end

assert property (vcounter_synchronization) else $error("vcounter reset not synchronized time=%t", $realtime);
assert property (hsync_start) else $error("timing_out.hsync start not synchronized time=%t", $realtime);
assert property (hsync_stop) else $error("timing_out.hsync stop not synchronized time=%t", $realtime);

assert property (hblnk_start) else $error("timing_out.hblnk start not synchronized time=%t", $realtime);
assert property (hblnk_stop) else $error("timing_out.hblnk stop not synchronized time=%t", $realtime);

assert property (vsync_start) else $error("timing_out.vsync start not synchronized time=%t", $realtime);
assert property (vsync_stop) else $error("timing_out.vsync stop not synchronized time=%t", $realtime);

assert property (vblnk_start) else $error("timing_out.vblnk start not synchronized time=%t", $realtime);
assert property (vblnk_stop) else $error("timing_out.vblnk stop not synchronized time=%t", $realtime);
  
initial begin
    $timeformat(-3, 5, "ms");
    @(posedge rst);
    @(negedge rst);

    wait (timing_out.vsync == 1'b0);
    @(negedge timing_out.vsync)
    @(negedge timing_out.vsync)

    $finish;
end

endmodule
