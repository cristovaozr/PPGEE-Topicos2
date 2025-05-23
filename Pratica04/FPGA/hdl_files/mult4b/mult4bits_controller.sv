`include "./hdl_files/mult4b/mult4bits_defines.sv"

module mult4bits_controller(
	// Common signals
	input clk_i,
	input rst_i_n,
	// Controller interface
	input en_i,
	output multiplicador_state_e state_o
);

multiplicador_state_e state, next_state;

assign state_o = state;

always @(posedge clk_i, negedge rst_i_n) begin
	if (!rst_i_n) begin
		state <= MULT_IDLE;
	end else begin
		state <= next_state;
	end
end

always @(state, en_i) begin
	case (state)
		MULT_IDLE: begin
			next_state <= en_i ? MULT_BIT_0 : MULT_IDLE;
		end
		
		MULT_BIT_0: begin
			next_state <= MULT_BIT_1;
		end
		
		MULT_BIT_1: begin
			next_state <= MULT_BIT_2;
		end
		
		MULT_BIT_2: begin
			next_state <= MULT_BIT_3;
		end
		
		MULT_BIT_3: begin
			next_state <= MULT_END;
		end
		
		MULT_END: begin
			next_state <= !en_i ? MULT_IDLE : MULT_END;
		end
		
		default: begin
			next_state <= MULT_IDLE;
		end
	endcase
end

endmodule
