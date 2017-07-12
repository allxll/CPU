// An implementation of carry lookhead adder.
module oai21 (
	input a1, 
	input a2, 
	input b,
	output c
);
assign c = ~ ((a1 | a2)  & b);
endmodule

module aoi21 (
	input a1, 
	input a2, 
	input b,
	output c
);
assign c = ~((a1 & a2) | b );
endmodule


module adder_module_A (
	input i_bit1,
	input i_bit2,
	input i_carry,
	output o_sum,
	output o_ng,
	output o_np
);

wire nbit1, nbit2, nc, a, b1, b2;
not (nbit1, i_bit1);
not (nbit2, i_bit2);
not (nc, i_carry);

nor (o_np, i_bit1, i_bit2);
nand (o_ng, i_bit1, i_bit2);

wire x1, x2, x3, x4;
nand (x1, i_bit1, nbit2, nc);
nand (x2, nbit1, i_bit2, nc);
nand (x3, nbit1, nbit2, i_carry);
nand (x4, i_bit1, i_bit2, i_carry);
nand (o_sum, x1, x2, x3, x4);
endmodule



// for input,  1 comes from above and 2 comes from right.
// for output, 1 goes to up and 2 goes to right.
module adder_module_B_type_1 (
	input i_ng1, i_ng2,
	input i_np1, i_np2,
	input i_ncarry,
	output o_carry1, o_carry2,
	output o_g3, o_p3
);

nor (o_p3, i_np1, i_np2);
oai21 G1(i_np1, i_ng2, i_ng1, o_g3);
not (o_carry2, i_ncarry);
oai21 G2(i_np2, i_ncarry, i_ng2, o_carry1);

endmodule



module adder_module_B_type_2 (
	input i_g1, i_g2,
	input i_p1, i_p2,
	input i_carry,
	output o_ncarry1, o_ncarry2,
	output o_ng3, o_np3
);
nand (o_np3, i_p1, i_p2);
aoi21 G12(i_p1, i_g2, i_g1, o_ng3);
not (o_ncarry2, i_carry);
aoi21 G2(i_p2, i_carry, i_g2, o_ncarry1);
endmodule



module good_adder (
	input [31:0] A,
	input [31:0] B,
	input carry,
	output [31:0] S
);

wire [31:0] C;   // +
wire [31:0] G1;  // -
wire [31:0] P1;  // -

