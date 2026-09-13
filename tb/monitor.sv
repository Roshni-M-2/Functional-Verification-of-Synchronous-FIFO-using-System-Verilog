import fifo_pkg::*;

class monitor;
  virtual fifo_if vif;
  mailbox #(transaction) mon2sc;
  transaction trans;
  bit prev_full, prev_empty;

  covergroup cg with function sample(input bit wr_en, input bit rd_en, input bit full, input bit empty,
                                     input bit was_full, input bit was_empty);
    option.per_instance = 1;
    cp_wr        : coverpoint wr_en;
    cp_rd        : coverpoint rd_en;
    cp_full      : coverpoint full;
    cp_empty     : coverpoint empty;
    cp_was_full  : coverpoint was_full;
    cp_was_empty : coverpoint was_empty;

    cx_write_when_full : cross cp_wr, cp_was_full;   // catches the overflow boundary case
    cx_read_when_empty : cross cp_rd, cp_was_empty;  // catches the underflow boundary case
    cx_simultaneous_rw : cross cp_wr, cp_rd;         // catches read+write same cycle
  endgroup

  function new(virtual fifo_if vif, mailbox #(transaction) mon2sc);
    this.vif = vif;
    this.mon2sc = mon2sc;
    cg = new();
    prev_full  = 0;
    prev_empty = 1;  // FIFO starts empty right after reset
  endfunction

  task main(input int num_txns);
    repeat (num_txns) begin
      @(negedge vif.clk);
      trans = new();
      trans.wr_en    = vif.wr_en;
      trans.rd_en    = vif.rd_en;
      trans.data_in  = vif.data_in;
      trans.data_out = vif.data_out;
      trans.full     = vif.full;
      trans.empty    = vif.empty;
      trans.disp("MONITOR");

      cg.sample(trans.wr_en, trans.rd_en, trans.full, trans.empty, prev_full, prev_empty);
      prev_full  = trans.full;
      prev_empty = trans.empty;

      mon2sc.put(trans);
    end
  endtask
endclass