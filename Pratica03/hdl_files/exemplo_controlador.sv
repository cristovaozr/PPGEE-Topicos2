`include "./hdl_files/exemplo_defines.sv"

module exemplo_controlador
(
    input          clk_i,
    input          rst_i,
    input          strt_cmpt_i,
    output [ 1:0]  state_o
);

// INTERNAL SIGNALS ################################

estado_t  state, next_state;

// INTERNAL LOGIC ##################################

// Output logic
assign state_o = state;

//#################### SEQUENTIAL LOGIC

    // state update and reset
    always @(posedge clk_i, negedge rst_i) 
	 begin
        if (rst_i == 1'b0)
            state <= ST_IDLE;
        else
            state <= next_state;
    end



    // transiction logic
    always @(strt_cmpt_i,state) begin
        case (state)
            ST_IDLE:
            begin
                if(strt_cmpt_i)
                begin
                    next_state   <=  ST_COMPUTE;
                end
                else
                begin
                    next_state   <=  ST_IDLE;
                end
            end    
            ST_COMPUTE:
            begin   
                next_state     <= ST_END ;
            end
            
            ST_END:
                if(strt_cmpt_i)
                begin
                    next_state   <=  ST_END;
                end
                else
                begin
                    next_state   <=  ST_IDLE;
                end
            default: 
            begin   
                next_state     <= ST_IDLE;
            end
        endcase
    end

endmodule