module ALU_Boolean (
	input reg [31:0] A;
	input reg [31:0] B;
	input reg [3:1] ALUFun;
	output reg [31:0] S;
);

always @(*) begin : proc_logic
	case (ALUFun[3:1])
		3'b100:	 S = A & B;
		3'b111:  S = A | B;
		3'b011:  S = A ^ B;
		3'b000:  S = ~(A | B);
		3'b101: S  = A;
		default : S = 0;
	endcase
end

endmodule