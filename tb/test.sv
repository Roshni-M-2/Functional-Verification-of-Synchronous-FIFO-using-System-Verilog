import fifo_pkg::*;

program automatic test(fifo_if vif);
  env ev;
  initial begin
    ev = new(vif);
    ev.main();
    $display("[TEST] Simulation complete");
  end
endprogram