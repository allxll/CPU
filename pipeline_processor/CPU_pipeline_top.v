module CPU_pipeline_top (
	input clk,    // Clock
//	input [7:0] switch,
	input switch,
	input UART_RX,
	output [7:0] led,
	output [11:0] digi,
	output UART_TX
);

wire reset = switch;
reg [2:0] counter;
reg div_clk;
initial begin
	div_clk = 0;
	counter = 0;
end

always @(posedge clk) begin 
	if(counter == 4) begin
		counter <= 0;
		div_clk <= ~div_clk;
	end
	else
		counter <= counter + 1;
end


CPU_pipeline processor(
	.reset (reset),
	.switch(),
	.led   (led),
	.digi  (digi),
	.clk    (div_clk),
	.UART_RX(UART_RX),
	.UART_TX(UART_TX)
	);


endmodule