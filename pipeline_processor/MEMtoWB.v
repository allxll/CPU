`timescale 1ns/1ps
module MEMtoWB (
    input             clk             ,
    input             reset           ,
    input      [31:0] PC_plus4        ,
    input      [31:0] Data_Mem_Out    ,
    input      [31:0] ALUOut          ,
    input      [ 1:0] RegDst          ,
    input             RegWr           ,
    input      [ 1:0] MemToReg        ,
    input      [ 4:0] RegisterRd      ,
    input      [ 4:0] RegisterRt      ,
    output reg [31:0] PC_plus4_out    ,
    output reg [31:0] Data_Mem_Out_out,
    output reg [31:0] ALUOut_out      ,
    output reg [ 1:0] RegDst_out      ,
    output reg        RegWr_out       ,
    output reg [ 1:0] MemToReg_out    ,
    output reg [ 4:0] RegisterRd_out  ,
    output reg [ 4:0] RegisterRt_out
);

    always@(posedge clk) begin
        if(~reset) begin
            RegWr_out <= 0;
        end
        PC_plus4_out     <= PC_plus4;
        Data_Mem_Out_out <= Data_Mem_Out;
        ALUOut_out       <= ALUOut;
        RegDst_out       <= RegDst;
        RegWr_out        <= RegWr;
        MemToReg_out     <= MemToReg;
        RegisterRt_out   <= RegisterRt;
        RegisterRd_out   <= RegisterRd;
    end

endmodule