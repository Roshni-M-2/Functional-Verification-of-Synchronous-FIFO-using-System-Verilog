import fifo_pkg::*;

class generator;
  mailbox #(transaction) gen2driv;
  transaction trans;

  function new(mailbox #(transaction) gen2driv);
    this.gen2driv = gen2driv;
  endfunction

  task push(input op_e o, input bit [DATA_WIDTH-1:0] d = 0);
    trans = new();
    trans.op = o;
    trans.data_in = d;
    trans.configure();
    trans.disp("GEN");
    gen2driv.put(trans);
  endtask

  task main();
  
    for (int i = 0; i < DEPTH; i++) 
        push(WRITE, 8'h00);
    repeat (DEPTH)
        push(READ);
    for (int i = 0; i < DEPTH; i++) 
        push(WRITE, 8'hFF);
    repeat (DEPTH) 
        push(READ);
    
    // fill FIFO completely (DEPTH writes)
    for (int i = 0; i < DEPTH; i++)
      push(WRITE, i);
   
   //read when full
    push(READ); 
   
    push(WRITE, 8'hFF);
    
    // simultaneous read+write while FULL — only read should succeed 
    push(READ_WRITE, 8'hAA);

    // drain remaining DEPTH-1 entries
    repeat (DEPTH - 1) push(READ);

    // read attempt while EMPTY — must be dropped
    push(READ);

    // simultaneous read+write while EMPTY — only write should succeed 
    push(READ_WRITE, 8'h55);

    // Random mixed traffic for general functional coverage
    repeat (NUM_RANDOM_TXNS) begin
      trans = new();
      assert(trans.randomize());
      trans.configure();
      trans.disp("GEN");
      gen2driv.put(trans);
    end
  endtask
endclass