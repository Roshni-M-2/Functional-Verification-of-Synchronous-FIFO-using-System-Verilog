`timescale 1ns / 1ps

package fifo_pkg;
  localparam int DEPTH           = 8;
  localparam int DATA_WIDTH      = 8;
  localparam int NUM_RANDOM_TXNS = 200;
  localparam int TOTAL_TXNS      = (6*DEPTH) + 4 + NUM_RANDOM_TXNS;

  typedef enum bit [1:0] {IDLE, WRITE, READ, READ_WRITE} op_e;
endpackage