module ALU_Control(
    func73_i, 
    ALUOp_i, 
    ALUCtrl_o
);
    input [9:0] func73_i;
    input [1:0] ALUOp_i;
    output reg [2:0] ALUCtrl_o;

    wire [11:0] op; 

    assign op = {ALUOp_i, func73_i};

    always@(*) begin
        case(ALUOp_i)
            2'b10: begin  
                case(func73_i)
                    10'b0000000_111:
                        ALUCtrl_o <= 3'b110;
                    10'b0000000_100:
                        ALUCtrl_o <= 3'b011;
                    10'b0000000_001:
                        ALUCtrl_o <= 3'b100;
                    10'b0000000_000:
                        ALUCtrl_o <= 3'b000;
                    10'b0100000_000:
                        ALUCtrl_o <= 3'b001;
                    10'b0000001_000:
                        ALUCtrl_o <= 3'b010;
                endcase
            end

            2'b11: begin
                case(func73_i[2:0])
                    3'b000:
                        ALUCtrl_o <= 3'b000;
                    3'b101:
                        ALUCtrl_o <= 3'b101;
                endcase
            end

            2'b00: begin
                ALUCtrl_o = 3'b000;
            end

            default: ALUCtrl_o = 3'b000;
        endcase  
    end 
    
endmodule
