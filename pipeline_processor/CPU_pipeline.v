`timescale 1ns/1ps

module CPU_single (
	input reset,
	input clk,    // Clock	
	input [7:0] switch,
	input UART_RX,
	output [7:0] led,
	output [11:0] digi,
	output UART_TX
);

//parameter c_CLKS_PER_BIT    = 10416;
//parameter ILLOP = 32'h80000004;
//parameter XADR = 32'h80000008;
parameter RESETPC = 32'h00000000;    
//parameter RESETPC = 32'h80000000;   


	wire [31:0] PC_in;
	wire [31:0] PC_out;
	wire [31:0] Instruction;
////////////////////////////////////////
///////////////////////////////////////

	wire isJ_ID;
	wire isBranch_ID;
	wire [31:0] PC_in_J;
    assign PC_in_J = isJ_ID?JTplusPC_ID:PC_plus4_IF;
    assign PC_in = isBranch_ID_EX?ConBA_ID_EX:PC_in_J;
    assign IF_ID_Flush = ((isBranch_ID_EX && ALUOut_EX) || (isJ_ID))
    assign ID_EX_Flush = (isBranch_ID_EX && ALUOut_EX)?1:0;

PC_add i_PC_add (
	.PCWr (PCWr),
	.reset(reset), 
	.clk(clk), 
	.PC_in(PC_in), 
	.PC   (PC_out),
);

Inst_Mem IM(
	.addr(PC_out),
	.data(Instruction)
);
	
	wire PC_plus4_IF;
	assign PC_plus4_IF = {PC_out[31], PC_out[30:0]+31'h00000004};

	wire Instruction_IF_ID;
	wire PC_plus4_IF_ID;

IFtoID i_IFtoID (
	.clk            (clk            ),
	.reset          (reset          ),
	.IF_ID_Wr       (IF_ID_Wr       ),
	.IF_ID_Flush    (IF_ID_Flush    ),
	.Instruction    (Instruction    ),
	.PC_plus4       (PC_plus4       ),
	.Instruction_out(Instruction_IF_ID),
	.PC_plus4_out   (PC_plus4_IF_ID   ),
	.PC_in          (PC_out),
	.PC_out         (PC_IF_ID)
);

	// Control signals generated in ID stage.
	wire [1:0] RegDst_ID;
	wire RegWr_ID;
	wire ALUSrc1_ID;
	wire ALUSrc2_ID;
	wire [5:0] ALUFun_ID;
	wire Sign_ID;
	wire MemWr_ID;
	wire MemRd_ID;
	wire [1:0] MemToReg_ID;
	wire EXTOp_ID;
	wire LUOp_ID;

Control i_CTL(
//	.IRQ        (IRQ),
	.Instruction(Instruction_IF_ID),
//	.PCSrc      (PCSrc),
	.RegDst     (RegDst_ID),
	.RegWr      (RegWr_ID),
	.ALUSrc1    (ALUSrc1_ID),
	.ALUSrc2    (ALUSrc2_ID),
	.ALUFun     (ALUFun_ID),
	.Sign       (Sign_ID),
	.MemWr      (MemWr_ID),
	.MemRd      (MemRd_ID),
	.MemToReg   (MemToReg_ID),
	.EXTOp      (EXTOp_ID),
	.LUOp       (LUOp_ID),
	.isJ        (isJ_ID),
	.isBranch   (isBranch_ID),
);

	wire Imm16_ID;
	wire Shamt_ID;
	wire Rd_ID;
	wire Rt_ID;
	wire Rs_ID;
	wire JT_ID;
	assign Imm16_ID = Instruction_IF_ID[15:0];
	assign Shamt_ID = Instruction_IF_ID[10:6];
	assign Rd_ID = Instruction_IF_ID[15:11];
	assign Rt_ID = Instruction_IF_ID[20:16];
	assign Rs_ID = Instruction_IF_ID[25:21];
	assign JT_ID = Instruction_IF_ID[25:0];

	wire EXTOut_ID;
	wire LUOut_ID;
	wire ConBA_ID;
	assign LUOut_ID = LUOp_ID? {Imm16_ID, 16'b0}: EXTOut_ID;
	assign EXTOut_ID = EXTOp_ID? {{16{Instruction[15]}}, Imm16_ID}:
						   {16'b0, Imm16_ID};


	assign ConBA_ID = PC_plus4_IF_ID + {EXTOut_ID[29:0], 2'b00}; 
// NEED TO STORE INTO ID_EX

	
	assign JTplusPC_ID = {PC_IF_ID[31:28], JT, 2'b0};   


	wire RegWr_MEM_WB;
	wire Address_dest_WB;
	wire DataBus_C_WB;
	wire DataBus_A_ID;
	wire DataBus_B_ID;
	assign Address_dest_WB = (RegDst_MEM_WB == 2'b00)?RegisterRd_MEM_WB:
							(RegDst_MEM_WB == 2'b01)?RegisterRt_MEM_WB:
							(RegDst_MEM_WB == 2'b10)?5'b11111:5'b11010;

	wire Data_Out_MEM;
	assign Data_Out_MEM =  ALUOut_EX_MEM[30]?Data_PE_Out_MEM:Data_Mem_Out_MEM;
	assign DataBus_C = (MemtoReg_MEM_WB == 2'b00)?ALUOut_MEM_WB:
					   (MemtoReg_MEM_WB == 2'b01)?Data_Out_MEM:
					   (MemtoReg_MEM_WB == 2'b10)?PC_plus4_MEM_WB:0;

//////////////////////////////
RegFile RF(
	.reset(reset),
	.clk  (clk),
	.wr   (RegWr_MEM_WB),
	.addr1(Rs_ID),   // Rs
	.addr2(Rs_ID),   // Rt
	.addr3(Address_dest_WB),
	.data3(DataBus_C_WB),
	.data1(DataBus_A_ID),
	.data2(DataBus_B_ID)
);

	wire PC_plus4_ID_EX;
	wire RegisterRs_ID_EX;
	wire RegisterRt_ID_EX;
	wire ALUFun_ID_EX;   
	wire ALUSrc1_ID_EX; 
	wire ALUSrc2_ID_EX;  
	wire DataBus_A_ID_EX;
	wire DataBus_B_ID_EX;
	wire Sign_ID_EX;
	wire LUOut_ID_EX;    
	wire Shamt_ID_EX;   
	wire MemRd_ID_EX;
	wire MemWr_ID_EX;
	wire RegWr_ID_EX;
	wire MemToReg_ID_EX;
	wire RegisterRd_ID_EX;


IDtoEX i_IDtoEX (
	.clk           (clk              ),
	.reset         (reset            ),
	.ID_EX_Flush   (ID_EX_Flush      ),
	.PC_plus4      (PC_plus4_IF_ID         ),
	.PC_plus4_out  (PC_plus4_ID_EX     ),
	.RegisterRs    (Rs_ID),
	.RegisterRt    (Rt_ID),
	.ALUFun        (ALUFun_ID           ),
	.ALUSrc1       (ALUSrc1_ID          ),
	.ALUSrc2       (ALUSrc2_ID          ),
	.DataBus_A     (DataBus_A_ID        ),
	.DataBus_B     (DataBus_B_ID        ),
	.Sign          (Sign_ID             ),
	.Immediate     (LUOut_ID        ),
	.Shamt         (Shamt_ID            ),
	.RegisterRs_out(RegisterRs_ID_EX   ),
	.RegisterRt_out(RegisterRt_ID_EX   ),
	.ALUFun_out    (ALUFun_ID_EX       ),
	.ALUSrc1_out   (ALUSrc1_ID_EX      ),
	.ALUSrc2_out   (ALUSrc2_ID_EX      ),
	.DataBus_A_out (DataBus_A_ID_EX    ),
	.DataBus_B_out (DataBus_B_ID_EX    ),
	.Sign_out      (Sign_ID_EX         ),
	.Immediate_out (LUOut_ID_EX    ),
	.Shamt_out     (Shamt_ID_EX     ),
	.MemWr         (MemWr_ID        ),
	.MemRd         (MemRd_ID        ),
	.MemRd_out     (MemRd_ID_EX        ),
	.MemWr_out     (MemWr_ID_EX        ),
	.RegWr         (RegWr_ID        ),
	.RegisterRd    (Rd_ID   ),
	.RegDst        (RegDst_ID           ),
	.MemToReg      (MemToReg_ID         ),
	.RegWr_out     (RegWr_ID_EX        ),
	.MemToReg_out  (MemToReg_ID_EX     ),
	.RegisterRd_out(RegisterRd_ID_EX   ),
	.RegDst_out    (RegDst_ID_EX),
	.isBranch      (isBranch_ID),
	.isBranch_out  (isBranch_ID_EX)
);

	wire ForwardA;
	wire ForwardB;
	wire ForwardMEM;

forward i_forward (
	.RegWr_EX_MEM     (RegWr_EX_MEM     ),
	.RegisterRd_EX_MEM(RegisterRd_EX_MEM),
	.RegisterRt_ID_EX (RegisterRt_ID_EX ), // TODO: Check connection ! Signal/port not matching : Expecting logic [5:0]  -- Found logic 
	.RegisterRs_ID_EX (RegisterRs_ID_EX ),
	.RegWr_MEM_WB     (RegWr_MEM_WB     ),
	.RegisterRd_MEM_WB(RegisterRd_MEM_WB),
	.MemtoReg_MEM_WB  (MemtoReg_MEM_WB  ),
	.MemWr_EX_MEM     (MemWr_EX_MEM     ),
	.RegisterRt_EX_MEM(RegisterRt_EX_MEM),
	.ForwardA         (ForwardA         ),
	.ForwardB         (ForwardB         ),
	.ForwardMEM       (ForwardMEM       )
);


	wire ALUOut_EX;
	wire ALU_in1_EX;
	wire ALU_in2_EX;
	wire ALU_reg_in1_EX;
	wire ALU_reg_in2_EX;
	assign ALU_reg_in1_EX = (ForwardA==2'b10)?((MemToReg==2'b01)?Data_Mem_Out_MEM_WB:ALUOut_MEM_WB):
							(ForwardA==2'b01)?ALUOut_EX_MEM:DataBus_A_ID_EX;
	assign ALU_reg_in2_EX = (ForwardB==2'b10)?((MemToReg==2'b01)?Data_Mem_Out_MEM_WB:ALUOut_MEM_WB):
							(ForwardB==2'b01)?ALUOut_EX_MEM:DataBus_B_ID_EX;
	assign ALU_in1_EX = ALUSrc1_ID_EX?Shamt_ID_EX:ALU_reg_in1_EX;
	assign ALU_in2_EX = ALUSrc2_ID_EX?LUOut_ID_EX:ALU_reg_in2_EX;


ALU ALU_(
	.ALUFun(ALUFun_ID_EX),
	.A     (ALU_in1_EX),
	.B     (ALU_in2_EX),
	.Sign  (Sign_ID_EX),
	.S     (ALUOut_EX)
);

	wire PC_plus4_EX_MEM ;
	wire RegisterRt_EX_MEM;
	wire MemWr_EX_MEM;
	wire MemRd_EX_MEM;
	wire DataBus_B_EX_MEM;
	wire ALUOut_EX_MEM;
	wire RegDst_EX_MEM;      
	wire RegWr_EX_MEM;       
	wire MemToReg_EX_MEM;    
	wire RegisterRd_EX_MEM;  

EXtoMEM i_EXtoMEM (
	.clk           (clk              ),
	.reset         (reset            ),
	.PC_plus4      (PC_plus4_ID_EX         ),
	.PC_plus4_out  (PC_plus4_EX_MEM     ),
	.RegisterRt    (RegisterRt_ID_EX),
	.RegisterRt_out(RegisterRt_EX_MEM   ),
	.MemWr         (MemWr_ID_EX    ),
	.MemRd         (MemRd_ID_EX      ),
	.DataBus_B     (DataBus_B_ID_EX        ),
	.ALUOut        (ALUOut_EX           ),
	.MemWr_out     (MemWr_EX_MEM        ),
	.MemRd_out     (MemRd_EX_MEM        ),
	.DataBus_B_out (DataBus_B_EX_MEM    ),
	.ALUOut_out    (ALUOut_EX_MEM       ),
	.RegDst        (RegDst_ID_EX        ),
	.RegWr         (RegWr_ID_EX     ),
	.MemToReg      (MemToReg_ID_EX      ),
	.RegisterRd    (RegisterRd_ID_EX),
	.RegDst_out    (RegDst_EX_MEM       ),
	.RegWr_out     (RegWr_EX_MEM        ),
	.MemToReg_out  (MemToReg_EX_MEM     ),
	.RegisterRd_out(RegisterRd_EX_MEM   )
);


	wire Data_Mem_Out_MEM;

Data_Mem DM(
	.reset(reset),
	.clk  (clk),
	.rd   (MemRd_EX_MEM),
	.wr   (MemWr_EX_MEM),
	.addr (ALUOut_EX_MEM),
	.rdata(Data_Mem_Out_MEM),
	.wdata(DataBus_B_EX_MEM)
);


	wire Data_PE_Out_MEM;

Peripheral PE(
	.reset 	   (reset),
	.clk       (clk),
	.rd        (MemRd_EX_MEM),
	.wr        (MemWr_EX_MEM),
	.addr      (ALUOut_EX_MEM),
	.wdata     (DataBus_B_EX_MEM),
//	.switch    (switch),
	.RX_STATUS (RX_STATUS),
	.TX_STATUS (TX_STATUS),
	.RX_DATA  (RX_DATA),

	.rdata     (Data_PE_Out_MEM),
	.led       (led),
	.digi      (digi),
	//.irqout    (IRQ),
	.TX_EN     (TX_EN),
	.TX_DATA   (TX_DATA)
);


MEMtoWB i_MEMtoWB (
	.clk             (clk              ),
	.reset           (reset            ),
	.PC_plus4        (PC_plus4_EX_MEM         ),
	.Data_Mem_Out    (Data_Mem_Out_MEM     ),
	.ALUOut          (ALUOut_EX_MEM           ),
	.RegDst          (RegDst_EX_MEM           ),
	.RegWr           (RegWr_EX_MEM        ),
	.MemToReg        (MemToReg_EX_MEM         ),
	.RegisterRd      (RegisterRd_EX_MEM   ),
	.RegisterRt      (RegisterRt_EX_MEM),
	.PC_plus4_out    (PC_plus4_MEM_WB     ),
	.Data_Mem_Out_out(Data_Mem_Out_MEM_WB ),
	.ALUOut_out      (ALUOut_MEM_WB       ),
	.RegDst_out      (RegDst_MEM_WB       ),
	.RegWr_out       (RegWr_MEM_WB        ),
	.RegisterRd_out  (RegisterRd_MEM_WB   ),
	.RegisterRt_out  (RegisterRt_MEM_WB   )
);


	wire PC_Wr;
	wire IF_ID_Wr;
	wire ID_EX_Flush;
	wire IF_ID_Flush;

hazard i_hazard (
	.MemRd_ID_EX     (MemRd_ID_EX     ),
	.RegisterRt_ID_EX(RegisterRt_ID_EX),
	.RegisterRs_IF_ID(RegisterRs_IF_ID),
	.RegisterRt_IF_ID(RegisterRt_IF_ID),
	.PCWr            (PCWr            ),
	.IF_ID_Wr        (IF_ID_Wr        ),
	.ID_EX_Flush     (ID_EX_Flush     )
);


uart_rx i_uart_rx (
	.i_Clock    (clk), 
	.i_Rx_Serial(UART_RX), 
	.o_Rx_DV    (RX_STATUS), 
	.o_Rx_Byte  (RX_DATA)
);



uart_tx i_uart_tx (
	.i_Clock    (clk        ),
	.i_Tx_DV    (TX_EN    ),
	.i_Tx_Byte  (TX_DATA  ),
	.o_Tx_Active(TX_STATUS),
	.o_Tx_Serial(UART_TX),
	.o_Tx_Done  (  )
);

endmodule