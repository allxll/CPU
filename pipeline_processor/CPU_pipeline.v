`timescale 1ns/1ps

module CPU_pipeline (
	input         reset  ,
	input         clk    , // Clock
	input  [ 7:0] switch ,
	input         UART_RX,
	output [ 7:0] led    ,
	output [11:0] digi   ,
	output        UART_TX
);

	// Uart signals
	wire TX_EN;
	wire [7:0] RX_DATA;
	wire [7:0] TX_DATA;
	wire TX_STATUS;
	wire RX_STATUS;


//parameter c_CLKS_PER_BIT    = 10416;

	wire        IRQ               ; // interruption
	wire [31:0] PC_in             ;
	wire        IF_ID_Wr          ;
	wire        ID_EX_Flush       ;
	wire        IF_ID_Flush       ;
	wire        PCWr              ;
	wire [31:0] PC_in_J           ;
	wire        ID_EX_Flush_Hazard;


	// Signals in the IF stage
	wire [31:0] Instruction_IF;
	wire [31:0] PC_IF         ;

	// Calculation done in the IF stage.
	wire [31:0] PC_plus4_IF;


	// Control signals generated in ID stage.
	wire [1:0] RegDst_ID  ;
	wire       RegWr_ID   ;
	wire       ALUSrc1_ID ;
	wire       ALUSrc2_ID ;
	wire [5:0] ALUFun_ID  ;
	wire       Sign_ID    ;
	wire       MemWr_ID   ;
	wire       MemRd_ID   ;
	wire [1:0] MemToReg_ID;
	wire       EXTOp_ID   ;
	wire       LUOp_ID    ;
	wire       isJ_ID     ;
	wire       isBranch_ID;

	// Signal in IF/ID register
	wire [31:0] Instruction_IF_ID;
	wire [31:0] PC_plus4_IF_ID   ;
	wire [31:0] PC_IF_ID         ;
	wire [15:0] Imm16_IF_ID      ;
	wire [ 4:0] Shamt_IF_ID      ;
	wire [ 4:0] RegisterRd_IF_ID ;
	wire [ 4:0] RegisterRt_IF_ID ;
	wire [ 4:0] RegisterRs_IF_ID ;
	wire [25:0] JT_IF_ID         ;


	//  Calculation in ID stage.
	wire [31:0] EXTOut_ID  ;
	wire [31:0] LUOut_ID   ;
	wire [31:0] ConBA_ID   ;
	wire [31:0] JTplusPC_ID;


	//  Data read from register pile in ID stage
	wire [31:0] DataBus_A_ID;
	wire [31:0] DataBus_B_ID;



	//  Data stored in ID/EX register
	wire [31:0] PC_plus4_ID_EX  ;
	wire [ 4:0] RegisterRs_ID_EX;
	wire [ 4:0] RegisterRt_ID_EX;
	wire [ 5:0] ALUFun_ID_EX    ;
	wire        ALUSrc1_ID_EX   ;
	wire        ALUSrc2_ID_EX   ;
	wire [31:0] DataBus_A_ID_EX ;
	wire [31:0] DataBus_B_ID_EX ;
	wire        Sign_ID_EX      ;
	wire [31:0] LUOut_ID_EX     ;
	wire [ 4:0] Shamt_ID_EX     ;
	wire        MemRd_ID_EX     ;
	wire        MemWr_ID_EX     ;
	wire        RegWr_ID_EX     ;
	wire [ 1:0] MemToReg_ID_EX  ;
	wire [ 4:0] RegisterRd_ID_EX;
	wire [ 1:0] RegDst_ID_EX    ;
	wire        isBranch_ID_EX  ;
	wire [31:0] ConBA_ID_EX     ;

	//  Data calculated in EX stage, including forwarding logic and ALU calculation
	wire [ 1:0] ForwardA      ;
	wire [ 1:0] ForwardB      ;
	wire        ForwardMEM    ; // to handle lw-sw hazard (to implement)
	wire [31:0] ALUOut_EX     ;
	wire [31:0] ALU_in1_EX    ;
	wire [31:0] ALU_in2_EX    ;
	wire [31:0] ALU_reg_in1_EX;
	wire [31:0] ALU_reg_in2_EX;




	// Data stored in the EX/MEM register
	wire [31:0] PC_plus4_EX_MEM  ;
	wire [ 4:0] RegisterRt_EX_MEM;
	wire        MemWr_EX_MEM     ;
	wire        MemRd_EX_MEM     ;
	wire [31:0] DataBus_B_EX_MEM ;
	wire [31:0] ALUOut_EX_MEM    ;
	wire [ 1:0] RegDst_EX_MEM    ;
	wire        RegWr_EX_MEM     ;
	wire [ 1:0] MemToReg_EX_MEM  ;
	wire [ 4:0] RegisterRd_EX_MEM;

	// Data obtained from Data_Memory and Peripheral Module in the MEM stage.
	wire [31:0] Data_Mem_Out_MEM;
	wire [31:0] Data_PE_Out_MEM ;

	// Data calculated in the MEM stage
	wire [31:0] Data_Out_MEM;



	// Data stored in the MEM/WB register
	wire [ 4:0] RegisterRd_MEM_WB  ;
	wire [ 4:0] RegisterRt_MEM_WB  ;
	wire [31:0] PC_plus4_MEM_WB    ;
	wire [31:0] Data_Mem_Out_MEM_WB;
	wire [31:0] ALUOut_MEM_WB      ;
	wire [ 1:0] MemtoReg_MEM_WB    ;
	wire [ 1:0] RegDst_MEM_WB      ;
	wire        RegWr_MEM_WB       ;

	// Data calculated in the WB stage
	wire [ 4:0] Address_dest_WB;
	wire [31:0] DataBus_C_WB   ;




	// calculations listed below (mainly muxes, except for 2 adders)

	assign PC_in_J     = isJ_ID?JTplusPC_ID:PC_plus4_IF;
	assign PC_in       = (isBranch_ID_EX && ALUOut_EX)?ConBA_ID_EX:PC_in_J;
	assign IF_ID_Flush = (isJ_ID || (isBranch_ID_EX && ALUOut_EX))?1:0;
	assign ID_EX_Flush = (ID_EX_Flush_Hazard || (isBranch_ID_EX && ALUOut_EX))?1:0;

	assign PC_plus4_IF = {PC_IF[31], PC_IF[30:0]+31'h00000004};

	assign LUOut_ID  = LUOp_ID? {Imm16_IF_ID, 16'b0}: EXTOut_ID;
	assign EXTOut_ID = EXTOp_ID? {{16{Imm16_IF_ID[15]}}, Imm16_IF_ID}:
		{16'b0, Imm16_IF_ID};
	assign ConBA_ID    = PC_plus4_IF_ID + {EXTOut_ID[29:0], 2'b00};
	assign JTplusPC_ID = {PC_IF_ID[31:28], JT_IF_ID, 2'b0};

	assign ALU_reg_in1_EX = (ForwardA==2'b01)?((MemtoReg_MEM_WB==2'b01)?Data_Out_MEM:ALUOut_MEM_WB):
		(ForwardA==2'b10)?ALUOut_EX_MEM:DataBus_A_ID_EX; // Data_Out_MEM will be calculated later in the MEM stage
	assign ALU_reg_in2_EX = (ForwardB==2'b01)?((MemtoReg_MEM_WB==2'b01)?Data_Out_MEM:ALUOut_MEM_WB):
		(ForwardB==2'b10)?ALUOut_EX_MEM:DataBus_B_ID_EX;
	assign ALU_in1_EX = ALUSrc1_ID_EX?Shamt_ID_EX:ALU_reg_in1_EX;
	assign ALU_in2_EX = ALUSrc2_ID_EX?LUOut_ID_EX:ALU_reg_in2_EX;

	assign Data_Out_MEM = ALUOut_EX_MEM[30]?Data_PE_Out_MEM:Data_Mem_Out_MEM;

	assign Address_dest_WB = (RegDst_MEM_WB == 2'b00)?RegisterRd_MEM_WB:
		(RegDst_MEM_WB == 2'b01)?RegisterRt_MEM_WB:
		(RegDst_MEM_WB == 2'b10)?5'b11111:5'b11010;
	assign DataBus_C_WB = (MemtoReg_MEM_WB == 2'b00)?ALUOut_MEM_WB:
		(MemtoReg_MEM_WB == 2'b01)?Data_Out_MEM:
		(MemtoReg_MEM_WB == 2'b10)?PC_plus4_MEM_WB:0;





///////////////////////////////////////
///////   Module instances ////////////
///////////////////////////////////////
	PC i_PC (
		.PCWr (PCWr ),
		.reset(reset),
		.clk  (clk  ),
		.PC_in(PC_in),
		.PC   (PC_IF)
	);

	Inst_Mem IM (
		.addr(PC_IF         ),
		.data(Instruction_IF)
	);

	IFtoID i_IFtoID (
		.clk             (clk              ),
		.reset           (reset            ),
		.IF_ID_Wr        (IF_ID_Wr         ),
		.IF_ID_Flush     (IF_ID_Flush      ),
		.Instruction     (Instruction_IF   ),
		.PC_plus4        (PC_plus4_IF      ),
		.Instruction_out (Instruction_IF_ID),
		.PC_plus4_out    (PC_plus4_IF_ID   ),
		.PC_in           (PC_IF            ),
		.PC_out          (PC_IF_ID         ),
		.Imm16_IF_ID     (Imm16_IF_ID      ),
		.Shamt_IF_ID     (Shamt_IF_ID      ),
		.RegisterRd_IF_ID(RegisterRd_IF_ID ),
		.RegisterRt_IF_ID(RegisterRt_IF_ID ),
		.RegisterRs_IF_ID(RegisterRs_IF_ID ),
		.JT_IF_ID        (JT_IF_ID         )
	);


	Control i_CTL (
		.IRQ        (IRQ              ),
		.Instruction(Instruction_IF_ID),
		//	.PCSrc      (PCSrc),
		.RegDst     (RegDst_ID        ),
		.RegWr      (RegWr_ID         ),
		.ALUSrc1    (ALUSrc1_ID       ),
		.ALUSrc2    (ALUSrc2_ID       ),
		.ALUFun     (ALUFun_ID        ),
		.Sign       (Sign_ID          ),
		.MemWr      (MemWr_ID         ),
		.MemRd      (MemRd_ID         ),
		.MemToReg   (MemToReg_ID      ),
		.EXTOp      (EXTOp_ID         ),
		.LUOp       (LUOp_ID          ),
		.isJ        (isJ_ID           ),
		.isBranch   (isBranch_ID      )
	);


	RegFile RF (
		.reset(reset           ),
		.clk  (clk             ),
		.wr   (RegWr_MEM_WB    ),
		.addr1(RegisterRs_IF_ID), // Rs
		.addr2(RegisterRt_IF_ID), // Rt
		.addr3(Address_dest_WB ),
		.data3(DataBus_C_WB    ),
		.data1(DataBus_A_ID    ),
		.data2(DataBus_B_ID    )
	);


	IDtoEX i_IDtoEX (
		.clk           (clk             ),
		.reset         (reset           ),
		.ID_EX_Flush   (ID_EX_Flush     ),
		.PC_plus4      (PC_plus4_IF_ID  ),
		.PC_plus4_out  (PC_plus4_ID_EX  ),
		.RegisterRs    (RegisterRs_IF_ID),
		.RegisterRt    (RegisterRt_IF_ID),
		.ALUFun        (ALUFun_ID       ),
		.ALUSrc1       (ALUSrc1_ID      ),
		.ALUSrc2       (ALUSrc2_ID      ),
		.DataBus_A     (DataBus_A_ID    ),
		.DataBus_B     (DataBus_B_ID    ),
		.Sign          (Sign_ID         ),
		.Immediate     (LUOut_ID        ),
		.Shamt         (Shamt_IF_ID     ),
		.RegisterRs_out(RegisterRs_ID_EX),
		.RegisterRt_out(RegisterRt_ID_EX),
		.ALUFun_out    (ALUFun_ID_EX    ),
		.ALUSrc1_out   (ALUSrc1_ID_EX   ),
		.ALUSrc2_out   (ALUSrc2_ID_EX   ),
		.DataBus_A_out (DataBus_A_ID_EX ),
		.DataBus_B_out (DataBus_B_ID_EX ),
		.Sign_out      (Sign_ID_EX      ),
		.Immediate_out (LUOut_ID_EX     ),
		.Shamt_out     (Shamt_ID_EX     ),
		.MemWr         (MemWr_ID        ),
		.MemRd         (MemRd_ID        ),
		.MemRd_out     (MemRd_ID_EX     ),
		.MemWr_out     (MemWr_ID_EX     ),
		.RegWr         (RegWr_ID        ),
		.RegisterRd    (RegisterRd_IF_ID),
		.RegDst        (RegDst_ID       ),
		.MemToReg      (MemToReg_ID     ),
		.RegWr_out     (RegWr_ID_EX     ),
		.MemToReg_out  (MemToReg_ID_EX  ),
		.RegisterRd_out(RegisterRd_ID_EX),
		.RegDst_out    (RegDst_ID_EX    ),
		.isBranch      (isBranch_ID     ),
		.isBranch_out  (isBranch_ID_EX  ),
		.ConBA         (ConBA_ID),
		.ConBA_ID_EX   (ConBA_ID_EX)
	);


	forward i_forward (
		.RegWr_EX_MEM     (RegWr_EX_MEM     ),
		.RegisterRd_EX_MEM(RegisterRd_EX_MEM),
		.RegisterRt_ID_EX (RegisterRt_ID_EX ),
		.RegisterRs_ID_EX (RegisterRs_ID_EX ),
		.RegWr_MEM_WB     (RegWr_MEM_WB     ),
		.RegisterRd_MEM_WB(RegisterRd_MEM_WB),
		.MemtoReg_MEM_WB  (MemtoReg_MEM_WB  ),
		.MemWr_EX_MEM     (MemWr_EX_MEM     ),
		.RegisterRt_EX_MEM(RegisterRt_EX_MEM),
		.RegDst_MEM_WB    (RegDst_MEM_WB),
		.RegDst_EX_MEM    (RegDst_EX_MEM),
		.RegisterRt_MEM_WB(RegisterRt_MEM_WB),
		.ForwardA         (ForwardA         ),
		.ForwardB         (ForwardB         ),
		.ForwardMEM       (ForwardMEM       )
	);



	ALU ALU_ (
		.ALUFun(ALUFun_ID_EX),
		.A     (ALU_in1_EX  ),
		.B     (ALU_in2_EX  ),
		.Sign  (Sign_ID_EX  ),
		.S     (ALUOut_EX   )
	);


	EXtoMEM i_EXtoMEM (
		.clk           (clk              ),
		.reset         (reset            ),
		.PC_plus4      (PC_plus4_ID_EX   ),
		.PC_plus4_out  (PC_plus4_EX_MEM  ),
		.RegisterRt    (RegisterRt_ID_EX ),
		.RegisterRt_out(RegisterRt_EX_MEM),
		.MemWr         (MemWr_ID_EX      ),
		.MemRd         (MemRd_ID_EX      ),
		.DataBus_B     (DataBus_B_ID_EX  ),
		.ALUOut        (ALUOut_EX        ),
		.MemWr_out     (MemWr_EX_MEM     ),
		.MemRd_out     (MemRd_EX_MEM     ),
		.DataBus_B_out (DataBus_B_EX_MEM ),
		.ALUOut_out    (ALUOut_EX_MEM    ),
		.RegDst        (RegDst_ID_EX     ),
		.RegWr         (RegWr_ID_EX      ),
		.MemToReg      (MemToReg_ID_EX   ),
		.RegisterRd    (RegisterRd_ID_EX ),
		.RegDst_out    (RegDst_EX_MEM    ),
		.RegWr_out     (RegWr_EX_MEM     ),
		.MemToReg_out  (MemToReg_EX_MEM  ),
		.RegisterRd_out(RegisterRd_EX_MEM)
	);


	Data_Mem DM (
		.reset(reset           ),
		.clk  (clk             ),
		.rd   (MemRd_EX_MEM    ),
		.wr   (MemWr_EX_MEM    ),
		.addr (ALUOut_EX_MEM   ),
		.rdata(Data_Mem_Out_MEM),
		.wdata(DataBus_B_EX_MEM)
	);



	Peripheral PE (
		.reset    (reset           ),
		.clk      (clk             ),
		.rd       (MemRd_EX_MEM    ),
		.wr       (MemWr_EX_MEM    ),
		.addr     (ALUOut_EX_MEM   ),
		.wdata    (DataBus_B_EX_MEM),
		//	.switch    (switch),
		.RX_STATUS(RX_STATUS       ),
		.TX_STATUS(TX_STATUS       ),
		.RX_DATA  (RX_DATA         ),
		
		.rdata    (Data_PE_Out_MEM ),
		.led      (led             ),
		.digi     (digi            ),
		.irqout   (IRQ             ),
		.TX_EN    (TX_EN           ),
		.TX_DATA  (TX_DATA         )
	);


	MEMtoWB i_MEMtoWB (
		.clk             (clk                ),
		.reset           (reset              ),
		.PC_plus4        (PC_plus4_EX_MEM    ),
		.Data_Mem_Out    (Data_Mem_Out_MEM   ),
		.ALUOut          (ALUOut_EX_MEM      ),
		.RegDst          (RegDst_EX_MEM      ),
		.RegWr           (RegWr_EX_MEM       ),
		.MemToReg        (MemToReg_EX_MEM    ),
		.RegisterRd      (RegisterRd_EX_MEM  ),
		.RegisterRt      (RegisterRt_EX_MEM  ),

		.PC_plus4_out    (PC_plus4_MEM_WB    ),
		.Data_Mem_Out_out(Data_Mem_Out_MEM_WB),
		.ALUOut_out      (ALUOut_MEM_WB      ),
		.RegDst_out      (RegDst_MEM_WB      ),
		.RegWr_out       (RegWr_MEM_WB       ),
		.RegisterRd_out  (RegisterRd_MEM_WB  ),
		.RegisterRt_out  (RegisterRt_MEM_WB  ),
		.MemToReg_out    (MemtoReg_MEM_WB)
	);

	hazard i_hazard (
		.MemRd_ID_EX     (MemRd_ID_EX       ),
		.RegisterRt_ID_EX(RegisterRt_ID_EX  ),
		.RegisterRs_IF_ID(RegisterRs_IF_ID  ),
		.RegisterRt_IF_ID(RegisterRt_IF_ID  ),
		.PCWr            (PCWr              ),
		.IF_ID_Wr        (IF_ID_Wr          ),
		.ID_EX_Flush     (ID_EX_Flush_Hazard)
	);



	// UART signals

	uart_rx i_uart_rx (
		.i_Clock    (clk      ),
		.i_Rx_Serial(UART_RX  ),
		.o_Rx_DV    (RX_STATUS),
		.o_Rx_Byte  (RX_DATA  )
	);



	uart_tx i_uart_tx (
		.i_Clock    (clk      ),
		.i_Tx_DV    (TX_EN    ),
		.i_Tx_Byte  (TX_DATA  ),
		.o_Tx_Active(TX_STATUS),
		.o_Tx_Serial(UART_TX  ),
		.o_Tx_Done  (         )
	);

endmodule