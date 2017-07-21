`timescale 1ns/1ps

module Peripheral (
	input reset,clk,
	input rd,wr,
	input [31:0] addr,
	input [31:0] wdata,
	input [7:0] switch,
	input RX_STATUS,
	input TX_STATUS,
	input [7:0] RX_DATA,
	output reg [31:0] rdata,
	output reg [7:0] led,
	output reg [11:0] digi,
	output irqout,
	output TX_EN,
	output [7:0] TX_DATA
);


reg [31:0] TH,TL;
reg [2:0] TCON;
reg [7:0] UART_TXD, UART_RXD;
reg [4:0] UARTCON;
reg [1:0] UART_status_counter;


// UARTCON:
//  UARTCON[0]  :   no use
//  UARTCON[1]  :   no use
//  UARTCON[2]  :   i.e, TX_EN. start sending TX_DATA  (1/enable)
//  UARTCON[3]  :   data received flag  (1/received)
//  UARTCON[4]  :   no use
//
//      Bit 3 is cleared when loaded by software.
// 
//		Software inquires repeatly UARTCON[3] to determine 
//  when to load data from the UART_RXD address.
//  	It is required to reset UARTCON=0 in the software 
//	after receiving a data. 
//		



// Test Purpose Only
initial begin
	led = 0;
	digi = 0;
	UART_status_counter = 0;
end

//



assign irqout = TCON[2];
assign TX_EN = UARTCON[2];
assign TX_DATA = UART_TXD;


always@(*) begin

	if(rd) begin
		case(addr)
			32'h40000000: rdata <= TH;			
			32'h40000004: rdata <= TL;			
			32'h40000008: rdata <= {29'b0,TCON};				
			32'h4000000C: rdata <= {24'b0,led};			
			32'h40000010: rdata <= {24'b0,switch};
			32'h40000014: rdata <= {20'b0,digi};
			32'h40000018: rdata <= {24'b0, UART_TXD};
			32'h4000001c: rdata <= {24'b0, UART_RXD};
			32'h40000020: begin	
							rdata <= {27'b0,UARTCON};
							//UARTCON[3] <= 1'b0;
						  end
			default: rdata <= 32'b0;
		endcase
	end
	else
		rdata <= 32'b0;
end




always@(posedge clk) begin
	if(~reset) begin
		TH <= 32'b0;
		TL <= 32'b0;
		TCON <= 3'b0;	
		UARTCON <= 5'b0;
		UART_RXD <= 32'b0;
		UART_TXD <= 32'b0;
		led <= 0;
		digi <= 0;
	end
	else begin
		if(TCON[0]) begin	//timer is enabled
			if(TL==32'hffffffff) begin
				TL <= TH;
				if(TCON[1]) begin 
					TCON[2] <= 1'b1;
				end		//irq is enabled
			end
			else begin
				TL <= TL + 1;
				TCON[2] <= 0; 
			end
		end
		if (UART_status_counter == 0) begin
			if (RX_STATUS) begin
				UART_RXD <= RX_DATA;
				UARTCON[3] <= 1'b1;
			end
			UARTCON[2] <= 0;
		end
		else if (UART_status_counter == 1) begin
			UART_status_counter <= 0;
			UARTCON[2] <= 1;
		end
		else begin
			if (~TX_STATUS) begin
				UART_status_counter <= 0;
				UARTCON[2] <= 1;
			end
			else begin
				UART_status_counter <= 2;
			end
		end


		if(wr) begin
			case(addr)
				32'h40000000: TH <= wdata;
				32'h40000004: TL <= wdata;
				32'h40000008: TCON <= wdata[2:0];		
				32'h4000000C: led <= wdata[7:0];			
				32'h40000014: digi <= wdata[11:0];
				32'h40000018: begin
								UART_TXD <= wdata[7:0];
								if(TX_STATUS) 
									UART_status_counter <= 2;
								else 
									UART_status_counter <= 1;
							  end
				32'h40000020: UARTCON <= wdata[4:0];
				default: ;
			endcase
		end
	end



end
endmodule

