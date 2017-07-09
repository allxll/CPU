`timescale 1ns/1ps

module Inst_Mem (
	input [31:0] addr,
	output [31:0] data
);

localparam ROM_SIZE = 32;
(* rom_style = "distributed" *) reg [31:0] ROMDATA[ROM_SIZE-1:0];

assign data=(addr < (ROM_SIZE<<2))?ROMDATA[addr[31:2]]:32'b0;

integer i;
initial begin
		ROMDATA[0] <= 32'h2004_0003;
		ROMDATA[1] <= 32'h0c00_0003;
		ROMDATA[2] <= 32'h1000_ffff;
		ROMDATA[3] <= 32'h23bd_0008;
		ROMDATA[4] <= 32'hafbf_fffc;
		ROMDATA[5] <= 32'hafa4_0000;
		ROMDATA[6] <= 32'h2888_0001;
		ROMDATA[7] <= 32'h1100_0003;
		ROMDATA[8] <= 32'h0000_1026;
		ROMDATA[9] <= 32'h23bd_fff8;
		ROMDATA[10]<= 32'h03e0_0008;
		ROMDATA[11] <= 32'h2084_ffff;
		ROMDATA[12] <= 32'h0c00_0003;
		ROMDATA[13] <= 32'h8fa4_0000;
		ROMDATA[14] <= 32'h8fbf_fffc;
		ROMDATA[15] <= 32'h23bd_fff8;
		ROMDATA[16] <= 32'h0082_1020;
		ROMDATA[17] <= 32'h03e0_0008;

        
	    for (i=18;i<ROM_SIZE;i=i+1) begin
            ROMDATA[i] <= 32'b0;
        end
end
endmodule
