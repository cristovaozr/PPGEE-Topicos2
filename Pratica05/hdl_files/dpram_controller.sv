// Controlador de acesso a Dual Port RAM

`include "./hdl_files/dpram_controller_defines.sv"

module dpram_controller(
	// Common signals
	input clk_i,
	input rst_i_n,
	
	// DPRAM Control signals
	output [1:0] dpram_s2_addr_o,
	output dpram_s2_write_en_o,			// Active HIGH
	output start_calculation_o,
	input end_calculation_i,
	
	input [7:0] dpram_readdata_i,
	output [7:0] dpram_writedata_o
);

dpram_controller_state_e fsm_state, next_state;

always @ (posedge clk_i, negedge rst_i_n)
begin
//	if (!rst_i_n) begin
//		fsm_state <= DPRAM_CONTROL_IDLE;
//		next_state <= DPRAM_CONTROL_IDLE;
//
//	end else begin
//		fsm_state <= next_state;
//	end
end

always @ (fsm_state, next_state)
begin

	case (fsm_state)
	DPRAM_CONTROL_IDLE: begin
		dpram_s2_addr_o <= `DPRAM_CONTROL_ADDR;
		dpram_writedata_o <= dpram_writedata_o;
		// If CONTROL[0] is HIGH, goto next state
		next_state <= dpram_readdata_i[0] ? DPRAM_CONTROL_READ_AB : DPRAM_CONTROL_IDLE;
	end

	DPRAM_CONTROL_READ_AB: begin
		dpram_s2_addr_o <= `DPRAM_DATA_IN_ADDR;
		dpram_writedata_o <= dpram_writedata_o;
		next_state <= DPRAM_CONTROL_ENABLE_MULT;
	end

	DPRAM_CONTROL_ENABLE_MULT: begin
		start_calculation_o <= 1'b1;
		dpram_writedata_o <= dpram_writedata_o;
		dpram_s2_addr_o <= dpram_s2_addr_o;
		next_state <= DPRAM_CONTROL_WAIT_FOR_RESULT;
	end

	DPRAM_CONTROL_WAIT_FOR_RESULT: begin
		dpram_writedata_o <= dpram_writedata_o;
		dpram_s2_addr_o <= dpram_s2_addr_o;
		next_state <= end_calculation_i ? DPRAM_CONTROL_STORE_Y : DPRAM_CONTROL_WAIT_FOR_RESULT;
	end

	DPRAM_CONTROL_STORE_Y: begin
		dpram_s2_addr_o <= `DPRAM_DATA_OUT_ADDR;
		dpram_s2_write_en_o <= 1'b1;
		next_state <= DPRAM_CONTROL_SIGNAL_STATUS_1;
		dpram_writedata_o <= dpram_writedata_o;
	end

	DPRAM_CONTROL_SIGNAL_STATUS_1: begin
		dpram_s2_addr_o <= `DPRAM_STATUS_ADDR;
		dpram_writedata_o <= 8'b1;
		next_state <= DPRAM_CONTROL_WAIT_FOR_CONTROL_CLEAR;
	end

	DPRAM_CONTROL_WAIT_FOR_CONTROL_CLEAR: begin
		dpram_s2_addr_o <= `DPRAM_CONTROL_ADDR;
		// If CONTROL[0] is LOW, goto next state
		next_state <= !dpram_readdata_i[0] ? DPRAM_CONTROL_IDLE : DPRAM_CONTROL_WAIT_FOR_CONTROL_CLEAR;
		dpram_writedata_o <= dpram_writedata_o;
	end

	endcase

end

endmodule
