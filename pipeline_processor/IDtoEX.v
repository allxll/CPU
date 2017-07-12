`timescale 1ns/1ps
module IDtoEX (
  input             clk           ,
  input             reset         ,
  input             ID_EX_Flush   ,
  input      [31:0] PC_plus4      ,
  output reg [31:0] PC_plus4_out  ,
  // ID
  // input reg EXTOp,
  // input reg LUOp,
  // output reg EXTOp_out,
  // output reg LUOp_out);
  // EX
  input      [ 4:0] RegisterRs    ,
  input      [ 4:0] RegisterRt    ,
  input      [ 5:0] ALUFun        ,
  input             ALUSrc1       ,
  input             ALUSrc2       ,
  input      [31:0] DataBus_A     ,
  input      [31:0] DataBus_B     ,
  input             Sign          ,
  input      [31:0] Immediate     ,
  input      [ 4:0] Shamt         ,
  input             isBranch      ,
  output reg        isBranch_out  ,
  output reg [ 4:0] RegisterRs_out,
  output reg [ 4:0] RegisterRt_out,
  output reg [ 5:0] ALUFun_out    ,
  output reg        ALUSrc1_out   ,
  output reg        ALUSrc2_out   ,
  output reg [31:0] DataBus_A_out ,
  output reg [31:0] DataBus_B_out ,
  output reg        Sign_out      ,
  output reg [31:0] Immediate_out ,
  output reg [4:0]  Shamt_out     ,
  // MEM
  input             MemWr         ,
  input             MemRd         ,
  output reg        MemRd_out     ,
  output reg        MemWr_out     ,
  // WB
  input             RegWr         ,
  input      [ 4:0] RegisterRd    ,
  input      [ 1:0] RegDst        ,
  input      [ 1:0] MemToReg      ,
  output reg        RegWr_out     ,
  output reg [ 1:0] MemToReg_out  ,
  output reg [ 1:0] RegDst_out    ,
  output reg [ 4:0] RegisterRd_out
);





  always@(posedge clk) begin
    if(~reset || ID_EX_Flush) begin
      MemWr_out <= 0;
      //MemRd_out<=0;
      RegWr_out <= 0;
      MemRd_out <= 0;
    end
    else begin
      PC_plus4_out   <= PC_plus4;
      isBranch_out   <= isBranch;
      // EX
      ALUFun_out     <= ALUFun;
      ALUSrc1_out    <= ALUSrc1;
      ALUSrc2_out    <= ALUSrc2;
      DataBus_A_out  <= DataBus_A;
      DataBus_B_out  <= DataBus_B;
      Sign_out       <= Sign;
      RegisterRs_out <= RegisterRs;
      RegisterRt_out <= RegisterRt;
      Immediate_out  <= Immediate;
      Shamt_out      <= Shamt;
      // MEM
      MemWr_out      <= MemWr;
      MemRd_out      <= MemRd;

      // WB
      RegDst_out     <= RegDst;
      RegWr_out      <= RegWr;
      MemToReg_out   <= MemToReg;
      RegisterRd_out <= RegisterRd;
    end
//      EXTOp_out<=EXTOp;
    //     LUOp_out<=LUOp;
  end
endmodule