adder_module_A A1(.i_bit1(A[0]),.i_bit2(B[0]),.i_carry(C[0]),.o_sum(S[0]),.o_ng(G1[0]),.o_np(P1[0]));
adder_module_A A2(.i_bit1(A[1]),.i_bit2(B[1]),.i_carry(C[1]),.o_sum(S[1]),.o_ng(G1[1]),.o_np(P1[1]));
adder_module_A A3(.i_bit1(A[2]),.i_bit2(B[2]),.i_carry(C[2]),.o_sum(S[2]),.o_ng(G1[2]),.o_np(P1[2]));
adder_module_A A4(.i_bit1(A[3]),.i_bit2(B[3]),.i_carry(C[3]),.o_sum(S[3]),.o_ng(G1[3]),.o_np(P1[3]));
adder_module_A A5(.i_bit1(A[4]),.i_bit2(B[4]),.i_carry(C[4]),.o_sum(S[4]),.o_ng(G1[4]),.o_np(P1[4]));
adder_module_A A6(.i_bit1(A[5]),.i_bit2(B[5]),.i_carry(C[5]),.o_sum(S[5]),.o_ng(G1[5]),.o_np(P1[5]));
adder_module_A A7(.i_bit1(A[6]),.i_bit2(B[6]),.i_carry(C[6]),.o_sum(S[6]),.o_ng(G1[6]),.o_np(P1[6]));
adder_module_A A8(.i_bit1(A[7]),.i_bit2(B[7]),.i_carry(C[7]),.o_sum(S[7]),.o_ng(G1[7]),.o_np(P1[7]));
adder_module_A A9(.i_bit1(A[8]),.i_bit2(B[8]),.i_carry(C[8]),.o_sum(S[8]),.o_ng(G1[8]),.o_np(P1[8]));
adder_module_A A10(.i_bit1(A[9]),.i_bit2(B[9]),.i_carry(C[9]),.o_sum(S[9]),.o_ng(G1[9]),.o_np(P1[9]));
adder_module_A A11(.i_bit1(A[10]),.i_bit2(B[10]),.i_carry(C[10]),.o_sum(S[10]),.o_ng(G1[10]),.o_np(P1[10]));
adder_module_A A12(.i_bit1(A[11]),.i_bit2(B[11]),.i_carry(C[11]),.o_sum(S[11]),.o_ng(G1[11]),.o_np(P1[11]));
adder_module_A A13(.i_bit1(A[12]),.i_bit2(B[12]),.i_carry(C[12]),.o_sum(S[12]),.o_ng(G1[12]),.o_np(P1[12]));
adder_module_A A14(.i_bit1(A[13]),.i_bit2(B[13]),.i_carry(C[13]),.o_sum(S[13]),.o_ng(G1[13]),.o_np(P1[13]));
adder_module_A A15(.i_bit1(A[14]),.i_bit2(B[14]),.i_carry(C[14]),.o_sum(S[14]),.o_ng(G1[14]),.o_np(P1[14]));
adder_module_A A16(.i_bit1(A[15]),.i_bit2(B[15]),.i_carry(C[15]),.o_sum(S[15]),.o_ng(G1[15]),.o_np(P1[15]));
adder_module_A A17(.i_bit1(A[16]),.i_bit2(B[16]),.i_carry(C[16]),.o_sum(S[16]),.o_ng(G1[16]),.o_np(P1[16]));
adder_module_A A18(.i_bit1(A[17]),.i_bit2(B[17]),.i_carry(C[17]),.o_sum(S[17]),.o_ng(G1[17]),.o_np(P1[17]));
adder_module_A A19(.i_bit1(A[18]),.i_bit2(B[18]),.i_carry(C[18]),.o_sum(S[18]),.o_ng(G1[18]),.o_np(P1[18]));
adder_module_A A20(.i_bit1(A[19]),.i_bit2(B[19]),.i_carry(C[19]),.o_sum(S[19]),.o_ng(G1[19]),.o_np(P1[19]));
adder_module_A A21(.i_bit1(A[20]),.i_bit2(B[20]),.i_carry(C[20]),.o_sum(S[20]),.o_ng(G1[20]),.o_np(P1[20]));
adder_module_A A22(.i_bit1(A[21]),.i_bit2(B[21]),.i_carry(C[21]),.o_sum(S[21]),.o_ng(G1[21]),.o_np(P1[21]));
adder_module_A A23(.i_bit1(A[22]),.i_bit2(B[22]),.i_carry(C[22]),.o_sum(S[22]),.o_ng(G1[22]),.o_np(P1[22]));
adder_module_A A24(.i_bit1(A[23]),.i_bit2(B[23]),.i_carry(C[23]),.o_sum(S[23]),.o_ng(G1[23]),.o_np(P1[23]));
adder_module_A A25(.i_bit1(A[24]),.i_bit2(B[24]),.i_carry(C[24]),.o_sum(S[24]),.o_ng(G1[24]),.o_np(P1[24]));
adder_module_A A26(.i_bit1(A[25]),.i_bit2(B[25]),.i_carry(C[25]),.o_sum(S[25]),.o_ng(G1[25]),.o_np(P1[25]));
adder_module_A A27(.i_bit1(A[26]),.i_bit2(B[26]),.i_carry(C[26]),.o_sum(S[26]),.o_ng(G1[26]),.o_np(P1[26]));
adder_module_A A28(.i_bit1(A[27]),.i_bit2(B[27]),.i_carry(C[27]),.o_sum(S[27]),.o_ng(G1[27]),.o_np(P1[27]));
adder_module_A A29(.i_bit1(A[28]),.i_bit2(B[28]),.i_carry(C[28]),.o_sum(S[28]),.o_ng(G1[28]),.o_np(P1[28]));
adder_module_A A30(.i_bit1(A[29]),.i_bit2(B[29]),.i_carry(C[29]),.o_sum(S[29]),.o_ng(G1[29]),.o_np(P1[29]));
adder_module_A A31(.i_bit1(A[30]),.i_bit2(B[30]),.i_carry(C[30]),.o_sum(S[30]),.o_ng(G1[30]),.o_np(P1[30]));
adder_module_A A32(.i_bit1(A[31]),.i_bit2(B[31]),.i_carry(C[31]),.o_sum(S[31]),.o_ng(G1[31]),.o_np(P1[31]));


