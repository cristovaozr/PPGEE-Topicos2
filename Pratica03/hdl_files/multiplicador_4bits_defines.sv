`ifndef MULTIPLICADOR_4BITS_DEFINES
`define MULTIPLICADOR_4BITS_DEFINES

typedef enum logic[2:0] {
	MULT_IDLE = 3'd1,
	MULT_BIT_0 = 3'd2,
	MULT_BIT_1 = 3'd3,
	MULT_BIT_2 = 3'd4,
	MULT_BIT_3 = 3'd5,
	MULT_END = 3'd6
} multiplicador_state_t;

`endif