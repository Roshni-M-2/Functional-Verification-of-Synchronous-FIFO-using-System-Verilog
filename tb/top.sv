`timescale 1ns / 1ps
import fifo_pkg::*;

module top;
  bit clk;
  always #5 clk = ~clk;

  fifo_if #(.DATA_WIDTH(DATA_WIDTH)) vif(clk);

  synchronous_fifo #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH)) dut (
    .clk      (clk),
    .rst_n    (vif.rst_n),
    .wr_en    (vif.wr_en),
    .rd_en    (vif.rd_en),
    .data_in  (vif.data_in),
    .data_out (vif.data_out),
    .full     (vif.full),
    .empty    (vif.empty)
  );

  test t(vif);
endmodule
