`ifndef EXEMPLO_DEFINES_V
`define EXEMPLO_DEFINES_V

typedef enum logic [1:0] {
   ST_IDLE    = 2'b00, 
	ST_COMPUTE = 2'b01, 
	ST_END     = 2'b11
} estado_t;


`endif