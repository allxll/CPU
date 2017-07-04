module ALU_adder (
	input reg [31:0] A;
	input reg [31:0] B;
	input reg ALUFun_0;
	output reg Z;
	output reg V;
	output reg N;
	output wire [31:0] S;
);

wire [31:0] XB;
wire [7:0] Z1;
wire [1:0] Z2;

buf (ALUFun0, ALUFun_0);
nor	n1(XB[0], ALUFun0, B[0]);
nor	n2(XB[1], ALUFun0, B[1]);
nor	n3(XB[2], ALUFun0, B[2]);
nor	n4(XB[3], ALUFun0, B[3]);
nor	n5(XB[4], ALUFun0, B[4]);
nor	n6(XB[5], ALUFun0, B[5]);
nor	n7(XB[6], ALUFun0, B[6]);
nor	n8(XB[7], ALUFun0, B[7]);
nor	n9(XB[8], ALUFun0, B[8]);
nor	n10(XB[9], ALUFun0, B[9]);
nor	n11(XB[10], ALUFun0, B[10]);
nor	n12(XB[11], ALUFun0, B[11]);
nor	n13(XB[12], ALUFun0, B[12];
nor	n14(XB[13], ALUFun0, B[13];
nor	n15(XB[14], ALUFun0, B[14];
nor	n16(XB[15], ALUFun0, B[15];
nor	n17(XB[16], ALUFun0, B[16];
nor	n18(XB[17], ALUFun0, B[17];
nor	n19(XB[18], ALUFun0, B[18];
nor	n20(XB[19], ALUFun0, B[19];
nor	n21(XB[20], ALUFun0, B[20]);
nor	n22(XB[21], ALUFun0, B[21]);
nor	n23(XB[22], ALUFun0, B[22]);
nor	n24(XB[23], ALUFun0, B[23]);
nor	n25(XB[24], ALUFun0, B[24]);
nor	n26(XB[25], ALUFun0, B[25]);
nor	n27(XB[26], ALUFun0, B[26]);
nor	n28(XB[27], ALUFun0, B[27]);
nor	n29(XB[28], ALUFun0, B[28]);
nor	n30(XB[29], ALUFun0, B[29]);
nor	n31(XB[30], ALUFun0, B[30]);
nor	n32(XB[31], ALUFun0, B[31]);

assign Z = ~ (A[31:0] ^ B[31:0]);
assign S[31:0] = A[31:0] + XB[31:0] + ALUFun0;
assign V = (XA[31] & B[31] & ~S[31]) | (~XA[31] & ~B[31] & S[31]);
assign N = S[31];


endmodule



