module forward (
	//  ex and mem forward
	input        RegWr_EX_MEM     ,
	input  [4:0] RegisterRd_EX_MEM,
	input  [4:0] RegisterRt_ID_EX ,
	input  [4:0] RegisterRs_ID_EX ,
	input        RegWr_MEM_WB     ,
	input  [4:0] RegisterRd_MEM_WB,
	//  lw - sw  forward
	input  [1:0] MemtoReg_MEM_WB  ,
	input        MemWr_EX_MEM     ,
	input  [4:0] RegisterRt_EX_MEM, // it is necessary to extent it into the EX_MEM register.
	output [1:0] ForwardA         ,
	output [1:0] ForwardB         ,
	output       ForwardMEM
);
// ForwardA:   forward the first operand (replace databus A)
//   00:  the operand comes from the original databus A
//   10:  the operand is forwarded from the prior ALU result
//   01:  the operand is forwarded from data memory (lw) or an earlier ALU result

// ForwardB:   forward the second operand (replace databus B)
//  values have similar meanings with ForwardA.




// EX forwarding is prior to MEM forwarding.
	assign ForwardA = (RegWr_EX_MEM && (RegisterRd_EX_MEM != 5'b0) && (RegisterRd_EX_MEM == RegisterRs_ID_EX))? 2'b10:
		(RegWr_MEM_WB && (RegisterRd_MEM_WB != 5'b0) && (RegisterRd_MEM_WB == RegisterRs_ID_EX))? 2'b01:
		2'b00;

	assign ForwardB = (RegWr_EX_MEM && (RegisterRd_EX_MEM != 5'b0) && (RegisterRd_EX_MEM == RegisterRt_ID_EX))?2'b10:
		(RegWr_MEM_WB && (RegisterRd_MEM_WB != 5'b0) && (RegisterRd_MEM_WB == RegisterRt_ID_EX))?2'b01:
		2'b00;


	assign ForwardMEM = ((MemtoReg_MEM_WB == 2'b01) && MemWr_EX_MEM && (RegisterRd_MEM_WB == RegisterRt_EX_MEM))?1:0;


endmodule