`include "./hdl_files/dpram/dpram_defines.sv"

module dpram(
	// Common signals
	input clk_i,
	input rst_i_n,
	// Avalon-MM Interface
	output write_o,
	output [3:0] address_o,
	input [31:0] readdata_i,
	output [31:0] writedata_o,
	// mult4b interface
	output [3:0] A_o,
	output [3:0] B_o,
	output mult4_enable_o,
	input [7:0] Y_i,
	input calc_end_i,
	// Debug interface
	output dpram_state_e state_dbg
);

	dpram_state_e state_w;
	assign start_w = readdata_i[0];
	assign c0_w = !readdata_i[0];
	assign state_dbg = state_w;

	dpram_controller dpram_controller_inst(
		// Common interface
		.clk_i (clk_i),
		.rst_i_n(rst_i_n),
		// Controller signals
		.start_i(start_w),
		.calc_end_i(calc_end_i),
		.c0_i(c0_w),
		// FSM state
		.state_o(state_w)
	);

	always @(state_w, readdata_i, calc_end_i, Y_i) begin
		case(state_w)
			ST_DPRAM_IDLE: begin
				write_o <= 1'b0;
				writedata_o <= 32'hxxxxxxxx;
				address_o <= `DPRAM_ADDR_CONTROL;
				A_o <= 4'bxxxx;
				B_o <= 4'bxxxx;
				mult4_enable_o <= 1'b0;
			end
			
			ST_DPRAM_READ_AB: begin
				write_o <= 1'b0;
				writedata_o <= 32'hxxxxxxxx;
				address_o <= `DPRAM_ADDR_DATA_IN;
				A_o <= readdata_i[3:0];
				B_o <= readdata_i[7:4];
				mult4_enable_o <= 1'b0;
			end
			
			ST_DPRAM_START_MULTIPLICATION: begin
				write_o <= 1'b0;
				writedata_o <= 32'hxxxxxxxx;
				address_o <= `DPRAM_ADDR_DATA_IN;
				A_o <= readdata_i[3:0];
				B_o <= readdata_i[7:4];
				mult4_enable_o <= 1'b1;
			end
			
			ST_DPRAM_WAIT_FOR_RESULT: begin
				write_o <= 1'b0;
				writedata_o <= {24'b0, Y_i};
				address_o <= `DPRAM_ADDR_DATA_OUT;
				A_o <= 4'bxxxx;
				B_o <= 4'bxxxx;
				mult4_enable_o <= 1'b1;
			end
			
			ST_DPRAM_STORE_Y: begin
				write_o <= 1'b1;
				writedata_o <= {24'b0, Y_i};
				address_o <= `DPRAM_ADDR_DATA_OUT;
				A_o <= 4'bxxxx;
				B_o <= 4'bxxxx;
				mult4_enable_o <= 1'b1;
			end
			
			ST_DPRAM_UPDATE_STATUS_1: begin
				write_o <= 1'b0;
				writedata_o <= 32'h00000001;
				address_o <= `DPRAM_ADDR_STATUS;
				A_o <= 4'bxxxx;
				B_o <= 4'bxxxx;
				mult4_enable_o <= 1'b0;
			end
			
			ST_DPRAM_UPDATE_STATUS_2: begin
				write_o <= 1'b1;
				writedata_o <= 32'h00000001;
				address_o <= `DPRAM_ADDR_STATUS;
				A_o <= 4'bxxxx;
				B_o <= 4'bxxxx;
				mult4_enable_o <= 1'b0;
			end
			
			ST_DPRAM_WAIT_C0: begin
				write_o <= 1'b0;
				writedata_o <= 32'hxxxxxxxx;
				address_o <= `DPRAM_ADDR_CONTROL;
				A_o <= 4'bxxxx;
				B_o <= 4'bxxxx;
//				mult4_enable_o <= readdata_i[0];
				mult4_enable_o <= 1'b0;
			end
			
			ST_DPRAM_CLEAR_STATUS: begin
				write_o <= 1'b1;
				writedata_o <= 32'h00000000;
				address_o <= `DPRAM_ADDR_STATUS;
				A_o <= 4'bxxxx;
				B_o <= 4'bxxxx;
				mult4_enable_o <= 1'b0;
			end
			
			default: begin
				write_o <= 1'b0;
				writedata_o <= 32'hxxxxxxxx;
				address_o <= `DPRAM_ADDR_CONTROL;
				A_o <= 4'bxxxx;
				B_o <= 4'bxxxx;
				mult4_enable_o <= 1'b0;
			end
		endcase
	end

endmodule
