`define TIME_100MS	23'd5000000

module czr_debounce #(parameter TIME_DEBOUNCE = `TIME_100MS)
(
	input rst_i,
	input clk_i,
	input signal_i,
	
	output signal_o
);

reg previous;
reg current;
reg [22:0] counter;
reg output_value;

always @ (posedge clk_i, negedge rst_i) begin
	if (!rst_i) begin
		counter <= 23'd0;
		previous <= 1'b1;
		current <= 1'b0;
		output_value <= 1'b0;

	end else begin
		previous <= current;
		current <= signal_i;
		
		if (previous == current) begin
			counter <= counter + 23'd1;
		end else begin
			counter <= 23'd0;
		end

		output_value <= (counter == TIME_DEBOUNCE) ? current : output_value;
			
	end
end

assign signal_o = output_value;

endmodule
