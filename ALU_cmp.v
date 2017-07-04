module ALU_cmp (
	input reg Z;
	input reg V;
	input reg N;
	input reg [3:1] ALUFun;
	output reg S;
);

always @(*) begin : proc_compare
	case (ALUFun[3:1])
		3'b001: S = Z;
		3'b000: S = ~Z;
		3'b010: S = N^V;
		3'b110: S = Z + N^V;
		3'b101: S = N^V;
		3'b111: S = ~(Z + N^V);
		default : S = 0;
	endcase
end

endmodule