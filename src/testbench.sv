`include "environment.sv"
`include "interface.sv"

module testbench;
  
  bit clk;
  
  always #10 clk = ~clk;

  int count = `test_case_count;
  RCA_interface realRCA(clk);
  //test test01(count, realRCA); //passing the interface to the testclass
  environment env;
  
  initial begin
    transaction testcase01handle;
    testcase01handle = new();
    
    env = new(realRCA);
    env.gen.custom_trans = testcase01handle;
    env.main(count);
  end
    
  
  
  
  RippleCarryAdder #(`N) DUT(//here passing the dut connections to the interface
    .A(realRCA.A),
    .B(realRCA.B),
    .Cin(realRCA.Cin),
    .S(realRCA.S),
    .Cout(realRCA.Cout)
  );
  
  
  covergroup RCA_coverage;
    option.per_instance = 1;
    a: coverpoint realRCA.A {
      bins all_values[`bin_count] = {[0:(2**`N)-1]};
    }
    
    b: coverpoint realRCA.B {
      bins all_values[`bin_count] = {[0:(2**`N)-1]};
    }
    
    c: coverpoint realRCA.Cin {
      bins bin_0 = {0};                          
      bins bin_1 = {1};  
    }
    
    //total: cross realRCA.A, realRCA.B, realRCA.Cin; 
    total: cross a, b, c;
    //{
    //  bins all_values[`bin_count] = {[]};
    //}
  endgroup
      
  
  
  RCA_coverage cg;
  initial begin
    cg = new();
  end
  
  always @(posedge clk) begin;
    cg.sample();
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  
  final begin
    $display("Coverage Results:");
    //$display("Total Coverage: %f%% with %0d test combinations", cg.get_coverage(), count);
    
    $display("Coverpoint A, B, cross, case, penalty: %0.2f, %0.2f, %0d, %0d, %0d", cg.a.get_inst_coverage(), cg.b.get_inst_coverage(), `test_case_count, `penalty, `DEFAULT_WEIGHT);
    //$display("Coverpoint B Coverage: %0.2f", cg.b.get_inst_coverage());
    //$display("Coverpoint Cin Coverage: %0.2f%%", cg.c.get_inst_coverage());
    //$display("Cross Coverage (all): %0.2f", cg.total.get_inst_coverage());
  end
  
endmodule
  