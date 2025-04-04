`include "./hdl_files/multiplicador_4bits_defines.sv"

module multiplicador_4bits(
	input clk_i,
	input rst_i,
	input [3:0] A_i,
	input [3:0] B_i,
	input en_i,

	output [7:0] Y_o,
	output [3:0] fsm_state_o
);

reg [7:0] A_reg;
reg [3:0] B_reg;
reg [7:0] Y_reg;
multiplicador_state_t fsm_state;

always @ (posedge clk_i, negedge rst_i) begin
	if (!rst_i) begin
		A_reg <= 8'b0;
		B_reg <= 4'b0;
		Y_reg <= 8'b0;
		fsm_state <= MULT_IDLE;

	end else begin
		case (fsm_state)
		MULT_IDLE: begin
			A_reg <= {4'b0, A_i};
			B_reg <= B_i;
			fsm_state <= en_i ? MULT_BIT_0 : MULT_IDLE;
		end
		
		MULT_BIT_0,
		MULT_BIT_1,
		MULT_BIT_2,
		MULT_BIT_3: begin

			Y_reg <= B_reg[0]? Y_reg + A_reg : Y_reg;
			A_reg <= A_reg << 1;
			B_reg <= B_reg >> 1;

			if (fsm_state == MULT_BIT_0) fsm_state <= MULT_BIT_1;
			else if (fsm_state == MULT_BIT_1) fsm_state <= MULT_BIT_2;
			else if (fsm_state == MULT_BIT_2) fsm_state <= MULT_BIT_3;
			else fsm_state <= MULT_END;
		end
		
		MULT_END: begin
			fsm_state <= MULT_END;
		end
		
		endcase
	end
end

assign Y_o = Y_reg;
assign fsm_state_o = fsm_state;

endmodule
