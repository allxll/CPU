module ALU_cmp (
	input Z,
	input V,
	input N,
	input [2:0] ALUFun,
	output reg S
);

wire S1;
wire S2;
wire S3;
wire S4_1, S4;
wire S5;
wire S6;


assign S1 = Z;
assign S2 = ~Z;
assign S3 = N^V;   // critical path
//nand (S4_1, A31, Z);
assign S4 = N | Z;
assign S5 = N;
assign S6 = ~(N | Z);

always @(*) begin : proc_compare
	case (ALUFun)
		3'b000: S = S2;
		3'b001: S = S1;
		3'b010: S = S3;
		3'b011: S = 0;
		3'b100: S = 0;
		3'b101: S = S5;
		3'b110: S = S4;
		3'b111: S = S6;
	endcase
end

endmodule


// wire SA, SB;
// always @(*) begin : proc_compare1
// 	if(ALUFun[1:0] == 2'b00) SA = S2;
// 	else if (ALUFun[1:0] == 2'b01) SA = S1;
// 	else if (ALUFun[1:0] == 2'b10) SA = S3;
// 	else if (ALUFun[1:0] == 2'b11) SA = 0;
// end

// always @(*) begin : proc_compare2
// 	if(ALUFun[1:0] == 2'b00) SB = 0;
// 	else if (ALUFun[1:0] == 2'b01) SB = S5;
// 	else if (ALUFun[1:0] == 2'b10) SB = S4;
// 	else if (ALUFun[1:0] == 2'b11) SB = S6;
// end

// assign S = ALUFun[2] ? SB : SA;