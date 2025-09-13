class monitor;
  
  mailbox #(transaction) mon2sb;
  virtual RCA_interface.MONITOR vRCA;
  transaction m_trans;
  event driven;
  
  function new(mailbox #(transaction) mon2sb, virtual RCA_interface.MONITOR vRCA, event driven);
    this.mon2sb = mon2sb;
    this.vRCA = vRCA;
    this.driven = driven;
  endfunction
               
  task main(input int count);
    //@(driven);
    //@(vRCA.monitor_cb);
    repeat(count) begin
      m_trans = new();
      //@(posedge vRCA.clk);
      @(driven);
      @(vRCA.monitor_cb);
      m_trans.Cout = vRCA.monitor_cb.Cout;
      m_trans.S = vRCA.monitor_cb.S;
      mon2sb.put(m_trans);
    end
  endtask       
 endclass
               
    
                 