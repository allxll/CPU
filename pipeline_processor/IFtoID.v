`timescale 1ns/1ps
module IFtoID(
  input clk,
  input reset,
  input IF_ID_Wr,
  input IF_ID_Flush,
  input reg [31:0] PC_in,
  input reg [31:0] Instruction,
  input reg [31:0] PC_plus4,
  output reg [31:0] Instruction_out,
  output reg [31:0] PC_plus4_out,
  output reg [31:0] PC_out
);
  
always@(posedge clk) begin
    if(~reset || IF_ID_Flush) begin
        Instruction <= 0;
    end
    else if(IF_ID_Wr) begin
        Instruction_out<=Instruction;
        PC_plus4_out<=PC_plus4;
    end

end
    
endmodule