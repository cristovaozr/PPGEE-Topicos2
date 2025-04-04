// Controlador de acesso a Dual Port RAM

`include "./hdl_files/dpram_controller_defines.sv"

module dpram_controller(
	// DPRAM Control signals
	output [3:0] dpram_s2_addr_o;
	output dpram_s2_clken_o;
	output dpram_s2_write_en_o;
	input	 [31:0] dpram_s2_readdata;
	output [31:0] dpram_s2_writedata;
	
	input clk_i,
	input rst_i_n,
);

dpram_controller_state_e fsm_state, next_state;

always @ (posedge clk_i, negedge rst_i_n)
begin
	if (!rst_i_n) begin
		fsm_state <= DPRAM_CONTROL_IDLE;
		next_state <= DPRAM_CONTROL_IDLE;
	end else begin
		fsm_state <= next_state;
	end
end

always @ (fsm_state, next_state)
begin

	case (fsm_state)
	DPRAM_CONTROL_IDLE: begin
	end

	DPRAM_CONTROL_READ_AB: begin
	end

	DPRAM_CONTROL_ENABLE_MULT: begin
	end

	DPRAM_CONTROL_WAIT_FOR_RESULT: begin
	end

	DPRAM_CONTROL_STORE_Y: begin
	end

	DPRAM_CONTROL_SIGNAL_STATUS_1: begin
	end

	DPRAM_CONTROL_WAIT_FOR_CONTROL_CLEAR: begin
	end

	endcase

end

endmodule
