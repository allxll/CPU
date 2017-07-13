`timescale 1ns/1ps
module  EXtoMEM(
    input clk,
    input reset,
    input [31:0] PC_plus4,
    output reg [31:0]PC_plus4_out,

    // IRQ control
    input isBranch,
    output reg isBranch_out,

    // forward module
    input [4:0] RegisterRt,
    output reg [4:0] RegisterRt_out,

    // MEM
    input MemWr,
    input MemRd,
    input [31:0] DataBus_B,
    input [31:0] ALUOut,
    output reg MemWr_out,
    output reg MemRd_out,
    output reg [31:0] DataBus_B_out,
    output reg [31:0] ALUOut_out,


    // WB
    input [1:0] RegDst,
    input RegWr,
    input [1:0] MemToReg,
    input [4:0] RegisterRd,
    output reg [1:0] RegDst_out,
    output reg RegWr_out,
    output reg [1:0] MemToReg_out,
    output reg [4:0] RegisterRd_out
);
    

initial begin
    PC_plus4_out <= 0;
    RegisterRt_out <= 0;
    MemWr_out <= 0;
    MemRd_out <= 0;
    DataBus_B_out <= 0;
    ALUOut_out <= 0;
    RegDst_out <= 0;
    RegWr_out <= 0;
    MemToReg_out <= 0;
    RegisterRd_out <= 0;
    isBranch_out <= 0;
end


always@(posedge clk) begin
    if(~reset) begin
        MemWr_out <= 0;
        RegWr_out <= 0;
        MemRd_out <= 0;
    end
    else begin
        PC_plus4_out<=PC_plus4;
        RegisterRt_out<=RegisterRt;
        
        isBranch_out <= isBranch;


        // MEM
        ALUOut_out<=ALUOut;
        MemWr_out<=MemWr;
        MemRd_out<=MemRd;
        DataBus_B_out<=DataBus_B;

        // WB
        RegDst_out<=RegDst;
        RegWr_out<=RegWr;
        MemToReg_out<=MemToReg;
        RegisterRd_out<=RegisterRd;
    end
end
    
endmodule