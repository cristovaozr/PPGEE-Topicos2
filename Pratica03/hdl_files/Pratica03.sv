module Pratica03(

	//////////// ADC //////////
	output		          		ADC_CONVST,
	output		          		ADC_SCK,
	output		          		ADC_SDI,
	input 		          		ADC_SDO,

	//////////// ARDUINO //////////
	inout 		    [15:0]		ARDUINO_IO,
	inout 		          		ARDUINO_RESET_N,

	//////////// CLOCK //////////
	input 		          		FPGA_CLK1_50,
	input 		          		FPGA_CLK2_50,
	input 		          		FPGA_CLK3_50,

	//////////// HDMI //////////
	inout 		          		HDMI_I2C_SCL,
	inout 		          		HDMI_I2C_SDA,
	inout 		          		HDMI_I2S,
	inout 		          		HDMI_LRCLK,
	inout 		          		HDMI_MCLK,
	inout 		          		HDMI_SCLK,
	output		          		HDMI_TX_CLK,
	output		          		HDMI_TX_DE,
	output		    [23:0]		HDMI_TX_D,
	output		          		HDMI_TX_HS,
	input 		          		HDMI_TX_INT,
	output		          		HDMI_TX_VS,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [7:0]		LED,

	//////////// SW //////////
	input 		     [3:0]		SW
);

wire [3:0] A_wire;
wire [3:0] B_wire;
wire en_signal;
wire key_1_debounce;

debounce debounce_inst(
	.clk_i(FPGA_CLK1_50),
	.rst_i(KEY[0]),
	.signal_i(KEY[1]),
	.signal_o(key_1_debounce)
);

controle_entrada controle_entrada_int(
	.clk_i(FPGA_CLK1_50),
	.rst_i(KEY[0]),
	.load_i(key_1_debounce),
	.input_i(SW),
	
	.compute_o(en_signal),
	.A_o(A_wire),
	.B_o(B_wire)
);

multiplicador_4bits mult_4bit_inst(
	.clk_i(FPGA_CLK1_50),
	.rst_i(KEY[0]),
	.A_i(A_wire),
	.B_i(B_wire),
	.en_i(en_signal),

	.Y_o(LED)
);

endmodule
