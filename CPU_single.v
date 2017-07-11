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

parameter c_CLKS_PER_BIT    = 10416;

wire [2:0] PCSrc;
wire [1:0] RegDst;
wire RegWr;
wire ALUSrc1;
wire ALUSrc2;
wire Sign;
wire MemWr;
wire MemRd;
wire [1:0] MemToReg;
wire EXTOp;
wire LUOp;
wire IRQ;


// initial begin
// 	IRQ = 0;
// end



wire [31:0] Instruction;
wire [5:0] ALUFun;
wire [31:0] PC_plus4;

wire [31:0] ALUOut;
wire [31:0] EXTOut;
wire [31:0] DataBus_A;
wire [31:0] DataBus_B;
wire [31:0] DataBus_C;
wire [31:0] PC;


wire baudclk;
wire [7:0] TX_DATA;
wire TX_EN;
wire TX_STATUS;
wire [7:0] RX_DATA;
wire RX_STATUS;


Control CTL(
	.IRQ        (IRQ),
	.Instruction(Instruction),
	.PCSrc      (PCSrc),
	.RegDst     (RegDst),
	.RegWr      (RegWr),
	.ALUSrc1    (ALUSrc1),
	.ALUSrc2    (ALUSrc2),
	.ALUFun     (ALUFun),
	.Sign       (Sign),
	.MemWr      (MemWr),
	.MemRd      (MemRd),
	.MemToReg   (MemToReg),
	.EXTOp      (EXTOp),
	.LUOp       (LUOp)
);




PC_add PCA(
	.reset (reset),
	.clk   (clk),
	.PCSrc (PCSrc),
	.ALUOut(ALUOut[0]),
	.EXTOut(EXTOut),
	.JT    (Instruction[25:0]),
	.A     (DataBus_A),
	.PC    (PC),
	.plus4 (PC_plus4)
);


Inst_Mem IM(
	.addr(PC[31:0]),
	.data(Instruction)
);


wire [4:0] Addr_destination;
assign Addr_destination = (RegDst[1:0] == 2'b00)?Instruction[15:11]:
						  (RegDst[1:0] == 2'b01)?Instruction[20:16]:
						  (RegDst[1:0] == 2'b10)?5'b11111:5'b11010;

RegFile RF(
	.reset(reset),
	.clk  (clk),
	.wr   (RegWr),
	.addr1(Instruction[25:21]),   // Rs
	.addr2(Instruction[20:16]),   // Rt
	.addr3(Addr_destination),
	.data3(DataBus_C),
	.data1(DataBus_A),
	.data2(DataBus_B)
);


wire [31:0] ALU_in1;
wire [31:0] ALU_in2;
wire [31:0] LUOut;
assign ALU_in1 = ALUSrc1?Instruction[10:6]:DataBus_A;
assign ALU_in2 = ALUSrc2?LUOut:DataBus_B;

ALU ALU_(
	.ALUFun(ALUFun),
	.A     (ALU_in1),
	.B     (ALU_in2),
	.Sign  (Sign),
	.S     (ALUOut)
);

assign LUOut = LUOp? {Instruction[15:0], 16'b0}: EXTOut;
assign EXTOut = EXTOp? {{16{Instruction[15]}}, Instruction[15:0]}:
					   {16'b0, Instruction[15:0]};


wire [31:0] Data_Mem_Out;
wire [31:0] Data_PE_Out;
wire [31:0] Data_Out;

Data_Mem DM(
	.reset(reset),
	.clk  (clk),
	.rd   (MemRd),
	.wr   (MemWr),
	.addr (ALUOut),
	.rdata(Data_Mem_Out),
	.wdata(DataBus_B)
);

assign Data_Out =  ALUOut[30]?Data_PE_Out:Data_Mem_Out;

assign DataBus_C = (MemToReg == 2'b00)?ALUOut:
				   (MemToReg == 2'b01)?Data_Out:
				   (MemToReg == 2'b10)?PC_plus4:0;


Peripheral PE(
	.reset 	   (reset),
	.clk       (clk),
	.rd        (MemRd),
	.wr        (MemWr),
	.addr      (ALUOut),
	.wdata     (DataBus_B),
	.switch    (switch),
	.RX_STATUS (RX_STATUS),
	.TX_STATUS (TX_STATUS),
	.RX_DATA  (RX_DATA),

	.rdata     (Data_PE_Out),
	.led       (led),
	.digi      (digi),
	.irqout    (IRQ),
	.TX_EN     (TX_EN),
	.TX_DATA   (TX_DATA)
);


uart_rx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) i_uart_rx (
	.i_Clock    (clk), 
	.i_Rx_Serial(UART_RX), 
	.o_Rx_DV    (RX_STATUS), 
	.o_Rx_Byte  (RX_DATA)
);



uart_tx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) i_uart_tx (
	.i_Clock    (clk        ),
	.i_Tx_DV    (TX_EN    ),
	.i_Tx_Byte  (TX_DATA  ),
	.o_Tx_Active(TX_STATUS),
	.o_Tx_Serial(UART_TX),
	.o_Tx_Done  (  )
);

endmodule