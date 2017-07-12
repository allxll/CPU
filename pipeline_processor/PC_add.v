`timescale 1ns/1ps

module PC_add (
	input reset,
	input clk,
	input PCWr,
    input [31:0] PC_in,
	output reg [31:0] PC,
);

parameter ILLOP = 32'h80000004;
parameter XADR = 32'h80000008;
parameter RESETPC = 32'h00000000;    // ONLY FOR DEBUG!
//parameter RESETPC = 32'h80000000;   

always@(posedge clk) begin
	if(~reset) begin
		PC <= RESETPC;
	end
	else if(PCWr) begin
    	PC<=PC_in;
	end
end

endmodule