wire [15:0] G2;   // +
wire [15:0] P2;   // +
wire [15:0] C2;   // -
adder_module_B_type_1 B1_1(.i_ng1(G1[1]), .i_ng2(G1[0]),.i_np1(P1[1]), .i_np2(P1[0]),.i_ncarry(C2[0]),.o_carry1(C[1]), .o_carry2(C[0]),.o_g3(G2[0]), .o_p3(P2[0]));
adder_module_B_type_1 B1_2(.i_ng1(G1[3]), .i_ng2(G1[2]),.i_np1(P1[3]), .i_np2(P1[2]),.i_ncarry(C2[1]),.o_carry1(C[3]), .o_carry2(C[2]),.o_g3(G2[1]), .o_p3(P2[1]));
adder_module_B_type_1 B1_3(.i_ng1(G1[5]), .i_ng2(G1[4]),.i_np1(P1[5]), .i_np2(P1[4]),.i_ncarry(C2[2]),.o_carry1(C[5]), .o_carry2(C[4]),.o_g3(G2[2]), .o_p3(P2[2]));
adder_module_B_type_1 B1_4(.i_ng1(G1[7]), .i_ng2(G1[6]),.i_np1(P1[7]), .i_np2(P1[6]),.i_ncarry(C2[3]),.o_carry1(C[7]), .o_carry2(C[6]),.o_g3(G2[3]), .o_p3(P2[3]));
adder_module_B_type_1 B1_5(.i_ng1(G1[9]), .i_ng2(G1[8]),.i_np1(P1[9]), .i_np2(P1[8]),.i_ncarry(C2[4]),.o_carry1(C[9]), .o_carry2(C[8]),.o_g3(G2[4]), .o_p3(P2[4]));
adder_module_B_type_1 B1_6(.i_ng1(G1[11]), .i_ng2(G1[10]),.i_np1(P1[11]), .i_np2(P1[10]),.i_ncarry(C2[5]),.o_carry1(C[11]), .o_carry2(C[10]),.o_g3(G2[5]), .o_p3(P2[5]));
adder_module_B_type_1 B1_7(.i_ng1(G1[13]), .i_ng2(G1[12]),.i_np1(P1[13]), .i_np2(P1[12]),.i_ncarry(C2[6]),.o_carry1(C[13]), .o_carry2(C[12]),.o_g3(G2[6]), .o_p3(P2[6]));
adder_module_B_type_1 B1_8(.i_ng1(G1[15]), .i_ng2(G1[14]),.i_np1(P1[15]), .i_np2(P1[14]),.i_ncarry(C2[7]),.o_carry1(C[15]), .o_carry2(C[14]),.o_g3(G2[7]), .o_p3(P2[7]));
adder_module_B_type_1 B1_9(.i_ng1(G1[17]), .i_ng2(G1[16]),.i_np1(P1[17]), .i_np2(P1[16]),.i_ncarry(C2[8]),.o_carry1(C[17]), .o_carry2(C[16]),.o_g3(G2[8]), .o_p3(P2[8]));
adder_module_B_type_1 B1_10(.i_ng1(G1[19]), .i_ng2(G1[18]),.i_np1(P1[19]), .i_np2(P1[18]),.i_ncarry(C2[9]),.o_carry1(C[19]), .o_carry2(C[18]),.o_g3(G2[9]), .o_p3(P2[9]));
adder_module_B_type_1 B1_11(.i_ng1(G1[21]), .i_ng2(G1[20]),.i_np1(P1[21]), .i_np2(P1[20]),.i_ncarry(C2[10]),.o_carry1(C[21]), .o_carry2(C[20]),.o_g3(G2[10]), .o_p3(P2[10]));
adder_module_B_type_1 B1_12(.i_ng1(G1[23]), .i_ng2(G1[22]),.i_np1(P1[23]), .i_np2(P1[22]),.i_ncarry(C2[11]),.o_carry1(C[23]), .o_carry2(C[22]),.o_g3(G2[11]), .o_p3(P2[11]));
adder_module_B_type_1 B1_13(.i_ng1(G1[25]), .i_ng2(G1[24]),.i_np1(P1[25]), .i_np2(P1[24]),.i_ncarry(C2[12]),.o_carry1(C[25]), .o_carry2(C[24]),.o_g3(G2[12]), .o_p3(P2[12]));
adder_module_B_type_1 B1_14(.i_ng1(G1[27]), .i_ng2(G1[26]),.i_np1(P1[27]), .i_np2(P1[26]),.i_ncarry(C2[13]),.o_carry1(C[27]), .o_carry2(C[26]),.o_g3(G2[13]), .o_p3(P2[13]));
adder_module_B_type_1 B1_15(.i_ng1(G1[29]), .i_ng2(G1[28]),.i_np1(P1[29]), .i_np2(P1[28]),.i_ncarry(C2[14]),.o_carry1(C[29]), .o_carry2(C[28]),.o_g3(G2[14]), .o_p3(P2[14]));
adder_module_B_type_1 B1_16(.i_ng1(G1[31]), .i_ng2(G1[30]),.i_np1(P1[31]), .i_np2(P1[30]),.i_ncarry(C2[15]),.o_carry1(C[31]), .o_carry2(C[30]),.o_g3(G2[15]), .o_p3(P2[15]));



