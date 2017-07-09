`timescale 1ns/1ps

module Data_Mem (
	input reset,clk,
	input rd,wr,
	input [31:0] addr,	//Address Must be Word Aligned
	input [31:0] wdata,
	output [31:0] rdata
);
parameter RAM_SIZE = 256;
parameter RAM_SIZE_mul_4 = 1024;

(* ram_style = "distributed" *) reg [31:0] RAMDATA [RAM_SIZE-1:0];

assign rdata = (rd && (addr < RAM_SIZE_mul_4))? RAMDATA[addr[9:2]]:32'b0;


integer i;
always@(negedge reset or posedge clk) begin
	if(~reset) begin
		for (i = 0; i < RAM_SIZE; i=i+1) begin
			RAMDATA[i] <= 32'b0;
		end
	end
	if(wr && (addr < RAM_SIZE_mul_4)) RAMDATA[addr[9:2]]<=wdata;
end

endmodule
