module ALU_adder (
	input [31:0] A,
	input [31:0] B,
	input ALUFun_0,
	input Sign,
	output Z,
	output V,
	output N,
	output [31:0] S
);

wire [31:0] XB;
wire ALUFun0;

buf BUF(ALUFun0, ALUFun_0);
wire na, nb, ns, ya, yb, ys;


assign XB = B ^ {32{ALUFun0}};
assign Z =  ~| (A[31:0] ^ B[31:0]);

//assign S[31:0] = A[31:0] + XB[31:0] + ALUFun0;

good_adder GA(A, XB, ALUFun0, S);

wire V1, V2, V_sign;
nand (V1, A[31], XB[31], ~S[31]);
nand (V2, ~A[31], ~XB[31], S[31]);
nand (V_sign, V1, V2);

assign V = Sign ? V_sign : 0;
//assign V = Sign ? (A[31] & XB[31] & ~S[31]) | (~A[31] & ~XB[31] & S[31])
//				:0;

wire N1, N2, N3, N_notsign;
nand (N1, ~A[31], B[31]);
nand (N2, B[31], S[31]);
nand (N3, ~A[31], S[31]);
nand (N_notsign, N1, N2, N3);

assign N = Sign ? S[31] : N_notsign;

//assign N = Sign ? S[31] : 
		//(~A[31] & B[31]) | (B[31] & S[31]) | (~A[31] & S[31]);


endmodule



