module ALU (
	input reg [5:0] ALUFun;
	input reg [31:0] A;
	input reg [31:0] B;
	output reg [31:0] S;
);

wire Z, V, N;
wire [31:0] S1;
wire [31:0] S2;
wire [31:0] S3;
wire [31:0] S4;

ALU_adder Add(A, B, ALUFun[0], Z, V, N, S1);
ALU_boolean Logic(A, B, ALUFun[3:1], S2);
ALU_shift Shift(A, B[4:0], ALUFun[1:0], S3);
ALU_cmp Cmp(Z, V, N, ALUFun[3:1], S4);

always @(*) begin : proc_alu	
	case (ALUFun[5:4])
		2'b00: S = S1;
		2'b01: S = S2;
		2'b10: S = S3;
		2'b11: S = S4;
		default : S = 0;
	endcase
end


endmodule // ALU