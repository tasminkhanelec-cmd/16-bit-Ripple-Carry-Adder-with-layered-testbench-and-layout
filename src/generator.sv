`include "transaction.sv"

class generator;
  mailbox #(transaction) gen2driv;
  transaction g_trans, custom_trans;
  transaction copy_trans;
  
  function new(mailbox #(transaction) gen2driv);
    this.gen2driv = gen2driv;
  endfunction
  
  task main(input int count);
    g_trans = new();
    g_trans = new custom_trans;
    
    repeat(count) begin
      void'(g_trans.randomize());
      
      copy_trans = new();
      copy_trans = new g_trans;

      gen2driv.put(copy_trans);
     
    end
    
  endtask
endclass
