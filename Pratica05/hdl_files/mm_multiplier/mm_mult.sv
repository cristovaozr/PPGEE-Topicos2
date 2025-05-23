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
	input calc_end_i
);

	reg [7:0] control_r;
	reg [7:0] AB_r;
	reg [7:0] Y_r;
	reg [7:0] status_r;
	
	assign A_o = AB_r[3:0];
	assign B_o = AB_r[7:4];
	assign mult4_enable_o = control_r[0];
	
	always @(posedge clk_i) begin
		Y_r <= Y_i;
		status_r <= {7'b0, calc_end_i};

		if (stb_i) begin	// STB (CS) asserted!
			
			if (we_i) begin	// Writing
				case(sel_i)
					4'b0001:	control_r <= writedata_i[7:0];
					4'b0010: AB_r <= writedata_i[7:0];
				endcase
				
			end else begin		// Reading
				case(sel_i)
					4'b0001: readdata_o <= {24'h000000, control_r};
					4'b0010: readdata_o <= {24'h000000, AB_r};
					4'b0100: readdata_o <= {24'h000000, Y_r};
					4'b1000: readdata_o <= {24'h000000, status_r};
				endcase
			end
			
		end else begin		// STB (CS) not asserted!
			readdata_o <= 32'hxxxxxxxx;
		end
	end

endmodule
