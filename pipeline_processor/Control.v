module Control (
	input         IRQ        ,
	input  [31:0] Instruction,
	// output [2:0] PCSrc,
	output [ 1:0] RegDst     ,
	output        RegWr      ,
	output        ALUSrc1    ,
	output        ALUSrc2    ,
	output [ 5:0] ALUFun     ,
	output        Sign       ,
	output        MemWr      ,
	output        MemRd      ,
	output [ 1:0] MemToReg   ,
	output        EXTOp      ,
	output        LUOp       ,
	output        isJ        ,
	output        isBranch
);


	wire Except;

	assign isJ = ((Instruction[31:26] == 6'h0 && (Instruction[5:0] == 6'h08 || Instruction[5:0] == 6'h09))
				  || Instruction[31:26] == 6'h03 || Instruction[31:26] == 6'h02)?1:0;

	assign isBranch = (Instruction[31:26] == 6'h01 || Instruction[31:26] == 6'h04 || 
					Instruction[31:26] == 6'h05 || Instruction[31:26] == 6'h06 || Instruction[31:26] == 6'h07)?1:0;


	assign Except = !((Instruction[31:26] == 6'h00 && (Instruction[5:0] == 6'h20 || Instruction[5:0] == 6'h2a || Instruction[5:0] == 6'h03 || Instruction[5:0] == 6'h02 ||
				Instruction[5:0] == 6'h21 || Instruction[5:0] == 6'h22 || Instruction[5:0] == 6'h23 || Instruction[5:0] == 6'h24  || Instruction[5:0] == 6'h25 ||
				Instruction[5:0] == 6'h26 || Instruction[5:0] == 6'h27 || Instruction[5:0] == 6'h00 || Instruction[5:0] == 6'h08 || Instruction[5:0] == 6'h09)) ||
		Instruction[31:26] == 6'h01 || Instruction[31:26] == 6'h06 || Instruction[31:26] == 6'h0a || Instruction[31:26] == 6'h0b || Instruction[31:26] == 6'h05 || Instruction[31:26] == 6'h04 ||
		Instruction[31:26] == 6'h23 || Instruction[31:26] == 6'h2b || Instruction[31:26] == 6'h0f || Instruction[31:26] == 6'h08 || Instruction[31:26] == 6'h09 || Instruction[31:26] == 6'h0c ||
		Instruction[31:26] == 6'h02 || Instruction[31:26] == 6'h03 || Instruction[31:26] == 6'h07 || Instruction[31:26] == 6'h0d);


// assign PCSrc =  IRQ? 3'b100:    // Interrupt

// 				Except? 3'b101:    // Exception

// 				(Instruction[31:26] == 6'h02 || Instruction[31:26] == 6'h03 )? 3'b010:  // j, jal

// 				(Instruction[31:26] == 6'h00 && (Instruction[5:0] == 6'h08 || Instruction[5:0] == 6'h09))? 3'b011:  // jr jalr

// 				(Instruction[31:26] == 6'h04 || Instruction[31:26] == 6'h05 || Instruction[31:26] == 6'h06 || Instruction[31:26] == 6'h07 || Instruction[31:26] == 6'h01)? 3'b001:   // bxx*5
// 				3'b000;



	assign RegDst = (Except || IRQ)? 3:
		(Instruction[31:26] == 6'h03)? 2:  // jal
		(Instruction[31:26] == 6'h00)? 0: 1;   // R-type instructions


	assign RegWr = (IRQ || Except)?1:(Instruction[31:26] == 6'h2b || Instruction[31:26] == 6'h04 || Instruction[31:26] == 6'h05 || Instruction[31:26] == 6'h06 || Instruction[31:26] == 6'h07 ||
		Instruction[31:26] == 6'h01 || Instruction[31:26] == 6'h02 || (Instruction[31:26] == 6'h00 && Instruction[5:0] == 6'h08))? 0: 1;  // sw, bxx*5, j, jr     ps: nop is regarded as sll.


	assign ALUSrc1 = (Instruction[31:26] == 6'h00 && (Instruction[5:0] == 6'h00 || Instruction[5:0] == 6'h02 || Instruction[5:0] == 6'h03))? 1: 0; // sll, srl, sra

	assign ALUSrc2 = (Instruction[31:26] == 6'h00 || Instruction[31:26] == 6'h04 || Instruction[31:26] == 6'h05 || Instruction[31:26] == 6'h06 || Instruction[31:26] == 6'h07 || Instruction[31:26] == 6'h01)? 0: 1; // R-type and bxx*5


	assign ALUFun = ((Instruction[31:26] == 6'h00 && (Instruction[5:0] == 6'h20 || Instruction[5:0] == 6'h21)) || Instruction[31:26] == 6'h23 || Instruction[31:26] == 6'h2b || Instruction[31:26] == 6'h0f || Instruction[31:26] == 6'h08 || Instruction[31:26] == 6'h09 )? 6'b000000:
		(Instruction[31:26] == 6'h00 && (Instruction[5:0] == 6'h22 || Instruction[5:0] == 6'h23))? 6'b000001:
		((Instruction[31:26] == 6'h00 && Instruction[5:0] == 6'h24) || Instruction[31:26] == 6'h0c)? 6'b011000:
		((Instruction[31:26] == 6'h00 && Instruction[5:0] == 6'h25) || Instruction[31:26] == 6'h0d)? 6'b011110:
		(Instruction[31:26] == 6'h00 && Instruction[5:0] == 6'h26)? 6'b010110:
		(Instruction[31:26] == 6'h00 && Instruction[5:0] == 6'h27)? 6'b010001:
		((Instruction[31:26] == 6'h00 && (Instruction[5:0] == 6'h00 || Instruction[5:0] == 6'h08 || Instruction[5:0] == 6'h09)) || Instruction[31:26] == 6'h02 || Instruction[31:26] == 6'h03)? 6'b100000:  // contain nop, sll j, jal jr jalr
		(Instruction[31:26] == 6'h00 && Instruction[5:0] == 6'h02)? 6'b100001:
		(Instruction[31:26] == 6'h00 && Instruction[5:0] == 6'h03)? 6'b100011:
		(Instruction[31:26] == 6'h04)? 6'b110011:
		(Instruction[31:26] == 6'h05)? 6'b110001:
		((Instruction[31:26] == 6'h00 && Instruction[5:0] == 6'h2a) || Instruction[31:26] == 6'h0a || Instruction[31:26] == 6'h0b)? 6'b110101:
		(Instruction[31:26] == 6'h06)? 6'b111101:
		(Instruction[31:26] == 6'h01)? 6'b111011:
		6'b111111; // Instruction[31:26] == 6'h07


	assign Sign = ((Instruction[31:26] == 6'h00 && (Instruction[5:0] == 6'h21 || Instruction[5:0] == 6'h23)) || Instruction[31:26] == 6'h09 || Instruction[31:26] == 6'h0b)? 0 : 1;  // addu, subu, addiu, sltiu

	assign MemRd = (Instruction[31:26] == 6'h23)? 1:0; // lw

	assign MemWr = (Instruction[31:26] == 6'h2b)? 1:0; //sw

	assign MemToReg = (Except || IRQ || Instruction[31:26] == 6'h03 || (Instruction[31:26] == 6'h00 && Instruction[5:0] == 6'h09))? 2:  // jal, jalr, Interrupt, Exception
		(Instruction[31:26] == 6'h23)? 1:0; // lw




	assign EXTOp = (Instruction[31:26] == 6'h0c || Instruction[31:26] == 6'h0d)? 0 : 1; // andi

	assign LUOp = (Instruction[31:26] == 6'h0f)? 1:0; // lui




endmodule