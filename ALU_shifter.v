module ALU_shifter (
	input reg [31:0] A;
	input reg [4:0] B;
	input [1:0] ALUFun;
	output wire [31:0] S;
);


wire [31:0] W1;
wire [31:0] X1;
wire [31:0] Y1;
wire [31:0] Z1;
wire [31:0] S1;

wire [31:0] W2;
wire [31:0] X2;
wire [31:0] Y2;
wire [31:0] Z2;
wire [31:0] S2;

// <<
assign W1 = B[4]?({A[15:0], 16{0}}):A;
assign X1 = B[3]?({W1[23:0], 8{0}}):W1;
assign Y1 = B[2]?({X1[27:0], 4{0}}):X1;
assign Z1 = B[1]?({Y1[29:0], 2{0}}):Y1;
assign S1 = B[0]?({Z1[30:0], 0}):Z1;


// >>
assign W2 = B[4]?
		(ALUFun[1]?{16{A[31]}, A[15:0]}
				  :{16{0}, A[15:0]})
				:A;
assign X2 = B[3]?
		(ALUFun[1]?{8{A[31]}, W2[23:0]}
				  :{8{0}, W2[23:0]})
				:W2;
assign Y2 = B[2]
		(ALUFun[1]?{4{A[31]}, X2[27:0]}
				  :{4{0}, X2[27:0]})
				:X2;
assign Z2 = B[1]?
		(ALUFun[1]?{2{A[31]}, Y2[29:0]}
				  :{2{0}, Y2[29:0]})
				:Y2;
assign S2 = B[0]?
		(ALUFun[1]?{1{A[31]}, Z2[30:0]}
				  :{1{0}, Z2[30:0]})
				:Z2;

assign S = ALUFun[0]?S2:S1;

endmodule