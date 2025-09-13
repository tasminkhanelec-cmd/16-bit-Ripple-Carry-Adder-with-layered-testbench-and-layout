class driver;
  
  //this class first recieves the mail from gen, then drives output signal based on the mail, puts the mail out for sb and raises a flag.
  mailbox #(transaction) gen2driv, driv2sb;
  virtual RCA_interface.DRIVER vRCA;
  transaction d_trans;
  event driven;
  
  
  function new(mailbox #(transaction) gen2driv, driv2sb, virtual RCA_interface.DRIVER vRCA, event driven);
    this.gen2driv = gen2driv;
    this.driv2sb = driv2sb;
    this.vRCA = vRCA; 
    this.driven = driven;
  endfunction
  
  
  task main(input int count);
    
    repeat(count) begin
      d_trans = new();
      gen2driv.get(d_trans);
      
      @(vRCA.driver_cb);
      vRCA.driver_cb.A <= d_trans.A;
      vRCA.driver_cb.B <= d_trans.B;
      vRCA.driver_cb.Cin <= d_trans.Cin;
      
      driv2sb.put(d_trans);
      ->driven;
    end
    
  endtask
endclass