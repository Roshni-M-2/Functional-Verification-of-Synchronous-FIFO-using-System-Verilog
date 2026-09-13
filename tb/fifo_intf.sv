`timescale 1ns / 1ps

import fifo_pkg::*;

interface fifo_if #(parameter DATA_WIDTH = fifo_pkg::DATA_WIDTH) (
input bit clk
);
  logic rst_n;
  logic wr_en, rd_en;
  logic [DATA_WIDTH-1:0] data_in;
  logic [DATA_WIDTH-1:0] data_out;
  logic full, empty;
endinterface