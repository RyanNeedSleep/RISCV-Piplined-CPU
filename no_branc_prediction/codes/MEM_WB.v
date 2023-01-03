module MEM_WB(
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    ALU_rslt_i,
    ReadData_i,
    MEM_WB_Rd_i,

    RegWrite_o,
    MemtoReg_o,
    ALU_rslt_o,
    ReadData_o,
    MEM_WB_Rd_o
);

    input clk_i;
    input RegWrite_i;
    input MemtoReg_i;
    input [31:0] ALU_rslt_i;
    input [31:0] ReadData_i;
    input [4:0] MEM_WB_Rd_i;

    output reg RegWrite_o;
    output reg MemtoReg_o;
    output reg [31:0] ALU_rslt_o;
    output reg [31:0] ReadData_o;
    output reg [4:0] MEM_WB_Rd_o;

    always@(posedge clk_i) begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        ALU_rslt_o <= ALU_rslt_i;
        ReadData_o <= ReadData_i;
        MEM_WB_Rd_o <= MEM_WB_Rd_i;
    end 
    
endmodule