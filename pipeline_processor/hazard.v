module hazard (
	input MemRd_ID_EX,
	input [4:0] RegisterRt_ID_EX,
	input [4:0] RegisterRs_IF_ID,
	input [4:0] RegisterRt_IF_ID,
	output reg PCWr,
	output reg IF_ID_Wr,
	output reg ID_EX_Flush
);


always @(*) begin : proc_lw_use
	if(MemRd_ID_EX && 
		(RegisterRt_ID_EX == RegisterRt_IF_ID || RegisterRt_ID_EX == RegisterRs_IF_ID)) begin
		PCWr = 0;
		IF_ID_Wr = 0;
		ID_EX_Flush = 1;
	end
	else begin
		PCWr = 1;
		IF_ID_Wr = 1;
		ID_EX_Flush = 0;
	end
end

// This module aims to handle load-use hazard

endmodule