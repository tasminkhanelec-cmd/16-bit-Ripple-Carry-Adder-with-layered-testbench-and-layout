module RippleCarryAdder #(parameter int N=16) (
    input logic [N-1:0] A,
    input logic [N-1:0] B,
    input logic Cin,
    output logic [N-1:0] S,
    output logic Cout
);
    logic [N-1:0] C;

    genvar i;
    generate
        for (i = 0; i < N; i++) begin
            if (i == 0)
                fulladder f(.a(A[0]), .b(B[0]), .cin(Cin), .s(S[0]), .co(C[0]));
            else
                fulladder f(.a(A[i]), .b(B[i]), .cin(C[i-1]), .s(S[i]), .co(C[i]));
        end
    endgenerate

    assign Cout = C[N-1];
  
endmodule

module fulladder(
    input logic a, b, cin,
    output logic s, co
);
    logic p, g;

    assign p = a ^ b;
    assign g = a & b;
    assign s = p ^ cin;
    assign co = g | (p & cin);

endmodule
