function bit check_all_weights_min();
    foreach (A_weights[i]) begin
      if (A_weights[i] != 0)
            return 0;
    end
    foreach (B_weights[i]) begin
      if (B_weights[i] != 0)
            return 0;
    end
    return 1;
endfunction


function void reset_weights();
    A_weights = '{default: `DEFAULT_WEIGHT};
    B_weights = '{default: `DEFAULT_WEIGHT};
endfunction

//------------------------------------------------------------


function void pre_randomize();
    int index_A;
    int index_B;
    
    // Skip adjustment if A or B is uninitialized
    if ((A === 'x || A === 'z) || (B === 'x || B === 'z)) begin
        return;
    end

    // Determine which range the current value falls into
    for (int i = 0; i < 1024; i++) begin
        if (A >= i * 64 && A < (i + 1) * 64) begin
            index_A = i;
            break;
        end
    end

    for (int i = 0; i < 1024; i++) begin
        if (B >= i * 64 && B < (i + 1) * 64) begin
            index_B = i;
            break;
        end
    end

  if (A_weights[index_A] >= `penalty) begin
      A_weights[index_A] -=`penalty; end
  else if (A_weights[index_A] !=0) begin
	A_weights[index_A] =0; end
   if (B_weights[index_B] >= `penalty) begin
        B_weights[index_B] -= `penalty; end
   else if (B_weights[index_B] !=0) begin
	B_weights[index_B] =0; end

    // Check if all weights are 1 or less, reset if true
    if (check_all_weights_min()) begin
        reset_weights();
    end
  
 endfunction 
    /* $display("Penalty: %0d", `penalty);
$display("Index_A: %0d, A_weights[%0d]: %0d", index_A, index_A, A_weights[index_A]);
  $display("Index_B: %0d, B_weights[%0d]: %0d", index_B, index_B, B_weights[index_B]);*/


