interface RCA_interface (input clk);
  
  //input
  logic [15:0] A, B;
  logic Cin;
  //output
  logic [15:0] S;
  logic Cout;
 
  
  //driver block
  clocking driver_cb @(negedge clk);
    default input #3 output #2;
    output A,B,Cin;
  endclocking
  
  //monitor block 
  clocking monitor_cb @(posedge clk);
    default input #3 output #2;
    input A,B,Cin,S,Cout;
  endclocking
  
  modport DRIVER(clocking driver_cb, input clk);
  modport MONITOR(clocking monitor_cb, input clk);
    
endinterface
    