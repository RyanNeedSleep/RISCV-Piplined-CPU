module FU(
        EX_MEM_RegWrite, 
        MEM_WB_RegWrite,
        EX_MEME_Rd,
        MEM_WB_Rd, 
        ID_EX_Rs1,
        ID_EX_Rs2,

        ForwardA,
        ForwardB
);

    input EX_MEM_RegWrite; 
    input MEM_WB_RegWrite;
    input [4:0] EX_MEME_Rd;
    input [4:0] MEM_WB_Rd; 
    input [4:0] ID_EX_Rs1;
    input [4:0] ID_EX_Rs2;

    output reg [1:0] ForwardA;
    output reg [1:0] ForwardB;

    always @(*) begin

        ForwardA = 2'b00;
        ForwardB = 2'b00;
        
        if(EX_MEM_RegWrite == 1 && EX_MEME_Rd != 0 && EX_MEME_Rd == ID_EX_Rs1) begin
            ForwardA = 2'b10;
        end 

        if(EX_MEM_RegWrite == 1 && EX_MEME_Rd != 0 && EX_MEME_Rd == ID_EX_Rs2) begin 
            ForwardB = 2'b10;
        end

        if(MEM_WB_RegWrite == 1 && MEM_WB_Rd != 0 && MEM_WB_Rd == ID_EX_Rs1 && !(EX_MEM_RegWrite == 1 && EX_MEME_Rd != 0 && EX_MEME_Rd == ID_EX_Rs1)) begin
            ForwardA = 2'b01;
        end 

        if(MEM_WB_RegWrite == 1 && MEM_WB_Rd != 0 && MEM_WB_Rd == ID_EX_Rs2 && !(EX_MEM_RegWrite == 1 && EX_MEME_Rd != 0 && EX_MEME_Rd == ID_EX_Rs2)) begin
            ForwardB = 2'b01;
        end 
    end

endmodule