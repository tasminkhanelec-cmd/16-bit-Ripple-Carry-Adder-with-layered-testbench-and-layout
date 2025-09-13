`include "paramsmacro.svh"

class transaction;
  
  rand bit [`N-1:0] A;
  rand bit [`N-1:0] B;
  rand bit Cin;
  bit [`N-1:0] S;
  bit Cout;
  
  
  int unsigned A_weights[0:1023]; 
  int unsigned B_weights[0:1023]; 
  
  function new();
    A_weights = '{default: `DEFAULT_WEIGHT};
    B_weights = '{default: `DEFAULT_WEIGHT};
  endfunction
  
  `include "randomization.svh"
  `include "consss.svh"
  

endclass



