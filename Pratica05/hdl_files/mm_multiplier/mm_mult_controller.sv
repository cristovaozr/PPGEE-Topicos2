`include "./hdl_files/mm_multiplier/mm_mult_defines.sv"

module mm_mult_controller(
	// Common signals
	input clk_i,
	input rst_i_n,
	// Controller sensible signals
	input start_i,
	input calc_end_i,
	input c0_i,
	// Output signal
	output mm_mult_state_e state_o
);

mm_mult_state_e state, next_state;

assign state_o = state;

always @(posedge clk_i, negedge rst_i_n) begin
	if (!rst_i_n) begin
		state <= ST_MM_MULT_IDLE;
	end else begin
		state <= next_state;
	end
end

always @(start_i, calc_end_i, c0_i, state) begin
	case (state)
		ST_MM_MULT_IDLE: begin
			next_state <= start_i ? ST_MM_MULT_START_MULTIPLICATION : ST_MM_MULT_IDLE;
		end
		
		ST_MM_MULT_START_MULTIPLICATION: begin
			next_state <= ST_MM_MULT_WAIT_FOR_RESULT;
		end
		
		ST_MM_MULT_WAIT_FOR_RESULT: begin
			next_state <= calc_end_i ? ST_MM_MULT_STORE_Y : ST_MM_MULT_WAIT_FOR_RESULT;
		end
		
		ST_MM_MULT_STORE_Y: begin
			next_state <= ST_MM_MULT_UPDATE_STATUS_1;
		end
		
		ST_MM_MULT_UPDATE_STATUS_1: begin
			next_state <= ST_MM_MULT_WAIT_C0;
		end
		
		ST_MM_MULT_WAIT_C0: begin
			next_state <= c0_i ? ST_MM_MULT_CLEAR_STATUS : ST_MM_MULT_WAIT_C0;
		end
		
		ST_MM_MULT_CLEAR_STATUS: begin
			next_state <= ST_MM_MULT_IDLE;
		end
		
		default: begin
			next_state <= ST_MM_MULT_IDLE;
		end
	endcase
end

endmodule
