module ID_EX
(
    clk_i,
    rst_i,
    flush_i,
    RegWrite_i, 
    MemtoReg_i,
    MemRead_i, 
    MemWrite_i, 
    ALUOp_i, 
    ALUSrc_i,
    data1_i,
    data2_i, 
    imm_i,
    func73_i, 
    EX_rs1_i,
    EX_rs2_i,
    EX_rd_i,
    pc_otherwise_i,
    predict_taken_i,
    branch_i,

    RegWrite_o, 
    MemtoReg_o,
    MemRead_o, 
    MemWrite_o, 
    ALUOp_o, 
    ALUSrc_o,
    data1_o,
    data2_o, 
    imm_o,
    func73_o, 
    EX_rs1_o,
    EX_rs2_o,
    EX_rd_o,

    pc_otherwise_o,
    predict_taken_o,
    branch_o

);

    input clk_i;
    input rst_i;

    input RegWrite_i; 
    input MemtoReg_i;
    input MemRead_i;
    input MemWrite_i; 
    input [1:0] ALUOp_i; 
    input ALUSrc_i;
    input [31:0] data1_i;
    input [31:0] data2_i;
    input [31:0] imm_i;
    input [9:0] func73_i; 
    input [4:0] EX_rs1_i;
    input [4:0] EX_rs2_i;
    input [4:0] EX_rd_i;
    input [31:0] pc_otherwise_i;
    input predict_taken_i;
    input branch_i;
    input flush_i;

    output reg RegWrite_o;
    output reg MemtoReg_o;
    output reg MemRead_o;
    output reg MemWrite_o;
    output reg [1:0] ALUOp_o;
    output reg ALUSrc_o;
    output reg [31:0] data1_o;
    output reg [31:0] data2_o;
    output reg [31:0] imm_o;
    output reg [9:0] func73_o;
    output reg [4:0] EX_rs1_o;
    output reg [4:0] EX_rs2_o;
    output reg [4:0] EX_rd_o;
    output reg [31:0] pc_otherwise_o;
    output reg predict_taken_o;
    output reg branch_o;
    


always@(posedge clk_i or posedge rst_i) begin
    if(rst_i || flush_i) begin
        RegWrite_o <= 0;
        MemWrite_o <= 0;
        branch_o <= 0;
    end
    else begin 
    // RegWrite_o <= RegWrite_i;
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        ALUOp_o <= ALUOp_i;
        ALUSrc_o <= ALUSrc_i;
        data1_o <= data1_i;
        data2_o <= data2_i;
        imm_o <= imm_i;
        func73_o <= func73_i;
        EX_rs1_o <= EX_rs1_i;
        EX_rs2_o <= EX_rs2_i;
        EX_rd_o <= EX_rd_i;

        pc_otherwise_o <= pc_otherwise_i;
        branch_o <= branch_i; 
        predict_taken_o <= predict_taken_i;
    end
end

endmodule