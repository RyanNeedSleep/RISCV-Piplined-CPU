module branch_predictor
(
    clk_i, 
    rst_i,

    update_i,
	result_i,
	predict_o
);
input clk_i, rst_i, update_i, result_i;
output predict_o;

reg predict_o;
reg [1:0] state;

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10; 
parameter S3 = 2'b11;

// TODO

always@(posedge rst_i) begin
    // initial state is strongly taken S0
    state <= S0;
    predict_o <= 1;
end

always@(state) begin
    case(state)
    S0: 
        predict_o = 1;

    S1:
        predict_o = 1; 

    S2: 
        predict_o = 0;
    
    S3:
        predict_o = 0; 
    endcase
end 


always@(posedge clk_i) begin
    if(update_i) begin
        case(state)
            S0:
                if(result_i)
                    state <= S0;
                else
                    state <= S1;
            S1:
                if(result_i)
                    state <= S0;
                else 
                    state <= S2;
            S2:
                if(result_i)
                        state <= S1;
                    else 
                        state <= S3;
            S3: 
                if(result_i)
                        state <= S2;
                    else 
                        state <= S3;
        endcase 
    end
end

endmodule
