`include "./hdl_files/mult4b/mult4bits_defines.sv"

module mult4bits(
	// Common signals
	input clk_i,
	input rst_i_n,
	// Controller signals
	input en_i,
	// Multiplier input
	input [3:0] A_i,
	input [3:0] B_i,
	// Multiplier output
	output [7:0] Y_o,
	output mult_done_o
);

multiplicador_state_e state_w;

mult4bits_controller mult4bits_controller_inst(
	// Common signals
	.clk_i(clk_i),
	.rst_i_n(rst_i_n),
	// Controller interface
	.en_i(en_i),
	.state_o(state_w)
);

reg [7:0] A_r;
reg [3:0] B_r;
reg [7:0] Y_r;

assign Y_o = Y_r;

always @(posedge clk_i) begin
	case (state_w)
		MULT_IDLE: begin
			A_r <= {4'h0, A_i};
			B_r <= B_i;
			Y_r <= 8'h00;
			mult_done_o <= 1'b0;
		end
		
		MULT_BIT_0, 
		MULT_BIT_1,
		MULT_BIT_2,
		MULT_BIT_3: begin
			A_r <= A_r << 1;
			B_r <= B_r >> 1;
			Y_r <= B_r[0] ? (Y_r + A_r) : Y_r;
			mult_done_o <= 1'b0;
		end
		
		MULT_END: begin
			A_r <= A_r;
			B_r <= B_r;
			Y_r <= Y_r;
			mult_done_o <= 1'b1;
		end
	endcase
end

endmodule
