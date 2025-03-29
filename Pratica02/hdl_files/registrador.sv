module registrador
    #(               
        parameter  DATA_WIDTH = 32
    )
    (
    //Common signal:
    input clk, 
    input reset, 
    //:
    input  [DATA_WIDTH-1:0] data_i, //Data In
    output [DATA_WIDTH-1:0] data_o //Data Out
    ); 

// INTERNAL SIGNALS ################################



// INTERNAL REGS ###################################
reg [DATA_WIDTH-1:0] data_reg;

// INTERNAL LOGIC ##################################


//Update register
always @(posedge clk, negedge reset)
begin
    if(reset == 1'b0)
    begin
        data_reg <= 0;
    end 
    else 
    begin
        data_reg <= data_i;
    end
end

// Define data_o:

assign data_o = data_reg;


endmodule