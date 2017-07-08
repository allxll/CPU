module ALU_Boolean (
	input [31:0] A,
	input [31:0] B,
	input [2:0] ALUFun,
	output reg [31:0] S
);

always @(*) begin : proc_logic
	case (ALUFun[2:0])
		3'b000:  S = ~(A | B);
		3'b001:  S = 0;
		3'b010:  S = 0;
		3'b011:  S = A ^ B;
		3'b100:	 S = A & B;
		3'b101:  S  = A;
		3'b110:  S = 0;
		3'b111:  S = A | B;
	endcase
end

endmodule