module EX_MEM
(
    clk_i,
    rst_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALU_rslt_i,
    WriteData_i,
    EX_MEM_Rd_i,
    
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALU_rslt_o,
    WriteData_o,
    EX_MEM_Rd_o,
);
    
    input clk_i;
    input rst_i;
    input RegWrite_i;
    input MemtoReg_i;
    input MemRead_i;
    input MemWrite_i;
    input [31:0] ALU_rslt_i;
    input [31:0] WriteData_i;
    input [4:0] EX_MEM_Rd_i;
    
    output reg RegWrite_o;
    output reg MemtoReg_o;
    output reg MemRead_o;
    output reg MemWrite_o;
    output reg [31:0] ALU_rslt_o;
    output reg [31:0] WriteData_o;
    output reg [4:0] EX_MEM_Rd_o;

    always@(posedge rst_i) begin 
        if(rst_i) begin
            RegWrite_o <= 0;
        end
    end 
    always@(posedge clk_i) begin
        RegWrite_o <= RegWrite_i; 
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i; 
        MemWrite_o <= MemWrite_i;
        ALU_rslt_o <= ALU_rslt_i;
        WriteData_o <= WriteData_i;
        EX_MEM_Rd_o <= EX_MEM_Rd_i;
    end 


endmodule