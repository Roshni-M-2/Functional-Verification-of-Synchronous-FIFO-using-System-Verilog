import fifo_pkg::*;

class scoreboard;
  mailbox #(transaction) mon2sc;
  transaction trans;

  bit [DATA_WIDTH-1:0] exp_q[$];
  int pass_cnt, fail_cnt;

  function new(mailbox #(transaction) mon2sc);
    this.mon2sc = mon2sc;
    pass_cnt = 0;
    fail_cnt = 0;
  endfunction

  task main(input int num_txns);
    bit exp_full_before, exp_empty_before, exp_full_after, exp_empty_after;
    bit [DATA_WIDTH-1:0] popped;
    bit err;

    repeat (num_txns) begin
      mon2sc.get(trans);
      err = 0;
      exp_full_before  = (exp_q.size() == DEPTH);
      exp_empty_before = (exp_q.size() == 0);

      if (trans.wr_en && !exp_full_before)
        exp_q.push_back(trans.data_in);

      if (trans.rd_en && !exp_empty_before) begin
        popped = exp_q.pop_front();
        if (popped !== trans.data_out) begin
          $display("[SCOREBOARD] FAIL: data mismatch expected=%0d actual=%0d", popped, trans.data_out);
          err = 1;
        end
      end

      exp_full_after  = (exp_q.size() == DEPTH);
      exp_empty_after = (exp_q.size() == 0);

      if (exp_full_after !== trans.full) begin
        $display("[SCOREBOARD] FAIL: full mismatch expected=%0b actual=%0b", exp_full_after, trans.full);
        err = 1;
      end
      if (exp_empty_after !== trans.empty) begin
        $display("[SCOREBOARD] FAIL: empty mismatch expected=%0b actual=%0b", exp_empty_after, trans.empty);
        err = 1;
      end

      if (!err) begin
        pass_cnt++;
        $display("[SCOREBOARD] PASS: wr_en=%0b rd_en=%0b data_out=%0d full=%0b empty=%0b",
                   trans.wr_en, trans.rd_en, trans.data_out, trans.full, trans.empty);
      end else fail_cnt++;
    end

    $display("========================================");
    $display(" SCOREBOARD SUMMARY : PASS=%0d  FAIL=%0d", pass_cnt, fail_cnt);
    $display("========================================");
  endtask
endclass