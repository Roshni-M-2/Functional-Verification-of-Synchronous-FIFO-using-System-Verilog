import fifo_pkg::*;

class driver;
  virtual fifo_if vif;
  mailbox #(transaction) gen2driv;
  transaction trans;

  function new(virtual fifo_if vif, mailbox #(transaction) gen2driv);
    this.vif = vif;
    this.gen2driv = gen2driv;
  endfunction

  task reset();
    vif.rst_n   <= 0;
    vif.wr_en   <= 0;
    vif.rd_en   <= 0;
    vif.data_in <= 0;
    repeat (5) @(negedge vif.clk);
    vif.rst_n <= 1;
    @(posedge vif.clk);
    $display("[DRIVER] Reset complete");
  endtask

  task main(input int num_txns);
    repeat (num_txns) begin
      gen2driv.get(trans);
      @(negedge vif.clk);
      vif.wr_en   <= trans.wr_en;
      vif.rd_en   <= trans.rd_en;
      vif.data_in <= trans.data_in;
      trans.disp("DRIVER");
    end
  endtask
endclass