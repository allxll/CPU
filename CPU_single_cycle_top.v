module CPU_single_cycle_top (
	input clk,    // Clock
//	input [7:0] switch,
	input switch,
	input UART_RX,
	output [7:0] led,
	output [11:0] digi,
	output UART_TX
);

wire reset = switch;

CPU_single processor(
	.reset (reset),
	.switch(),
	.led   (led),
	.digi  (digi),
	.clk   (clk),
	.UART_RX(UART_RX),
	.UART_TX(UART_TX)
	);


endmodule