wire [7:0] G3;   // -
wire [7:0] P3;   // -
wire [7:0] C3;   // +
adder_module_B_type_2 B2_1(.i_g1(G2[1]), .i_g2(G2[0]),.i_p1(P2[1]), .i_p2(P2[0]),.i_carry(C3[0]),.o_ncarry1(C2[1]), .o_ncarry2(C2[0]),.o_ng3(G3[0]), .o_np3(P3[0]));
adder_module_B_type_2 B2_2(.i_g1(G2[3]), .i_g2(G2[2]),.i_p1(P2[3]), .i_p2(P2[2]),.i_carry(C3[1]),.o_ncarry1(C2[3]), .o_ncarry2(C2[2]),.o_ng3(G3[1]), .o_np3(P3[1]));
adder_module_B_type_2 B2_3(.i_g1(G2[5]), .i_g2(G2[4]),.i_p1(P2[5]), .i_p2(P2[4]),.i_carry(C3[2]),.o_ncarry1(C2[5]), .o_ncarry2(C2[4]),.o_ng3(G3[2]), .o_np3(P3[2]));
adder_module_B_type_2 B2_4(.i_g1(G2[7]), .i_g2(G2[6]),.i_p1(P2[7]), .i_p2(P2[6]),.i_carry(C3[3]),.o_ncarry1(C2[7]), .o_ncarry2(C2[6]),.o_ng3(G3[3]), .o_np3(P3[3]));
adder_module_B_type_2 B2_5(.i_g1(G2[9]), .i_g2(G2[8]),.i_p1(P2[9]), .i_p2(P2[8]),.i_carry(C3[4]),.o_ncarry1(C2[9]), .o_ncarry2(C2[8]),.o_ng3(G3[4]), .o_np3(P3[4]));
adder_module_B_type_2 B2_6(.i_g1(G2[11]), .i_g2(G2[10]),.i_p1(P2[11]), .i_p2(P2[10]),.i_carry(C3[5]),.o_ncarry1(C2[11]), .o_ncarry2(C2[10]),.o_ng3(G3[5]), .o_np3(P3[5]));
adder_module_B_type_2 B2_7(.i_g1(G2[13]), .i_g2(G2[12]),.i_p1(P2[13]), .i_p2(P2[12]),.i_carry(C3[6]),.o_ncarry1(C2[13]), .o_ncarry2(C2[12]),.o_ng3(G3[6]), .o_np3(P3[6]));
adder_module_B_type_2 B2_8(.i_g1(G2[15]), .i_g2(G2[14]),.i_p1(P2[15]), .i_p2(P2[14]),.i_carry(C3[7]),.o_ncarry1(C2[15]), .o_ncarry2(C2[14]),.o_ng3(G3[7]), .o_np3(P3[7]));


