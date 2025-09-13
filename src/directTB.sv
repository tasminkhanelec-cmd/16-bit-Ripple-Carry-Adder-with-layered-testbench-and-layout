// Code your testbench here
// or browse Examplejavascript:void(0)s
module RippleCarryAdder_tb ();
  parameter N=16;
  parameter j= 10;
  logic [N-1:0] A = 2'b0, B =2'b0;
  logic Cin=0;
  wire [N-1:0] S;
  wire Cout;

  RippleCarryAdder DUT(.A(A),
                       .B(B), 
                       .Cin(Cin),
                       .S(S), 
                       .Cout(Cout));

  initial begin
    Cin=0;
    repeat(5) begin
      A=$random;
      B=$random;
      #10;
      {A,B} = {A,B} + 1;
    end
  	Cin=1;
    repeat(5) begin
      A=$random;
      B=$random;
      #10;
      {A,B} = {A,B} + 1;
    end

  initial begin
  	$dumpfile("RippleCarryAdder.vcd");
  	$dumpvars(0,RippleCarryAdder_tb);
    $monitor($time, ": %d + %d + %d = %d, %d", A, B, Cin, Cout, S);
  	#320;
  	$finish;
	end

endmodule
