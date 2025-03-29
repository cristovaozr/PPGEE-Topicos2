`ifndef CONTROLE_ENTRADA_DEFINES
`define CONTROLE_ENTRADA_DEFINES

typedef enum logic[1:0] {
	LOADER_IDLE,
	LOADER_LOAD_A,
	LOADER_LOAD_B,
	LOADER_END
} controle_entrada_t;

`endif
