module ALU_shifter (
	input [4:0] A,
	input [31:0] B,
	input [1:0] ALUFun,
	output reg [31:0] S
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

wire [31:0] W3;
wire [31:0] X3;
wire [31:0] Y3;
wire [31:0] Z3;
wire [31:0] S3;
// <<
assign W1 = A[4]?({B[15:0], 16'b0}):B;
assign X1 = A[3]?({W1[23:0], 8'b0}):W1;
assign Y1 = A[2]?({X1[27:0], 4'b0}):X1;
assign Z1 = A[1]?({Y1[29:0], 2'b0}):Y1;
assign S1 = A[0]?({Z1[30:0], 1'b0}):Z1;


// >>
wire B31;
buf BUFA(B31, B[31]);

// ALUFun[1] == 1
assign W2 = A[4]?{{16{B31}}, B[31:16]}:B;
assign X2 = A[3]?{{8{B31}}, W2[31:8]}:W2;
assign Y2 = A[2]?{{4{B31}}, X2[31:4]}:X2;
assign Z2 = A[1]?{{2{B31}}, Y2[31:2]}:Y2;
assign S2 = A[0]?{{1{B31}}, Z2[31:1]}:Z2;

// ALUFun[1] == 0
assign W3 = A[4]?{16'b0, B[31:16]}:B;
assign X3 = A[3]?{8'b0, W3[31:8]}:W3;
assign Y3 = A[2]?{4'b0, X3[31:4]}:X3;
assign Z3 = A[1]?{2'b0, Y3[31:2]}:Y3;
assign S3 = A[0]?{1'b0, Z3[31:1]}:Z3;


always @(*) begin : proc_sel
	case (ALUFun[1:0])
	 	2'b00: S = S1;
	 	2'b01: S = S3;
	 	2'b10: S = 0;
	 	2'b11: S = S2;
	endcase 
end

endmodule