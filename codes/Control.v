module Control(
    opcode,
    noop, 
    rst_i,

    ALUOp_o,
    ALUSrc_o,
    branch_o,
    MemRead_o,
    MemWrite_o,
    RegWrite_o,
    MemtoReg_o
);
    input [6:0] opcode;
    input noop;
    input rst_i;
    
    output reg [1:0] ALUOp_o;
    output reg ALUSrc_o;
    output reg branch_o;
    output reg MemRead_o;
    output reg MemWrite_o;
    output reg RegWrite_o;
    output reg MemtoReg_o;

    wire [2:0] reduced;

    assign reduced = opcode[6:4]; // controlled by upper 3 bits

    always @(opcode or posedge rst_i or noop) begin
        if(rst_i) begin
            MemWrite_o <= 1'b0;
            RegWrite_o <= 1'b0;

            ALUOp_o <= 2'b00;
            ALUSrc_o <= 1'b0;
            branch_o <= 1'b0;
            MemRead_o <= 1'b0;
            MemtoReg_o <= 1'b0;

        end
        else if(noop) begin
                // Write forbidden
                MemWrite_o <= 1'b0;
                RegWrite_o <= 1'b0;

                // don't care
                ALUOp_o <= 2'b00;
                ALUSrc_o <= 1'b0;
                branch_o <= 1'b0;
                MemRead_o <= 1'b0;
                MemtoReg_o <= 1'b0;
        end
        else begin 
                case(reduced) 
                    3'b001: begin// I-format
                        ALUOp_o <= 2'b11;
                        ALUSrc_o <= 1'b1;
                        branch_o <= 1'b0;
                        MemRead_o <= 1'b0;
                        MemWrite_o <= 1'b0;
                        RegWrite_o <= 1'b1;
                        MemtoReg_o <= 1'b0;    
                    end    

                    3'b000: begin// lw
                        ALUOp_o <= 2'b00;
                        ALUSrc_o <= 1'b1;
                        branch_o <= 1'b0;
                        MemRead_o <= 1'b1;
                        MemWrite_o <= 1'b0;
                        RegWrite_o <= 1'b1;
                        MemtoReg_o <= 1'b1;
                    end

                    3'b011: begin // R format
                        ALUOp_o <= 2'b10;
                        ALUSrc_o <= 1'b0;
                        branch_o <= 1'b0;
                        MemRead_o <= 1'b0;
                        MemWrite_o <= 1'b0;
                        RegWrite_o <= 1'b1;
                        MemtoReg_o <= 1'b0;
                    end

                    3'b010: begin// sw
                        ALUOp_o <= 2'b00;
                        ALUSrc_o <= 1'b1;
                        branch_o <= 1'b0;
                        MemRead_o <= 1'b0;
                        MemWrite_o <= 1'b1;
                        RegWrite_o <= 1'b0;
                        MemtoReg_o <= 1'b0; // don't care
                    end

                    3'b110: begin// beq
                        ALUOp_o <= 2'b01;
                        ALUSrc_o <= 1'b0;
                        branch_o <= 1'b1;
                        MemRead_o <= 1'b0;
                        MemWrite_o <= 1'b0;
                        RegWrite_o <= 1'b0;
                        MemtoReg_o <= 1'b0; // don't care
                    end
                    
                endcase
            end
    end 
endmodule
