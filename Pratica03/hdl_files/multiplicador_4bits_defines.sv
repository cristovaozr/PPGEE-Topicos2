`ifndef MULTIPLICADOR_4BITS_DEFINES
`define MULTIPLICADOR_4BITS_DEFINES

typedef enum logic[2:0] {
	MULT_IDLE,
	MULT_BIT_0,
	MULT_BIT_1,
	MULT_BIT_2,
	MULT_BIT_3,
	MULT_END
} multiplicador_state_t;

`endif