module PC_add (
	input reset,
	input clk,
	input [2:0] PCSrc,
	input ALUOut,
	input [31:0] EXTOut,
	input [25:0] JT,
	input [31:0] A,
	output [31:0] PC,
	output [31:0] plus4
);

parameter ILLOP = 32'h80000004;
parameter XADR = 32'h80000008;
parameter RESETPC = 32'h80000000;

wire [31:0] sel1;
wire [31:0] plus4;
wire [31:0] JTplusPC;
wire [31:0] ConBA;

assign ConBA = plus4 + {EXTOut[29:0], 2'b00};
assign sel1 = ALUOut?ConBA:plus4;
assign plus4 = {PC[31], PC[30:0]+4};
assign JTplusPC = {PC[31:25], JT};


always@(negedge reset or posedge clk) begin
	if(~reset) begin
		PC <= RESETPC;
	end
	else begin
		case (PCSrc)
			3'b000:	PC <= plus4;
			3'b001: PC <= sel1;
			3'b010: PC <= JTplusPC;
			3'b011: PC <= A;
			3'b100: PC <= ILLOP;
			3'b101: PC <= XADR;
			default: PC <= PC;
		endcase
	end
end

endmodule