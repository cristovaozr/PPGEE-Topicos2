`include "./hdl_files/dpram/dpram_defines.sv"

module dpram_controller(
	// Common signals
	input clk_i,
	input rst_i_n,
	// Controller sensible signals
	input start_i,
	input calc_end_i,
	input c0_i,
	// Output signal
	output dpram_state_e state_o
);

dpram_state_e state, next_state;

assign state_o = state;

always @(posedge clk_i, negedge rst_i_n) begin
	if (!rst_i_n) begin
		state <= ST_DPRAM_IDLE;
	end else begin
		state <= next_state;
	end
end

always @(start_i, calc_end_i, c0_i, state) begin
	case (state)
		ST_DPRAM_IDLE: begin
			next_state <= start_i ? ST_DPRAM_READ_AB : ST_DPRAM_IDLE;
		end
		
		ST_DPRAM_READ_AB: begin
			next_state <= ST_DPRAM_START_MULTIPLICATION;
		end
		
		ST_DPRAM_START_MULTIPLICATION: begin
			next_state <= ST_DPRAM_WAIT_FOR_RESULT;
		end
		
		ST_DPRAM_WAIT_FOR_RESULT: begin
			next_state <= calc_end_i ? ST_DPRAM_STORE_Y : ST_DPRAM_WAIT_FOR_RESULT;
		end
		
		ST_DPRAM_STORE_Y: begin
			next_state <= ST_DPRAM_UPDATE_STATUS_1;
		end
		
		ST_DPRAM_UPDATE_STATUS_1: begin
			next_state <= ST_DPRAM_UPDATE_STATUS_2;
		end
		
		ST_DPRAM_UPDATE_STATUS_2: begin
			next_state <= ST_DPRAM_WAIT_C0;
		end
		
		ST_DPRAM_WAIT_C0: begin
			next_state <= c0_i ? ST_DPRAM_CLEAR_STATUS : ST_DPRAM_WAIT_C0;
		end
		
		ST_DPRAM_CLEAR_STATUS: begin
			next_state <= ST_DPRAM_IDLE;
		end
		
		default: begin
			next_state <= ST_DPRAM_IDLE;
		end
	endcase
end

endmodule
