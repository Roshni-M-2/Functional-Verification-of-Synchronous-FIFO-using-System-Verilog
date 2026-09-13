import fifo_pkg::*;

class transaction;
  rand op_e op;
  rand bit [DATA_WIDTH-1:0] data_in;

  bit wr_en, rd_en;
  bit [DATA_WIDTH-1:0] data_out;
  bit full, empty;

  constraint op_dist_c {
    op dist { IDLE := 5, WRITE := 40, READ := 40, READ_WRITE := 15 };
  }

  function void configure();
    case (op)
      IDLE       : begin wr_en = 0; rd_en = 0; end
      WRITE      : begin wr_en = 1; rd_en = 0; end
      READ       : begin wr_en = 0; rd_en = 1; end
      READ_WRITE : begin wr_en = 1; rd_en = 1; end
      default    : begin wr_en = 0; rd_en = 0; end // unreachable: op_e is fully enumerated
    endcase
  endfunction

  function void post_randomize();
    configure();
  endfunction

  function void disp(input string tag);
    $display("[%0s] wr_en=%0b rd_en=%0b data_in=%0d data_out=%0d full=%0b empty=%0b",
              tag, wr_en, rd_en, data_in, data_out, full, empty);
  endfunction
endclass
