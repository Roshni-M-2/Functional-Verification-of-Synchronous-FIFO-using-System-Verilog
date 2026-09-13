import fifo_pkg::*;

class env;
  virtual fifo_if vif;
  generator gen;
  driver    drv;
  monitor   mon;
  scoreboard sb;
  mailbox #(transaction) gen2driv;
  mailbox #(transaction) mon2sc;

  function new(virtual fifo_if vif);
    this.vif = vif;
    gen2driv = new();
    mon2sc   = new();
    gen = new(gen2driv);
    drv = new(vif, gen2driv);
    mon = new(vif, mon2sc);
    sb  = new(mon2sc);
  endfunction

  task main();
    drv.reset();
    fork
      gen.main();
      drv.main(TOTAL_TXNS);
      mon.main(TOTAL_TXNS);
      sb.main(TOTAL_TXNS);
    join
  endtask
endclass