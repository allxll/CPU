module ALU_adder (
	input wire [31:0] A,
	input wire [31:0] B,
	input wire ALUFun_0,
	input wire Sign,
	output wire Z,
	output wire V,
	output wire N,
	output wire [31:0] S
);

wire [31:0] XB;
wire [7:0] Z1;
wire [1:0] Z2;

buf (ALUFun0, ALUFun_0);
assign XB = B ^ {32{ALUFun0}};
assign Z = ~ (A[31:0] ^ B[31:0]);
assign S[31:0] = A[31:0] + XB[31:0] + ALUFun0;
assign V = Sign ? (A[31] & B[31] & ~S[31]) | (~A[31] & ~B[31] & S[31])
				:0;
assign N = Sign ? S[31] : 0;


endmodule



