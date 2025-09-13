class scoreboard;
  
  mailbox #(transaction) driv2sb;
  mailbox #(transaction) mon2sb;
  transaction d_trans;
  transaction m_trans;
  
  function new(mailbox #(transaction) driv2sb, mailbox #(transaction) mon2sb);
    this.driv2sb = driv2sb;
    this.mon2sb = mon2sb;
  endfunction
  
  task main(input int count);
    $display("---Scoreboard Test Starts-----------");
    repeat(count) begin
      infer();
      m_trans = new();
      mon2sb.get(m_trans);
      report();
    end
    $display("------Scoreboard Test Ends-----------------");
  endtask: main
  
  task infer();
    d_trans = new();
    driv2sb.get(d_trans);
    {d_trans.Cout, d_trans.S} = d_trans.A + d_trans.B + d_trans.Cin;
  endtask
  
  
  task report();
    if ((m_trans.S != d_trans.S) || (m_trans.Cout != d_trans.Cout)) begin
      $display("Failed: A=%d + B=%d + Cin=%d = Cout=%d + S=%d  Expected out = Cout=%d + S=%d ", d_trans.A, d_trans.B, d_trans.Cin, m_trans.Cout, m_trans.S, d_trans.Cout, d_trans.S);
    end
    
  endtask: report
endclass: scoreboard