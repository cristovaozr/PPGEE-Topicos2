`include "./hdl_files/mm_multiplier/mm_mult_defines.sv"

module mm_mult(
	// Common signals
	input clk_i,
	input rst_i_n,
	// Avalon-MM Interface
	output [3:0] address_i,
	output [31:0] readdata_o,
	input [31:0] writedata_i,
	input we_i,
	input [3:0] sel_i,
	input stb_i,
	input ack_i,
	
	// mult4b interface
	output [3:0] A_o,
	output [3:0] B_o,
	output mult4_enable_o,
	input [7:0] Y_i,
	input calc_end_i,
	
	// Debug
	output [7:0] AB_dbg
);

	reg control_r;
	reg [7:0] AB_r;
	reg [7:0] Y_r;
	reg status_r;
	
	assign A_o = AB_r[3:0];
	assign B_o = AB_r[7:4];
	assign mult4_enable_o = control_r;
	
	always @(posedge clk_i) begin
		Y_r <= Y_i;
		status_r <= calc_end_i & control_r;

		if (stb_i && we_i) begin	// STB (CS) asserted and is writing!
			case(sel_i)
				4'b0001:	control_r <= writedata_i[0];
				4'b0010: AB_r <= writedata_i[15:8]; // FIXME this is supposed to be 15:8!!
			endcase
		end
	end

	assign readdata_o = {
		7'b0, status_r,
		Y_r,
		AB_r,
		7'b0, control_r
	};
	
	assign AB_dbg = AB_r;
	
endmodule
