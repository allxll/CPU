`timescale 1ns/1ps
module IFtoID (
  input             clk             ,
  input             reset           ,
  input             IF_ID_Wr        ,
  input             IF_ID_Flush     ,
  input      [31:0] PC_in           ,
  input      [31:0] Instruction     ,
  input      [31:0] PC_plus4        ,
  output reg [31:0] Instruction_out ,
  output reg [31:0] PC_plus4_out    ,
  output reg [31:0] PC_out          ,
  output reg [15:0] Imm16_IF_ID     ,
  output reg [ 4:0] Shamt_IF_ID     ,
  output reg [ 4:0] RegisterRd_IF_ID,
  output reg [ 4:0] RegisterRt_IF_ID,
  output reg [ 4:0] RegisterRs_IF_ID,
  output reg [25:0] JT_IF_ID
);

initial begin
  Instruction_out  <= 0;
  PC_plus4_out     <= 0;
  PC_out           <= 0;
  Imm16_IF_ID      <= 0;
  Shamt_IF_ID      <= 0;
  RegisterRd_IF_ID <= 0;
  RegisterRt_IF_ID <= 0;
  RegisterRs_IF_ID <= 0;
  JT_IF_ID <= 0;
end

  always@(posedge clk) begin
    if(~reset || IF_ID_Flush) begin
      Instruction_out <= 0;
      Shamt_IF_ID <= 0;
      RegisterRs_IF_ID <= 0;
      RegisterRd_IF_ID <= 0;
      RegisterRt_IF_ID <= 0;
      JT_IF_ID <= 0;
      Imm16_IF_ID <= 0;
    end
    else if(IF_ID_Wr) begin
      Instruction_out  <= Instruction;
      PC_plus4_out     <= PC_plus4;
      Shamt_IF_ID      <= Instruction[10:6];
      RegisterRd_IF_ID <= Instruction[15:11];
      RegisterRt_IF_ID <= Instruction[20:16];
      RegisterRs_IF_ID <= Instruction[25:21];
      JT_IF_ID         <= Instruction[25:0];
      Imm16_IF_ID      <= Instruction[15:0];
      PC_out <= PC_in;
    end

  end

endmodule