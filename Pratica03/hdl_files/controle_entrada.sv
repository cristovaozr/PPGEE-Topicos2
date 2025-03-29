`include "./hdl_files/controle_entrada_defines.sv"

module controle_entrada(
	input clk_i,
	input rst_i,
	input load_i,
	input [3:0] input_i,

	output compute_o,
	output [3:0] A_o,
	output [3:0] B_o
);

reg [3:0] A_reg;
reg [3:0] B_reg;
reg compute_reg;
controle_entrada_t fsm_state;

always @ (posedge clk_i, negedge rst_i) begin
	if (!rst_i) begin
		A_reg <= 4'b0;
		B_reg <= 4'b0;
		compute_reg <= 1'b0;
		fsm_state <= LOADER_IDLE;
	end else begin
	
		case (fsm_state)
		LOADER_IDLE: begin
			fsm_state <= !load_i ? LOADER_LOAD_A : LOADER_IDLE;
			compute_reg <= 1'b0;
		end
		
		LOADER_LOAD_A: begin
			A_reg <= input_i;
			B_reg <= B_reg;
			fsm_state <= !load_i ? LOADER_LOAD_B : LOADER_LOAD_A;
			compute_reg <= 1'b0;
		end
		
		LOADER_LOAD_B: begin
			A_reg <= A_reg;
			B_reg <= input_i;
			fsm_state <= !load_i ? LOADER_END : LOADER_LOAD_B;
			compute_reg <= 1'b0;
		end
		
		LOADER_END: begin
			A_reg <= A_reg;
			B_reg <= B_reg;
			fsm_state <= fsm_state;
			compute_reg = 1'b1;
		end
		
		endcase
	end
end

assign A_o = A_reg;
assign B_o = B_reg;
assign compute_o = compute_reg;

endmodule