wire [3:0] G4;   // +
wire [3:0] P4;   // +
wire [3:0] C4;   // -
adder_module_B_type_1 B3_1(.i_ng1(G3[1]), .i_ng2(G3[0]),.i_np1(P3[1]), .i_np2(P3[0]),.i_ncarry(C4[0]),.o_carry1(C3[1]), .o_carry2(C3[0]),.o_g3(G4[0]), .o_p3(P4[0]));
adder_module_B_type_1 B3_2(.i_ng1(G3[3]), .i_ng2(G3[2]),.i_np1(P3[3]), .i_np2(P3[2]),.i_ncarry(C4[1]),.o_carry1(C3[3]), .o_carry2(C3[2]),.o_g3(G4[1]), .o_p3(P4[1]));
adder_module_B_type_1 B3_3(.i_ng1(G3[5]), .i_ng2(G3[4]),.i_np1(P3[5]), .i_np2(P3[4]),.i_ncarry(C4[2]),.o_carry1(C3[5]), .o_carry2(C3[4]),.o_g3(G4[2]), .o_p3(P4[2]));
adder_module_B_type_1 B3_4(.i_ng1(G3[7]), .i_ng2(G3[6]),.i_np1(P3[7]), .i_np2(P3[6]),.i_ncarry(C4[3]),.o_carry1(C3[7]), .o_carry2(C3[6]),.o_g3(G4[3]), .o_p3(P4[3]));


wire [1:0] G5;  // -
wire [1:0] P5;  // -
wire [1:0] C5;  // +
adder_module_B_type_2 B4_1(.i_g1(G4[1]), .i_g2(G4[0]),.i_p1(P4[1]), .i_p2(P4[0]),.i_carry(C5[0]),.o_ncarry1(C4[1]), .o_ncarry2(C4[0]),.o_ng3(G5[0]), .o_np3(P5[0]));
adder_module_B_type_2 B4_2(.i_g1(G4[3]), .i_g2(G4[2]),.i_p1(P4[3]), .i_p2(P4[2]),.i_carry(C5[1]),.o_ncarry1(C4[3]), .o_ncarry2(C4[2]),.o_ng3(G5[1]), .o_np3(P5[1]));

wire ncarry;
not (ncarry, carry);
adder_module_B_type_1 B5_1(.i_ng1(G5[1]), .i_ng2(G5[0]),.i_np1(P5[1]), .i_np2(P5[0]),.i_ncarry(ncarry),.o_carry1(C5[1]), .o_carry2(C5[0]),.o_g3(), .o_p3());
endmodule