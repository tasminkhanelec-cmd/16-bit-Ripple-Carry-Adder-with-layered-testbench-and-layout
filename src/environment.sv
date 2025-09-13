`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
  mailbox #(transaction) gen2driv;
  mailbox #(transaction) driv2sb;
  mailbox #(transaction) mon2sb;
  
  generator gen;
  driver driv;
  monitor mon;
  scoreboard scb;
  
  event driven;
  
  virtual RCA_interface vRCA;
  
  function new(virtual RCA_interface vRCA);
    this.vRCA = vRCA;
    gen2driv = new();
    driv2sb = new();
    mon2sb = new();
    
    gen = new(gen2driv);
    driv = new(gen2driv, driv2sb, vRCA.DRIVER, driven);
    mon = new(mon2sb, vRCA.MONITOR, driven);
    scb = new(driv2sb, mon2sb);
  endfunction
  
  task main(input int count);
    fork 
      gen.main(count);
      driv.main(count);
      mon.main(count);
      scb.main(count);
    join
    $finish;
  endtask
  
endclass